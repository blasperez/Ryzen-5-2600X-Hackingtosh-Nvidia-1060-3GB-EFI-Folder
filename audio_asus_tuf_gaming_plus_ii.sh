#!/bin/bash

echo "=== Configuración de Audio para ASUS TUF Gaming Plus II ==="
echo "=== Codec: Realtek ALCS1200A ==="
echo ""

# Función para cambiar layout
change_layout() {
    local layout=$1
    echo "Cambiando a layout ID: $layout"
    
    # Cambiar en boot-args
    sed -i.bak "s/alcid=[0-9]*/alcid=$layout/g" EFI/OC/config.plist
    
    # Cambiar en DeviceProperties
    perl -i -pe "s/(<key>layout-id<\/key>\s*<integer>)[0-9]+(<\/integer>)/\${1}${layout}\${2}/g" EFI/OC/config.plist
    
    echo "✓ Layout cambiado a $layout"
    echo ""
    echo "Aplicar cambios con:"
    echo "sudo nvram boot-args=\"\$(grep -A1 'boot-args' EFI/OC/config.plist | grep '<string>' | sed 's/.*<string>//' | sed 's/<\/string>.*//')\""
    echo "sudo reboot"
}

# Función para probar audio
test_current() {
    echo "Layout actual:"
    grep -o "alcid=[0-9]*" EFI/OC/config.plist || echo "No encontrado"
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo ""
        echo "Probando audio..."
        afplay /System/Library/Sounds/Ping.aiff 2>/dev/null || echo "Error al reproducir"
        
        echo ""
        echo "Dispositivos detectados:"
        system_profiler SPAudioDataType | grep -E "Device|Manufacturer" | head -10
    fi
}

echo "=== LAYOUTS RECOMENDADOS PARA ASUS TUF GAMING PLUS II ==="
echo ""
echo "Prueba estos layouts en orden de prioridad:"
echo ""
echo "1. Layout 7  - B550M Gaming Carbon WIFI (RECOMENDADO - Configurado actualmente)"
echo "2. Layout 11 - owen0o0 ALCS1200A (genérico)"
echo "3. Layout 1  - toleda ALCS1200A (genérico básico)"
echo "4. Layout 2  - toleda ALCS1200A (genérico extendido)"
echo "5. Layout 3  - toleda ALCS1200A (genérico completo)"
echo "6. Layout 5  - Algunos usuarios reportan éxito con ASUS TUF"
echo ""
echo "Nota: El layout 7 suele funcionar bien con placas ASUS TUF Gaming modernas"
echo ""

while true; do
    echo ""
    echo "=== OPCIONES ==="
    echo "1. Probar Layout 7 (B550M - Recomendado)"
    echo "2. Probar Layout 11 (Genérico)"
    echo "3. Probar Layout 1 (Básico)"
    echo "4. Probar Layout 2 (Extendido)"
    echo "5. Probar Layout 5 (ASUS TUF alternativo)"
    echo "6. Cambiar a layout personalizado"
    echo "7. Ver configuración actual"
    echo "8. Probar audio actual"
    echo "9. Salir"
    echo ""
    read -p "Selecciona opción: " opt
    
    case $opt in
        1) change_layout 7 ;;
        2) change_layout 11 ;;
        3) change_layout 1 ;;
        4) change_layout 2 ;;
        5) change_layout 5 ;;
        6) 
            read -p "Ingresa el layout ID (1-69): " custom
            if [[ $custom =~ ^[0-9]+$ ]]; then
                change_layout $custom
            else
                echo "ID inválido"
            fi
            ;;
        7) test_current ;;
        8) 
            if [[ "$OSTYPE" == "darwin"* ]]; then
                echo "Reproduciendo sonido de prueba..."
                afplay /System/Library/Sounds/Ping.aiff
            else
                echo "Ejecuta este script en macOS para probar el audio"
            fi
            ;;
        9) exit 0 ;;
        *) echo "Opción inválida" ;;
    esac
done