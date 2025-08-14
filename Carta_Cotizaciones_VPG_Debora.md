Estimada Débora,

Espero que estés muy bien. Te comparto el modelo del PDF de cotización para VPG y la configuración propuesta del sistema de cotizaciones en Salesforce (Sales Cloud). La guía informativa publicada se usará solo como referencia, sin cambios: [Guía VPG](https://blasperez.github.io/Guia-Vpg/).

### Configuración del sistema de cotizaciones VPG
- **Objetivo**: cotizaciones claras y consistentes, con cálculos automáticos, trazabilidad y respuesta rápida.
- **Datos base**:
  - Catálogo de productos/servicios y listas de precios (MXN/USD).
  - Reglas de margen/descuentos; zonas y costos logísticos.
  - Impuestos (IVA 16% por defecto) y tiempos de entrega.
- **Flujo**:
  1) Solicitud (producto/servicio, cantidades, destino, contacto).
  2) Cálculo automático (precio, IVA, flete si aplica).
  3) Aprobación interna si rebasa umbral de descuento.
  4) Generación de PDF y envío por correo al cliente (copia al comercial).
  5) Registro y seguimiento (estatus, vigencia, conversión a pedido).
- **Backoffice VPG**: panel para catálogo, reglas de precios/descuentos, plantillas PDF y usuarios/roles.
- **Notificaciones**: correo transaccional con marca VPG; alertas de vigencia y aprobación pendiente.
- **Seguridad**: HTTPS, rate‑limit, reCAPTCHA, bitácora/auditoría.
- **Integraciones (opcionales)**: CRM (oportunidades), almacenamiento de PDFs, webhooks a ERP.

### Modelo de PDF de Cotización (VPG)
- **Encabezado**: Logo VPG, razón social, RFC emisor; número de cotización, fecha, vigencia; vendedor; moneda y tipo de cambio.
- **Datos del cliente**: razón social y RFC; contacto y correo; destino/plaza de entrega (input manual).
- **Condiciones comerciales**: Incoterms (EXW, FCA, FOB, CIF, DDP, DAP…), término de pago (PUE, PPD, 7/15/30 días…), tiempo de entrega, validez.
- **Detalle de conceptos (tabla)**: Clave/Producto/Servicio, Descripción, Cantidad, Precio unitario, Descuento, Subtotal; IVA; Totales (Subtotal, IVA, Total).
- **Referencias regulatorias (si aplica)**: NOM aplicables y modelos; número de pedimento, aduana (clave), observaciones.
- **Notas y cláusulas**: observaciones, inclusiones/exclusiones, datos de contacto y firma.

### Campos a configurar en Salesforce (Sales Cloud)
- **Quote (Record Type “VPG”)**
  - `Name`, `QuoteNumber` (autonumérico), `AccountId`, `ContactId`, `CurrencyIsoCode`
  - `Exchange_Rate__c` (número, 6 decimales), `Valid_Until__c` (fecha)
  - `Payment_Terms__c` (picklist), `Incoterms__c` (picklist)
  - `Destination__c` (texto libre), `Delivery_Time_Days__c` (número)
  - `Observations__c` (texto largo)
  - `Pedimento_Number__c` (texto, opcional), `Customs_Office_Code__c` (picklist, opcional)
  - `NOM_References__c` (texto largo, opcional), `Salesperson__c` (lookup User)
  - `Approval_Status__c` (Borrador, En aprobación, Aprobada, Rechazada)
- **Quote Line Item**
  - `Product2Id`, `Quantity`, `UnitPrice`, `Discount`, `Description`
  - `IVA_Applicable__c` (checkbox)
  - `NOM_Model__c` / `NOM_Type__c` (texto, opcional)
  - `Line_Subtotal__c` (fórmula), `Line_IVA__c` (fórmula), `Line_Total__c` (fórmula)
- **Totales (Quote)**: `Quote_Subtotal__c`, `Quote_IVA__c`, `Quote_Total__c`
- **Product2 / Pricebook**
  - `ProductCode`, `Family` (Servicios / Verificación NOM / Logística / Consultoría)
  - `PricebookEntry` con precio vigente (edición quincenal por VPG)

### Campos clave por fuente (Factura/Pedimento → Quote)
- **Desde factura**: Moneda y tipo de cambio → `CurrencyIsoCode` / `Exchange_Rate__c`; RFC cliente (en `Account`); comentarios → `Observations__c`; referencias NOM → `NOM_References__c` (o por línea); pedimento (si aplica) → `Pedimento_Number__c`.
- **Desde pedimento (si el servicio depende de la importación)**: Número de pedimento → `Pedimento_Number__c`; aduana (clave) → `Customs_Office_Code__c`; observaciones/anexos → `Observations__c`; RFC importador (validación con `Account`).

### Catálogo de productos/servicios (ejemplos VPG)
- Verificación NOM‑050 (por modelo)
- Verificación NOM‑024 (modelos adicionales)
- Unidad de verificación / Dictamen
- Gestión y trámites NOM
- Servicios de logística asociados (si aplica)
- Consultoría y acompañamiento técnico

### Parámetros operativos
- **Precios**: edición quincenal (PricebookEntry).
- **Impuestos**: IVA 16% por defecto (checkbox por línea para exenciones).
- **Incoterms / Término de pago**: picklists estandarizadas.
- **Vigencia**: por defecto 15 días (editable).
- **Aprobaciones**: regla por umbral de descuento o margen.
- **Multiempresa**: Record Types por marca (ACON, RINO, VPG) con plantillas/layouts dedicados.

### Generación del PDF en Salesforce
- **Opción 1 (rápida)**: Plantilla estándar de Quote + branding VPG + secciones anteriores.
- **Opción 2 (flexible)**: Visualforce/Aura/LWC con layout 1:1 del modelo y formateo fino.

### Ejemplos prácticos publicados
En la guía pública están documentados 3 ejemplos prácticos que explican explícitamente la relación factura ↔ pedimento: [Guía VPG](https://blasperez.github.io/Guia-Vpg/).
1. **Factura A‑27458**: no llevó modelos adicionales. Pedimento: **25 16 3807 5005428**.
2. **Factura A‑27720**: llevó en total una NORMA y **15 modelos**. Pedimento: **25 11 3259 5000580**.
3. **Factura A‑27525**: llevó **2 NORMAS** y en total **91 modelos**. Pedimento: **25 18 1793 5002070**.

### Próximos pasos
- **VPG**: Confirmar picklists (Incoterms, Término de pago), vigencia por defecto y umbrales de aprobación.
- **Yornio**: Entregar manual de actualización de precios y plantilla PDF inicial (Record Type VPG).
- **VPG**: Compartir catálogo final (ProductCode, descripción, UOM) y responsables de aprobación.

Quedo atenta para ajustar texto, plantillas y campos según lo requieran.

Saludos cordiales,
Blas
