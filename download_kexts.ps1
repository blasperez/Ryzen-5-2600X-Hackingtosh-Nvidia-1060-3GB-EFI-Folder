# Script PowerShell para descargar kexts faltantes para iCloud y Siri
# Ejecutar como administrador

Write-Host "Descargando kexts necesarios para iCloud y Siri..." -ForegroundColor Green

# Crear directorio temporal
$tempDir = "$env:TEMP\hackintosh_kexts"
New-Item -ItemType Directory -Force -Path $tempDir

# URLs de descarga
$downloads = @{
    "VirtualSMC-1.3.8-RELEASE.zip" = "https://github.com/acidanthera/VirtualSMC/releases/download/1.3.8/VirtualSMC-1.3.8-RELEASE.zip"
}

foreach ($file in $downloads.Keys) {
    $url = $downloads[$file]
    $output = Join-Path $tempDir $file
    
    Write-Host "Descargando $file..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        Write-Host "✓ $file descargado correctamente" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Error descargando $file : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nArchivos descargados en: $tempDir" -ForegroundColor Cyan
Write-Host "`nPasos siguientes:" -ForegroundColor Yellow
Write-Host "1. Extrae VirtualSMC-1.3.8-RELEASE.zip"
Write-Host "2. Copia SMCProcessor.kext y SMCDellSensors.kext a tu carpeta Kexts"
Write-Host "3. Reemplaza tu config.plist con config_fixed.plist"
Write-Host "4. Reinicia y selecciona 'Reset NVRAM' en OpenCore"
Write-Host "5. Reinicia nuevamente y prueba iCloud y Siri"

Read-Host "`nPresiona Enter para continuar..."