#!/bin/bash

echo "=== Test de Layouts de Audio para Realtek ALCS1200A ==="
echo ""
echo "Layouts disponibles para ALCS1200A:"
echo ""
echo "1  - toleda - Realtek ALCS1200A (genérico)"
echo "2  - toleda - Realtek ALCS1200A (genérico)"
echo "3  - toleda - Realtek ALCS1200A (genérico)"
echo "7  - ALCS1200A for B550M Gaming Carbon WIFI"
echo "11 - owen0o0 - Realtek ALCS1200A"
echo "12 - mobilestebu - Realtek ALCS1200A for ASUS TUF-Z390M-Gaming"
echo "23 - VictorXu - Realtek ALCS1200A for MSI B460I GAMING EDGE WIFI"
echo "49 - VictorXu - Realtek ALCS1200A for Asrock Z490M-ITX"
echo "50 - VictorXu - Realtek ALCS1200A for Gigabyte B460M Aorus Pro"
echo "51 - GeorgeWan - ALCS1200A for ASROCK-Z490-Steel-Legend"
echo "52 - GeorgeWan - ALCS1200A for MSI-Mortar-B460M"
echo "69 - Lorys89 and Vorshim92 - ALCS1200A for ASROCK Z490M ITX AC"
echo ""
echo "Layout actual configurado: 12"
echo ""

# Función para cambiar el layout
change_layout() {
    local new_layout=$1
    
    echo "Cambiando layout a: $new_layout"
    
    # Cambiar en boot-args
    sed -i.bak "s/alcid=[0-9]*/alcid=$new_layout/g" EFI/OC/config.plist
    
    # Cambiar en DeviceProperties (buscar y reemplazar el integer del layout-id)
    # Esto es más complejo porque necesitamos cambiar el valor entre tags
    perl -i -pe "s/(<key>layout-id<\/key>\s*<integer>)[0-9]+(<\/integer>)/\${1}${new_layout}\${2}/g" EFI/OC/config.plist
    
    echo "✓ Layout cambiado a $new_layout en config.plist"
    echo ""
    echo "Para aplicar los cambios:"
    echo "1. Reinicia el sistema"
    echo "2. O ejecuta: sudo nvram boot-args=\"\$(grep -A1 'boot-args' EFI/OC/config.plist | grep '<string>' | sed 's/.*<string>//' | sed 's/<\/string>.*//')\""
}

# Función para probar el audio
test_audio() {
    echo ""
    echo "=== Probando Audio ==="
    
    # Verificar si el sistema está en macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Listar dispositivos de audio
        echo "Dispositivos de audio detectados:"
        system_profiler SPAudioDataType | grep "Device" || echo "No se detectaron dispositivos"
        
        echo ""
        echo "Probando salida de audio..."
        # Reproducir sonido de prueba
        afplay /System/Library/Sounds/Ping.aiff 2>/dev/null || echo "No se pudo reproducir el sonido de prueba"
        
        # Verificar el codec
        echo ""
        echo "Información del codec:"
        ioreg -l | grep -i "alc" | head -5
        
        # Verificar AppleALC
        echo ""
        echo "Estado de AppleALC:"
        kextstat | grep -i "AppleALC" || echo "AppleALC no está cargado"
    else
        echo "Este script debe ejecutarse en macOS para probar el audio"
    fi
}

# Menú principal
while true; do
    echo ""
    echo "=== MENÚ ==="
    echo "1. Cambiar layout de audio"
    echo "2. Probar audio actual"
    echo "3. Ver layout actual"
    echo "4. Restaurar backup"
    echo "5. Salir"
    echo ""
    read -p "Selecciona una opción: " option
    
    case $option in
        1)
            read -p "Ingresa el número de layout (1-69): " layout
            if [[ $layout =~ ^[0-9]+$ ]] && [ $layout -ge 1 ] && [ $layout -le 69 ]; then
                change_layout $layout
            else
                echo "Layout inválido"
            fi
            ;;
        2)
            test_audio
            ;;
        3)
            echo ""
            echo "Layout actual en boot-args:"
            grep "boot-args" EFI/OC/config.plist | grep -o "alcid=[0-9]*" || echo "No encontrado"
            echo ""
            echo "Layout actual en DeviceProperties:"
            grep -A1 "layout-id" EFI/OC/config.plist | grep "<integer>" | sed 's/.*<integer>//' | sed 's/<\/integer>.*//'
            ;;
        4)
            if [ -f "EFI/OC/config.plist.bak" ]; then
                cp EFI/OC/config.plist.bak EFI/OC/config.plist
                echo "✓ Backup restaurado"
            else
                echo "No se encontró backup"
            fi
            ;;
        5)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida"
            ;;
    esac
done