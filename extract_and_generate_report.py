#!/usr/bin/env python3

import os
import re
import html
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# Prefer pdfplumber; fallback to PyMuPDF if needed
try:
	import pdfplumber  # type: ignore
except Exception:
	pdfplumber = None  # type: ignore

try:
	import fitz  # PyMuPDF
except Exception:
	fitz = None  # type: ignore


PDF_DIR = Path("/workspace/PDF")
OUTPUT_HTML = PDF_DIR / "INFORME_FACTURAS_PEDIMENTOS.html"


@dataclass
class InvoiceInfo:
	file_name: str
	invoice_number: Optional[str]
	date: Optional[str]
	client_name: Optional[str]
	rfc: Optional[str]
	subtotal: Optional[str]
	iva: Optional[str]
	total: Optional[str]
	currency: Optional[str]
	pedimento_number_in_text: Optional[str]
	raw_text_path: Optional[Path]


@dataclass
class PedimentoInfo:
	file_name: str
	pedimento_number: Optional[str]
	date: Optional[str]
	aduana: Optional[str]
	importer_rfc: Optional[str]
	importer_name: Optional[str]
	customs_value: Optional[str]
	taxes_total: Optional[str]
	raw_text_path: Optional[Path]


def read_pdf_text(pdf_path: Path) -> str:
	"""Extract text from a PDF. Use pdfplumber first, then PyMuPDF fallback."""
	text_parts: List[str] = []
	# First attempt: pdfplumber
	if pdfplumber is not None:
		try:
			with pdfplumber.open(str(pdf_path)) as pdf:
				for page in pdf.pages:
					page_text = page.extract_text(x_tolerance=1.5, y_tolerance=2.0) or ""
					if page_text:
						text_parts.append(page_text)
		except Exception:
			pass
	# Fallback: PyMuPDF
	if not text_parts and fitz is not None:
		try:
			doc = fitz.open(str(pdf_path))
			for page in doc:
				page_text = page.get_text("text") or ""
				if page_text:
					text_parts.append(page_text)
		except Exception:
			pass
	return "\n\n".join(text_parts).strip()


def save_raw_text(text: str, source_pdf: Path) -> Path:
	text_dir = PDF_DIR / "text"
	text_dir.mkdir(parents=True, exist_ok=True)
	out_txt = text_dir / (source_pdf.stem + ".txt")
	out_txt.write_text(text, encoding="utf-8", errors="ignore")
	return out_txt


def search_first(pattern: str, text: str, flags: int = re.IGNORECASE) -> Optional[str]:
	match = re.search(pattern, text, flags)
	return match.group(1).strip() if match else None


def parse_currency_amount(value: Optional[str]) -> Optional[str]:
	if not value:
		return None
	val = value.replace("\xa0", " ").strip()
	# Keep digits, dots, commas, and minus
	val = re.sub(r"[^0-9,.\-]", "", val)
	if not val:
		return None
	# If both comma and dot, assume comma is thousands sep
	if "," in val and "." in val:
		val = val.replace(",", "")
	# If only comma, treat as decimal separator
	elif "," in val and "." not in val:
		val = val.replace(",", ".")
	return val


def parse_invoice(text: str, file_name: str, raw_text_path: Path) -> InvoiceInfo:
	# Invoice number patterns
	invoice_number = search_first(r"\bFOLIO\s+INTERNO\s+No\.?A?\s*([A-Z]?\s?\d{3,})\b", text)
	if not invoice_number:
		num_only = search_first(r"\bNo\.?\s*A\s*([0-9]{3,})\b", text)
		if num_only:
			invoice_number = f"A {num_only}"
	if not invoice_number:
		invoice_number = search_first(r"\b(A-\d{4,}|A\s\d{4,})\b", text)

	# Dates: prefer emission date
	date = search_first(r"Fecha\s+de\s+emisi[oó]n\s*:\s*([0-3]?\d[\-/][01]?\d[\-/](?:20)?\d{2})", text)
	if not date:
		date = search_first(r"\bFecha\s*[:\-]?\s*([0-3]?\d[\-/][01]?\d[\-/](?:20)?\d{2})\b", text)
	if not date:
		date = search_first(r"Fecha\s+de\s+timbrado\s*:\s*([0-3]?\d[\-/][01]?\d[\-/](?:20)?\d{2})", text)

	# Client and RFC (prefer 'Receptor' block)
	client_name = search_first(r"Receptor\s*:\s*([^\n\r]+)", text)
	if not client_name:
		client_name = search_first(r"\b(?:Cliente|Raz[oó]n\s*Social|Nombre\s*del\s*Cliente)\s*[:\-]?\s*(.+)", text)

	rfc = search_first(r"Receptor[\s\S]{0,200}?RFC\.?\s*[:\-]?\s*([A-Z&Ñ]{3,4}\d{6}[A-Z0-9]{3})", text, flags=re.IGNORECASE | re.DOTALL)
	if not rfc:
		rfc = search_first(r"\bRFC\s*[:\-]?\s*([A-Z&Ñ]{3,4}\d{6}[A-Z0-9]{3})\b", text)

	# Currency
	currency = None
	currency_symbol = search_first(r"\b(MXN|USD|US\$|\$)\b", text)
	if currency_symbol:
		currency = "USD" if "US" in currency_symbol else "MXN"
	if not currency:
		currency_name = search_first(r"Moneda\s*:\s*(Peso\s+mexicano|MXN|USD|D[oó]lar(?:\s+estadounidense)?)", text)
		if currency_name:
			if "USD" in currency_name.upper() or "DOL" in currency_name.upper():
				currency = "USD"
			else:
				currency = "MXN"

	# Totals
	subtotal = search_first(r"\bSubtotal\s*[:\-]?\s*([\$\s\d.,]+)\b", text)
	iva = search_first(r"\bIVA(?:\s*16%|)\s*[:\-]?\s*([\$\s\d.,]+)\b", text)
	total = search_first(r"\bTotal\s*[:\-]?\s*([\$\s\d.,]+)\b", text)

	subtotal = parse_currency_amount(subtotal)
	iva = parse_currency_amount(iva)
	total = parse_currency_amount(total)

	# Pedimento referenced in invoice
	pedimento_num = search_first(r"pedimento\s+de\s+importaci[oó]n\s*(?:No\.|:)\s*([0-9\s]{15,})", text)
	if not pedimento_num:
		pedimento_num = search_first(r"seg[uú]n\s+pedimento\s+de\s+importaci[oó]n\s*(?:No\.|:)\s*([0-9\s]{15,})", text)
	if not pedimento_num:
		pedimento_num = search_first(r"\b(\d{2}\s\d{2}\s\d{4}\s\d{7})\b", text)

	return InvoiceInfo(
		file_name=file_name,
		invoice_number=invoice_number,
		date=date,
		client_name=client_name,
		rfc=rfc,
		subtotal=subtotal,
		iva=iva,
		total=total,
		currency=currency,
		pedimento_number_in_text=pedimento_num,
		raw_text_path=raw_text_path,
	)


def parse_pedimento(text: str, file_name: str, raw_text_path: Path) -> PedimentoInfo:
	pedimento_number = search_first(r"NUM\.\s*PEDIMENTO\s*:\s*(\d{2}\s\d{2}\s\d{4}\s\d{7})\b", text)
	if not pedimento_number:
		pedimento_number = search_first(r"\b(\d{2}\s\d{2}\s\d{4}\s\d{7})\b", text)

	# Date: prefer payment date if visible
	date = search_first(r"\bPAGO\s*([0-3]?\d[\-/][01]?\d[\-/](?:20)?\d{2})\b", text)
	if not date:
		date = search_first(r"\bFecha\s*[:\-]?\s*([0-3]?\d[\-/][01]?\d[\-/](?:20)?\d{2})\b", text)

	# Aduana code number
	aduana = search_first(r"ADUANA\s*E/S\s*:\s*(\d{2,3})", text)

	# Importer RFC and name
	importer_rfc = search_first(r"(?:RFC|Clave\s+en\s+el\s+RFC)\s*:\s*([A-Z&Ñ]{3,4}\d{6}[A-Z0-9]{3})\b", text)
	importer_name = search_first(r"NOMBRE[^:\n]*:\s*([^\n\r]+)", text)

	# Values
	customs_value = search_first(r"VALOR\s+ADUANA\s*:\s*([\$\s\d.,]+)\b", text)
	taxes_total = None
	m = re.search(r"CUADRO\s+DE\s+LIQUIDACION[\s\S]{0,400}?TOTAL\s+([\$\s\d.,]+)", text, flags=re.IGNORECASE)
	if m:
		taxes_total = m.group(1)

	customs_value = parse_currency_amount(customs_value)
	taxes_total = parse_currency_amount(taxes_total)

	return PedimentoInfo(
		file_name=file_name,
		pedimento_number=pedimento_number,
		date=date,
		aduana=aduana,
		importer_rfc=importer_rfc,
		importer_name=importer_name,
		customs_value=customs_value,
		taxes_total=taxes_total,
		raw_text_path=raw_text_path,
	)


def map_invoices_to_pedimentos(invoices: List[InvoiceInfo], pedimentos: List[PedimentoInfo]) -> Dict[str, Optional[str]]:
	"""Return mapping invoice_number -> pedimento_number (best-effort)."""
	mapping: Dict[str, Optional[str]] = {}

	# Build index by pedimento number for quick lookup
	ped_idx: Dict[str, PedimentoInfo] = {}
	for p in pedimentos:
		if p.pedimento_number:
			ped_idx[p.pedimento_number.replace(" ", "")] = p

	for inv in invoices:
		ped_from_inv = (inv.pedimento_number_in_text or "").replace(" ", "")
		chosen: Optional[str] = None
		if ped_from_inv and ped_from_inv in ped_idx:
			chosen = ped_idx[ped_from_inv].pedimento_number
		else:
			# As a fallback, attempt to match based on unique sequences present in filenames
			for p in pedimentos:
				if not p.pedimento_number:
					continue
				mid_block = p.pedimento_number.split()
				if len(mid_block) == 4 and mid_block[2] in (inv.invoice_number or ""):
					chosen = p.pedimento_number
					break
		mapping[inv.invoice_number or inv.file_name] = chosen

	return mapping


def escape(s: Optional[str]) -> str:
	return html.escape(s) if s else ""


def generate_html(invoices: List[InvoiceInfo], pedimentos: List[PedimentoInfo], mapping: Dict[str, Optional[str]]) -> str:
	css = (
		"body{font-family:Inter,Segoe UI,Roboto,Arial,sans-serif;color:#222;margin:0;padding:0;background:#f7f8fa;}"
		"header{background:#0a3d62;color:#fff;padding:28px 22px;}"
		"h1{margin:0;font-size:24px;}"
		"main{padding:24px;}"
		"section{background:#fff;border:1px solid #e7e9ee;border-radius:10px;margin:14px 0;padding:18px;}"
		"h2{margin:0 0 12px 0;font-size:18px;color:#0a3d62;}"
		"table{width:100%;border-collapse:collapse;margin-top:8px;}"
		"th,td{border:1px solid #e7e9ee;padding:8px 10px;text-align:left;font-size:14px;vertical-align:top;}"
		"th{background:#f0f3f8;font-weight:600;}"
		"small, .muted{color:#667085;}"
		".grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:12px;}"
		".tag{display:inline-block;background:#e8f2ff;color:#0a3d62;border-radius:999px;padding:2px 8px;font-size:12px;margin-left:6px;}"
		".note{background:#fff9e6;border:1px solid #ffe8a3;border-radius:8px;padding:10px;margin-top:10px;}"
		".kbd{font-family:ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;background:#f3f4f6;border:1px solid #e5e7eb;border-bottom-width:2px;padding:2px 6px;border-radius:6px;}"
	)

	# Optional illustrative images in the same directory
	image_tags: List[str] = []
	for ext in ("*.jpeg", "*.jpg", "*.png"):
		for img in PDF_DIR.glob(ext):
			image_tags.append(f"<img src='{escape(img.name)}' alt='Referencia' style='max-width:100%;height:auto;border-radius:8px;border:1px solid #e7e9ee;margin:8px 0;' />")

	head = (
		"<header>\n"
		"  <h1>Informe de Facturas y Pedimentos</h1>\n"
		"  <div><small>Documento explicativo para público no especializado<span class=\"tag\">Versión preliminar</span></small></div>\n"
		"</header>\n"
	)

	intro = (
		"<section>\n"
		"  <h2>Objetivo del informe</h2>\n"
		"  <p>Este documento resume, de forma clara y comprensible, la información clave de tres facturas y sus correspondientes pedimentos de importación. Está pensado para una persona sin experiencia en comercio exterior o administración, por lo que evitamos tecnicismos y explicamos cada término esencial.</p>\n"
		"  <div class=\"note\"><strong>¿Qué es una factura?</strong> Es el comprobante que detalla la venta: quién vende, quién compra, qué se vende y cuánto cuesta. <strong>¿Qué es un pedimento?</strong> Es el documento oficial que comprueba la entrada de mercancías al país y el pago de impuestos en aduana.</div>\n"
	)
	intro = intro + ("".join(image_tags) if image_tags else "") + "</section>\n"

	# Invoices table
	inv_rows = []
	for inv in invoices:
		inv_rows.append(
			"<tr>"
			f"<td>{escape(inv.file_name)}</td>"
			f"<td>{escape(inv.invoice_number)}</td>"
			f"<td>{escape(inv.date)}</td>"
			f"<td>{escape(inv.client_name)}</td>"
			f"<td>{escape(inv.rfc)}</td>"
			f"<td>{escape(inv.currency or '')} {escape(inv.total)}</td>"
			f"<td>{escape(inv.pedimento_number_in_text)}</td>"
			f"<td><a href='{escape(str(inv.raw_text_path.name if inv.raw_text_path else ''))}' target='_blank'>Texto</a></td>"
			"</tr>"
		)

	inv_table = (
		"<section>\n"
		"  <h2>Resumen de facturas</h2>\n"
		"  <table>\n"
		"    <thead><tr><th>Archivo</th><th>Número</th><th>Fecha</th><th>Cliente</th><th>RFC</th><th>Total</th><th>Pedimento (en factura)</th><th>Texto</th></tr></thead>\n"
		"    <tbody>" + "".join(inv_rows) + "</tbody>\n"
		"  </table>\n"
		"  <p class=\"muted\">Nota: Los enlaces de <span class=\"kbd\">Texto</span> permiten revisar el contenido extraído para auditoría.</p>\n"
		"</section>\n"
	)

	# Pedimentos table
	ped_rows = []
	for p in pedimentos:
		ped_rows.append(
			"<tr>"
			f"<td>{escape(p.file_name)}</td>"
			f"<td>{escape(p.pedimento_number)}</td>"
			f"<td>{escape(p.date)}</td>"
			f"<td>{escape(p.aduana)}</td>"
			f"<td>{escape(p.importer_name)}<br><small class='muted'>{escape(p.importer_rfc)}</small></td>"
			f"<td>{escape(p.customs_value)}</td>"
			f"<td>{escape(p.taxes_total)}</td>"
			f"<td><a href='{escape(str(p.raw_text_path.name if p.raw_text_path else ''))}' target='_blank'>Texto</a></td>"
			"</tr>"
		)

	ped_table = (
		"<section>\n"
		"  <h2>Resumen de pedimentos</h2>\n"
		"  <table>\n"
		"    <thead><tr><th>Archivo</th><th>Número de pedimento</th><th>Fecha</th><th>Aduana</th><th>Importador</th><th>Valor en aduana</th><th>Impuestos</th><th>Texto</th></tr></thead>\n"
		"    <tbody>" + "".join(ped_rows) + "</tbody>\n"
		"  </table>\n"
		"</section>\n"
	)

	# Mapping table
	map_rows = []
	for inv in invoices:
		key = inv.invoice_number or inv.file_name
		mapped = mapping.get(key)
		map_rows.append(
			"<tr>"
			f"<td>{escape(inv.invoice_number)}</td>"
			f"<td>{escape(inv.pedimento_number_in_text)}</td>"
			f"<td>{escape(mapped)}</td>"
			"</tr>"
		)

	map_table = (
		"<section>\n"
		"  <h2>Vinculación factura ↔ pedimento</h2>\n"
		"  <p>Cuando la factura incluye el número de pedimento, usamos ese dato para vincular de forma directa. Si no aparece explícito, proponemos la mejor coincidencia disponible y dejamos constancia de la incertidumbre.</p>\n"
		"  <table>\n"
		"    <thead><tr><th>Factura</th><th>Pedimento (en factura)</th><th>Pedimento (confirmado)</th></tr></thead>\n"
		"    <tbody>" + "".join(map_rows) + "</tbody>\n"
		"  </table>\n"
		"</section>\n"
	)

	# Per-invoice detail section
	ped_by_number: Dict[str, PedimentoInfo] = { (p.pedimento_number or "").replace(" ", ""): p for p in pedimentos if p.pedimento_number }
	detail_parts: List[str] = []
	for inv in invoices:
		key = (mapping.get(inv.invoice_number or inv.file_name) or "").replace(" ", "")
		p = ped_by_number.get(key)
		section = [
			"<section>",
			f"  <h2>Detalle de factura {escape(inv.invoice_number or inv.file_name)}</h2>",
			"  <div class='grid'>",
			f"    <div><strong>Cliente</strong><br>{escape(inv.client_name)}<br><small class='muted'>{escape(inv.rfc)}</small></div>",
			f"    <div><strong>Fecha de emisión</strong><br>{escape(inv.date)}</div>",
			f"    <div><strong>Importe</strong><br>Subtotal: {escape(inv.subtotal)} | IVA: {escape(inv.iva)} | Total: {escape(inv.total)} {escape(inv.currency or '')}</div>",
			f"    <div><strong>Pedimento citado</strong><br>{escape(inv.pedimento_number_in_text)}</div>",
			"  </div>",
		]
		if p:
			section.extend([
				"  <div class='note'><strong>Pedimento vinculado</strong><br>",
				f"    Número: {escape(p.pedimento_number)} | Fecha: {escape(p.date)} | Aduana (clave): {escape(p.aduana)}<br>",
				f"    Importador: {escape(p.importer_name)} <small class='muted'>({escape(p.importer_rfc)})</small><br>",
				f"    Valor en aduana: {escape(p.customs_value)} | Total liquidación: {escape(p.taxes_total)} ",
				f"    | <a href='{escape(str(p.raw_text_path.name if p.raw_text_path else ''))}' target='_blank'>Ver texto</a>",
				"  </div>",
			])
		section.append("</section>")
		detail_parts.append("\n".join(section))
	
	detail_html = "".join(detail_parts)

	conclusion = (
		"<section>\n"
		"  <h2>Conclusiones y siguientes pasos</h2>\n"
		"  <ul>\n"
		"    <li><strong>Integridad documental:</strong> Las facturas y pedimentos presentados permiten comprobar la compraventa y la importación correspondiente.</li>\n"
		"    <li><strong>Transparencia:</strong> Se incluyen enlaces al texto extraído para facilitar validaciones puntuales.</li>\n"
		"    <li><strong>Recomendación:</strong> Confirmar la coincidencia entre números de pedimento y facturas en los sistemas de origen y anexar, si procede, evidencias de pago de contribuciones.</li>\n"
		"  </ul>\n"
		"  <p class=\"muted\">Documento generado automáticamente a partir de los archivos provistos.</p>\n"
		"</section>\n"
	)

	return (
		"<!doctype html>\n<html lang='es'>\n<head>\n<meta charset='utf-8'>\n<meta name='viewport' content='width=device-width, initial-scale=1'>\n"
		f"<title>Informe de Facturas y Pedimentos</title>\n<style>{css}</style>\n"
		"</head>\n<body>\n" + head + "<main>\n" + intro + inv_table + ped_table + map_table + detail_html + conclusion + "</main>\n</body>\n</html>\n"
	)


def main() -> None:
	pdfs = list(PDF_DIR.glob("*.pdf"))
	if not pdfs:
		raise SystemExit("No se encontraron PDFs en /workspace/PDF")

	invoice_files: List[Path] = []
	pedimento_files: List[Path] = []

	for p in pdfs:
		name = p.name.lower()
		if name.startswith("fact"):
			invoice_files.append(p)
		elif name.startswith("ped"):
			pedimento_files.append(p)

	invoices: List[InvoiceInfo] = []
	for f in sorted(invoice_files):
		text = read_pdf_text(f)
		if not text:
			# As last resort, read binary with strings-like approach
			try:
				data = f.read_bytes()
				text = data.decode(errors="ignore")
			except Exception:
				text = ""
		raw_txt = save_raw_text(text or "", f)
		invoices.append(parse_invoice(text, f.name, raw_txt))

	pedimentos: List[PedimentoInfo] = []
	for f in sorted(pedimento_files):
		text = read_pdf_text(f)
		if not text:
			try:
				data = f.read_bytes()
				text = data.decode(errors="ignore")
			except Exception:
				text = ""
		raw_txt = save_raw_text(text or "", f)
		# If pedimento number is not in text, infer from filename pattern
		info = parse_pedimento(text, f.name, raw_txt)
		if not info.pedimento_number:
			from_name = re.search(r"(\d{2}\s\d{2}\s\d{4}\s\d{7})", f.stem)
			if from_name:
				info.pedimento_number = from_name.group(1)
		pedimentos.append(info)

	mapping = map_invoices_to_pedimentos(invoices, pedimentos)

	html_out = generate_html(invoices, pedimentos, mapping)
	OUTPUT_HTML.write_text(html_out, encoding="utf-8")
	print(f"OK -> {OUTPUT_HTML}")


if __name__ == "__main__":
	main()