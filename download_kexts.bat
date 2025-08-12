@echo off
echo Descargando kexts necesarios para iCloud y Siri...
echo.

REM Crear directorio temporal
set "tempDir=%TEMP%\hackintosh_kexts"
if not exist "%tempDir%" mkdir "%tempDir%"

echo Descargando VirtualSMC...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/acidanthera/VirtualSMC/releases/download/1.3.8/VirtualSMC-1.3.8-RELEASE.zip' -OutFile '%tempDir%\VirtualSMC-1.3.8-RELEASE.zip'"

if exist "%tempDir%\VirtualSMC-1.3.8-RELEASE.zip" (
    echo ✓ VirtualSMC descargado correctamente
) else (
    echo ✗ Error descargando VirtualSMC
)

echo.
echo Archivos descargados en: %tempDir%
echo.
echo Pasos siguientes:
echo 1. Extrae VirtualSMC-1.3.8-RELEASE.zip
echo 2. Copia SMCProcessor.kext y SMCDellSensors.kext a tu carpeta Kexts
echo 3. Reemplaza tu config.plist con config_fixed.plist
echo 4. Reinicia y selecciona 'Reset NVRAM' en OpenCore
echo 5. Reinicia nuevamente y prueba iCloud y Siri
echo.
pause