#!/bin/bash

echo "=== Solución para Pantalla Negra después de OpenCore Legacy Patcher ==="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "EFI/OC/config.plist" ]; then
    echo "Error: No se encontró config.plist en EFI/OC/"
    echo "Ejecuta este script desde el directorio raíz del proyecto"
    exit 1
fi

echo "✓ Configuración encontrada"
echo ""

# Verificar kexts necesarios
echo "Verificando kexts necesarios..."
if [ -d "EFI/OC/Kexts/WhateverGreen.kext" ]; then
    echo "✓ WhateverGreen.kext encontrado"
else
    echo "✗ WhateverGreen.kext NO encontrado - ES NECESARIO"
fi

if [ -d "EFI/OC/Kexts/Lilu.kext" ]; then
    echo "✓ Lilu.kext encontrado"
else
    echo "✗ Lilu.kext NO encontrado - ES NECESARIO"
fi

echo ""

# Verificar boot-args actuales
echo "Boot-args actuales:"
grep -A 1 "boot-args" EFI/OC/config.plist | grep "<string>" | sed 's/.*<string>//' | sed 's/<\/string>.*//'
echo ""

echo "=== PASOS PARA SOLUCIONAR ==="
echo ""
echo "1. Los cambios ya se aplicaron al config.plist:"
echo "   - Se agregó 'agdpmod=pikera' para evitar pantalla negra"
echo "   - Se agregó '-disablegfxfirmware' para compatibilidad NVIDIA"
echo "   - Se agregaron propiedades adicionales para la GTX 1060"
echo ""
echo "2. Si aún tienes pantalla negra, prueba estos pasos:"
echo ""
echo "   a) Reinicia y entra en modo seguro (mantén Shift al arrancar)"
echo "   b) Una vez en modo seguro, ejecuta en Terminal:"
echo "      sudo nvram boot-args=\"debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware\""
echo ""
echo "   c) Reinicia normalmente"
echo ""
echo "3. Si el problema persiste, prueba agregando estos boot-args adicionales:"
echo "   - 'nv_disable=1' (temporalmente para diagnosticar)"
echo "   - 'nvda_drv=1' (asegurar que NVIDIA drivers estén habilitados)"
echo ""
echo "4. Verifica que los drivers de NVIDIA estén instalados correctamente:"
echo "   - Ve a Preferencias del Sistema > Software Update"
echo "   - Instala cualquier actualización de NVIDIA disponible"
echo ""
echo "5. Si nada funciona, puedes intentar:"
echo "   - Deshabilitar WhateverGreen temporalmente"
echo "   - Usar solo los drivers nativos de macOS"
echo ""

echo "=== VERIFICACIÓN FINAL ==="
echo ""
echo "Para verificar que todo esté correcto, ejecuta:"
echo "sudo nvram -p | grep boot-args"
echo ""
echo "Deberías ver los nuevos parámetros incluidos."
echo ""
echo "¡Buena suerte! Si el problema persiste, considera reinstalar los drivers de NVIDIA."