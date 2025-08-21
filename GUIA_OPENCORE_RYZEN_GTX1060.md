# Guía OpenCore para AMD Ryzen 5 2600X + NVIDIA GTX 1060 + macOS Sequoia 15.6

## Especificaciones del Sistema
- **CPU**: AMD Ryzen 5 2600X (6 cores, 12 threads)
- **GPU**: NVIDIA GeForce GTX 1060 3GB
- **RAM**: 16GB DDR4
- **Monitor**: ASUS 165Hz
- **macOS**: Sequoia 15.6

## Configuración Optimizada ✅

### 1. Boot Arguments Configurados
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera
```

**Explicación de los parámetros:**
- `nvda_drv=1`: Habilita drivers NVIDIA
- `ngfxcompat=1`: Compatibilidad con gráficos NVIDIA
- `ngfxgl=1`: OpenGL para NVIDIA
- `alcid=3`: Layout ID para audio Realtek ALC
- `agdpmod=pikera`: Solución para monitores de alta frecuencia (165Hz)
- `amfi_get_out_of_my_way=1`: Bypass AMFI para kexts
- `-no_compat_check`: Deshabilita verificación de compatibilidad

### 2. Kexts Instalados y Verificados
- ✅ **Lilu.kext**: Framework base para otros kexts
- ✅ **VirtualSMC.kext**: Emulación de SMC
- ✅ **WhateverGreen.kext**: Compatibilidad de gráficos
- ✅ **AppleALC.kext**: Audio con layout-id 3
- ✅ **AMDRyzenCPUPowerManagement.kext**: Gestión de energía para Ryzen
- ✅ **AppleMCEReporterDisabler.kext**: Deshabilita MCE para AMD
- ✅ **AMFIPass.kext**: Bypass AMFI para Sequoia 15.6

### 3. Drivers EFI Instalados
- ✅ **OpenRuntime.efi**: Runtime services
- ✅ **HfsPlus.efi**: Soporte para HFS+
- ✅ **OpenCanopy.efi**: Interfaz gráfica de OpenCore
- ✅ **OpenUsbKbDxe.efi**: Soporte para teclado USB
- ✅ **ResetNvramEntry.efi**: Reset de NVRAM

### 4. Archivos ACPI (SSDT)
- ✅ **SSDT-EC.aml**: Embedded Controller
- ✅ **SSDT-PLUG.aml**: Power management para AMD
- ✅ **SSDT-PMC.aml**: Power management controller
- ✅ **SSDT-USB-Reset.aml**: Reset de USB
- ✅ **SSDT-USBX.aml**: Configuración USB

### 5. Configuración de GPU NVIDIA GTX 1060
```xml
<key>PciRoot(0x0)/Pci(0x3,0x0)/Pci(0x0,0x0)</key>
<dict>
    <key>NVDA,Features</key>
    <data>AAAAAA==</data>
    <key>NVDA,NVArch</key>
    <string>NV130</string>
    <key>device-id</key>
    <data>HAIAAA==</data>
    <key>model</key>
    <string>NVIDIA GeForce GTX 1060 3GB</string>
    <key>name</key>
    <string>@NVDA,Display-A</string>
    <key>vendor-id</key>
    <data>3hAAAQ==</data>
    <key>@0,connector-type</key>
    <integer>2</integer>
    <key>@1,connector-type</key>
    <integer>4</integer>
    <key>@2,connector-type</key>
    <integer>8</integer>
    <key>@3,connector-type</key>
    <integer>8</integer>
    <key>@4,connector-type</key>
    <integer>8</integer>
    <key>@5,connector-type</key>
    <integer>8</integer>
    <key>hda-gfx</key>
    <string>onboard-1</string>
</dict>
```

### 6. Configuración de Audio
```xml
<key>PciRoot(0x0)/Pci(0x8,0x1)/Pci(0x0,0x3)</key>
<dict>
    <key>AAPL,slot-name</key>
    <string>Internal@0,8,1/0,3</string>
    <key>device-id</key>
    <data>cKEAAA==</data>
    <key>device_type</key>
    <string>Audio device</string>
    <key>layout-id</key>
    <integer>3</integer>
    <key>model</key>
    <string>Family 17h (Models 00h-0fh) HD Audio Controller</string>
</dict>
```

## Configuración de BIOS/UEFI

### Configuraciones Requeridas:
1. **Secure Boot**: Deshabilitado
2. **CSM**: Deshabilitado
3. **Fast Boot**: Deshabilitado
4. **Above 4G Decoding**: Habilitado
5. **Resizable BAR**: Deshabilitado
6. **SVM Mode**: Habilitado (AMD-V)
7. **IOMMU**: Habilitado

### Configuraciones Opcionales:
- **XMP/DOCP**: Habilitado para RAM DDR4
- **PBO (Precision Boost Overdrive)**: Habilitado para mejor rendimiento

## Instalación y Configuración

### Paso 1: Preparación
1. Descargar macOS Sequoia 15.6
2. Crear USB de instalación con OpenCore
3. Verificar que todos los archivos estén en su lugar

### Paso 2: Instalación
1. Bootear desde USB OpenCore
2. Seleccionar instalación de macOS
3. Seguir el proceso de instalación normal
4. **IMPORTANTE**: No reiniciar durante la instalación

### Paso 3: Post-Instalación
1. Instalar OpenCore en el disco de sistema
2. Copiar EFI a la partición EFI del sistema
3. Configurar boot desde OpenCore

## Legacy Patcher para Sequoia 15.6

### Cuándo usar Legacy Patcher:
- Si tienes problemas de compatibilidad con kexts
- Si necesitas soporte para hardware más antiguo
- Si encuentras errores de AMFI

### Instalación de Legacy Patcher:
1. Descargar OpenCore Legacy Patcher
2. Ejecutar desde macOS
3. Seleccionar "Post Install Root Patch"
4. Reiniciar sistema

## Solución de Problemas

### Problemas Comunes:

#### 1. No Bootea
- Verificar Secure Boot deshabilitado
- Revisar boot-args
- Verificar kexts en orden correcto

#### 2. Sin Audio
- Verificar layout-id 3
- Comprobar AppleALC.kext
- Revisar conexiones de audio

#### 3. Problemas de Pantalla
- Verificar agdpmod=pikera
- Comprobar WhateverGreen.kext
- Revisar configuración de GPU

#### 4. Kernel Panic
- Verificar AMDRyzenCPUPowerManagement.kext
- Comprobar AppleMCEReporterDisabler.kext
- Revisar patches de kernel

### Logs de Depuración:
- Habilitar `debug=0x100` en boot-args
- Revisar logs en `/var/log/`
- Usar OpenCore Configurator para análisis

## Verificación Final

Ejecutar el script de verificación:
```bash
./verificar_opencore.sh
```

Todos los elementos deben mostrar ✅ para confirmar configuración correcta.

## Recursos Útiles

- **OpenCore Documentation**: https://dortania.github.io/OpenCore-Install-Guide/
- **AMD OSX**: https://amd-osx.com/
- **OpenCore Legacy Patcher**: https://github.com/dortania/OpenCore-Legacy-Patcher
- **ProperTree**: Editor recomendado para config.plist

## Notas Importantes

1. **Backup**: Siempre hacer backup antes de cambios
2. **Actualizaciones**: Verificar compatibilidad antes de actualizar
3. **Kexts**: Mantener kexts actualizados
4. **BIOS**: Mantener BIOS actualizado
5. **Monitoreo**: Usar herramientas como iStat Menus para monitoreo

---

**Configuración verificada y optimizada para tu hardware específico.**
**Fecha de verificación**: $(date)
**Versión OpenCore**: 0.9.6
**Compatibilidad**: macOS Sequoia 15.6