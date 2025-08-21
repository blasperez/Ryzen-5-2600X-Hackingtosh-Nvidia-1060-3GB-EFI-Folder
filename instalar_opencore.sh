#!/bin/bash

echo "=== Instalador Automatizado de OpenCore para Ryzen 5 2600X + GTX 1060 ==="
echo ""

# Verificar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo "Este script debe ejecutarse como root (sudo)"
    echo "Uso: sudo ./instalar_opencore.sh"
    exit 1
fi

# Verificar que estamos en macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Este script debe ejecutarse en macOS"
    exit 1
fi

echo "1. Verificando configuración de OpenCore..."
./verificar_opencore.sh

if [ $? -ne 0 ]; then
    echo "Error: La verificación de OpenCore falló. Revisa la configuración."
    exit 1
fi

echo ""
echo "2. Detectando discos disponibles..."

# Listar discos disponibles
diskutil list

echo ""
echo "3. Selecciona el disco donde instalar OpenCore:"
echo "   (Ejemplo: disk0, disk1, etc.)"
read -p "Disco: " DISCO

# Verificar que el disco existe
if ! diskutil list | grep -q "$DISCO"; then
    echo "Error: Disco $DISCO no encontrado"
    exit 1
fi

echo ""
echo "4. Montando partición EFI..."

# Crear punto de montaje
mkdir -p /tmp/EFI_MOUNT

# Montar partición EFI
diskutil mount ${DISCO}s1

if [ $? -ne 0 ]; then
    echo "Error: No se pudo montar la partición EFI"
    echo "Intentando crear partición EFI..."
    
    # Crear partición EFI si no existe
    diskutil partitionDisk $DISCO 1 GPT fat32 EFI 200M
    
    if [ $? -ne 0 ]; then
        echo "Error: No se pudo crear la partición EFI"
        exit 1
    fi
    
    # Montar nuevamente
    diskutil mount ${DISCO}s1
fi

echo ""
echo "5. Copiando archivos de OpenCore..."

# Copiar EFI a la partición
cp -R EFI /Volumes/EFI/

if [ $? -ne 0 ]; then
    echo "Error: No se pudieron copiar los archivos"
    exit 1
fi

echo "✓ Archivos copiados exitosamente"

echo ""
echo "6. Configurando permisos..."

# Configurar permisos correctos
chmod -R 755 /Volumes/EFI/EFI
chown -R root:wheel /Volumes/EFI/EFI

echo "✓ Permisos configurados"

echo ""
echo "7. Desmontando partición EFI..."
diskutil unmount /Volumes/EFI

echo ""
echo "=== Instalación Completada ==="
echo ""
echo "OpenCore ha sido instalado exitosamente en $DISCO"
echo ""
echo "Próximos pasos:"
echo "1. Reinicia tu computadora"
echo "2. Entra al BIOS/UEFI"
echo "3. Configura el boot order para usar OpenCore"
echo "4. Guarda y reinicia"
echo ""
echo "Configuraciones de BIOS recomendadas:"
echo "- Secure Boot: Deshabilitado"
echo "- CSM: Deshabilitado"
echo "- Above 4G Decoding: Habilitado"
echo "- SVM Mode: Habilitado"
echo ""
echo "Si tienes problemas:"
echo "- Ejecuta: ./verificar_opencore.sh"
echo "- Revisa la guía: GUIA_OPENCORE_RYZEN_GTX1060.md"
echo ""
echo "¡Buena suerte con tu Hackintosh!"