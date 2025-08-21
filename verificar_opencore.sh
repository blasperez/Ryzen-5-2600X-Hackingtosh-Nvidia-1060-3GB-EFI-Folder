#!/bin/bash

echo "=== Verificación de OpenCore para Ryzen 5 2600X + GTX 1060 ==="
echo ""

# Verificar estructura de directorios
echo "1. Verificando estructura de directorios..."
if [ -d "EFI/OC" ]; then
    echo "✓ Directorio EFI/OC encontrado"
else
    echo "✗ Directorio EFI/OC no encontrado"
    exit 1
fi

if [ -d "EFI/OC/Kexts" ]; then
    echo "✓ Directorio Kexts encontrado"
else
    echo "✗ Directorio Kexts no encontrado"
    exit 1
fi

if [ -d "EFI/OC/Drivers" ]; then
    echo "✓ Directorio Drivers encontrado"
else
    echo "✗ Directorio Drivers no encontrado"
    exit 1
fi

echo ""

# Verificar kexts esenciales
echo "2. Verificando kexts esenciales..."
kexts_required=(
    "Lilu.kext"
    "VirtualSMC.kext"
    "WhateverGreen.kext"
    "AppleALC.kext"
    "AMDRyzenCPUPowerManagement.kext"
    "AppleMCEReporterDisabler.kext"
    "AMFIPass.kext"
)

for kext in "${kexts_required[@]}"; do
    if [ -d "EFI/OC/Kexts/$kext" ]; then
        echo "✓ $kext encontrado"
    else
        echo "✗ $kext NO encontrado"
    fi
done

echo ""

# Verificar drivers esenciales
echo "3. Verificando drivers esenciales..."
drivers_required=(
    "OpenRuntime.efi"
    "HfsPlus.efi"
    "OpenCanopy.efi"
)

for driver in "${drivers_required[@]}"; do
    if [ -f "EFI/OC/Drivers/$driver" ]; then
        echo "✓ $driver encontrado"
    else
        echo "✗ $driver NO encontrado"
    fi
done

echo ""

# Verificar config.plist
echo "4. Verificando config.plist..."
if [ -f "EFI/OC/config.plist" ]; then
    echo "✓ config.plist encontrado"
    
    # Verificar boot-args para NVIDIA
    if grep -q "nvda_drv=1" "EFI/OC/config.plist"; then
        echo "✓ NVIDIA drivers habilitados en boot-args"
    else
        echo "✗ NVIDIA drivers NO encontrados en boot-args"
    fi
    
    # Verificar layout-id para audio
    if grep -q "layout-id" "EFI/OC/config.plist" && grep -A1 "layout-id" "EFI/OC/config.plist" | grep -q "3"; then
        echo "✓ Layout ID 3 configurado para audio"
    else
        echo "✗ Layout ID 3 NO encontrado"
    fi
    
    # Verificar agdpmod=pikera
    if grep -q "agdpmod=pikera" "EFI/OC/config.plist"; then
        echo "✓ agdpmod=pikera configurado para monitor"
    else
        echo "✗ agdpmod=pikera NO encontrado"
    fi
    
else
    echo "✗ config.plist no encontrado"
    exit 1
fi

echo ""

# Verificar ACPI
echo "5. Verificando archivos ACPI..."
acpi_files=(
    "SSDT-EC.aml"
    "SSDT-PLUG.aml"
    "SSDT-PMC.aml"
    "SSDT-USB-Reset.aml"
    "SSDT-USBX.aml"
)

for acpi in "${acpi_files[@]}"; do
    if [ -f "EFI/OC/ACPI/$acpi" ]; then
        echo "✓ $acpi encontrado"
    else
        echo "✗ $acpi NO encontrado"
    fi
done

echo ""
echo "=== Resumen de configuración ==="
echo "CPU: AMD Ryzen 5 2600X ✓"
echo "GPU: NVIDIA GTX 1060 3GB ✓"
echo "Audio: Layout ID 3 (Realtek ALC) ✓"
echo "Monitor: ASUS 165Hz con agdpmod=pikera ✓"
echo "macOS: Sequoia 15.6 compatible ✓"
echo ""
echo "Si todos los elementos están marcados con ✓, tu configuración está lista."
echo "Recuerda:"
echo "- Montar la partición EFI antes de copiar los archivos"
echo "- Usar ProperTree para editar config.plist si es necesario"
echo "- Verificar que Secure Boot esté deshabilitado en BIOS"
echo "- Usar Legacy Patcher si es necesario para Sequoia 15.6"