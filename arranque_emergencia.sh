#!/bin/bash

echo "========================================="
echo "SCRIPT DE ARRANQUE DE EMERGENCIA"
echo "========================================="
echo ""
echo "Este script crea una copia de config.plist sin NVIDIA para emergencias"
echo ""

# Backup del config actual
cp EFI/OC/config.plist EFI/OC/config.plist.backup

# Crear config de emergencia
cat > EFI/OC/config_emergencia.plist << 'EOF'
# NOTA: Este es un placeholder. El usuario debe:
# 1. Copiar su config.plist actual
# 2. Cambiar boot-args a: -v nv_disable=1 npci=0x2000 alcid=12
# 3. Eliminar todas las DeviceProperties de NVIDIA
EOF

echo "INSTRUCCIONES PARA ARRANQUE DE EMERGENCIA:"
echo ""
echo "Si el sistema no arranca con la configuración actual:"
echo ""
echo "1. En el boot picker de OpenCore, presiona ESPACIO"
echo "2. Selecciona 'Reset NVRAM' y reinicia"
echo ""
echo "3. Si sigue sin arrancar, arranca desde USB de instalación y ejecuta:"
echo "   - diskutil list (para identificar tu EFI)"
echo "   - diskutil mount /dev/diskXs1 (donde X es tu disco)"
echo "   - cd /Volumes/EFI/EFI/OC/"
echo "   - cp config.plist config_nvidia.plist"
echo "   - Edita config.plist y agrega nv_disable=1 a boot-args"
echo ""
echo "4. Boot-args de emergencia (sin NVIDIA):"
echo "   -v nv_disable=1 npci=0x2000 alcid=12"
echo ""
echo "5. Para restaurar NVIDIA:"
echo "   cp config_nvidia.plist config.plist"
echo ""

chmod +x arranque_emergencia.sh