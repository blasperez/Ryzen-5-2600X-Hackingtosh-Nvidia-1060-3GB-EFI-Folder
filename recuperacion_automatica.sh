#!/bin/bash

# Script de recuperación automática para pantalla negra
# Se puede ejecutar a ciegas desde Terminal

echo "Iniciando recuperación automática..."

# Sonido para confirmar que el script está corriendo
say "Iniciando recuperación de pantalla"

# Paso 1: Backup del config actual
if [ -f "/Volumes/EFI/EFI/OC/config.plist" ]; then
    cp /Volumes/EFI/EFI/OC/config.plist /Volumes/EFI/EFI/OC/config.backup.$(date +%Y%m%d_%H%M%S).plist
    say "Backup creado"
else
    # Intentar montar EFI
    diskutil mount disk0s1
    sleep 2
    if [ -f "/Volumes/EFI/EFI/OC/config.plist" ]; then
        cp /Volumes/EFI/EFI/OC/config.plist /Volumes/EFI/EFI/OC/config.backup.$(date +%Y%m%d_%H%M%S).plist
        say "EFI montada y backup creado"
    else
        say "Error: No se puede encontrar la EFI"
        exit 1
    fi
fi

# Paso 2: Aplicar boot-args de emergencia
echo "Aplicando boot-args de emergencia..."
sudo nvram boot-args="debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware nv_disable=1"

say "Boot args aplicados con nv disable activado"

# Paso 3: Limpiar caché si es posible
echo "Limpiando caché..."
sudo rm -rf /System/Library/Caches/com.apple.kext.caches/
sudo touch /System/Library/Extensions/
sudo kextcache -i /

say "Caché limpiado"

# Paso 4: Preguntar si reiniciar
say "Proceso completado. ¿Deseas reiniciar ahora? Presiona Y para sí o N para no"

read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    say "Reiniciando en 5 segundos"
    sleep 5
    sudo reboot
else
    say "No se reiniciará. Puedes hacerlo manualmente con sudo reboot"
fi