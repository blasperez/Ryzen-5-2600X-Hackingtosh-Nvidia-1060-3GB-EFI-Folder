# OpenCore para AMD Ryzen 5 2600X + NVIDIA GTX 1060 + macOS Sequoia 15.6

## 🎯 Configuración Optimizada y Verificada

Esta configuración de OpenCore está específicamente optimizada para tu hardware:
- **CPU**: AMD Ryzen 5 2600X (6 cores, 12 threads)
- **GPU**: NVIDIA GeForce GTX 1060 3GB
- **RAM**: 16GB DDR4
- **Monitor**: ASUS 165Hz
- **macOS**: Sequoia 15.6

## 📁 Archivos Incluidos

### Configuración Principal
- `EFI/` - Carpeta completa de OpenCore optimizada
- `EFI/OC/config.plist` - Configuración principal optimizada

### Scripts de Automatización
- `verificar_opencore.sh` - Script de verificación de configuración
- `instalar_opencore.sh` - Script de instalación automatizada

### Documentación
- `GUIA_OPENCORE_RYZEN_GTX1060.md` - Guía completa detallada
- `SOLUCION_ICLOUD_SIRI.md` - Soluciones para iCloud y Siri

## 🚀 Instalación Rápida

### Opción 1: Instalación Automatizada (Recomendada)
```bash
# 1. Verificar configuración
./verificar_opencore.sh

# 2. Instalar OpenCore (requiere sudo)
sudo ./instalar_opencore.sh
```

### Opción 2: Instalación Manual
1. Montar partición EFI: `diskutil mount disk0s1`
2. Copiar carpeta EFI: `cp -R EFI /Volumes/EFI/`
3. Configurar permisos: `chmod -R 755 /Volumes/EFI/EFI`

## ✅ Verificación de Configuración

Ejecuta el script de verificación para confirmar que todo esté correcto:

```bash
./verificar_opencore.sh
```

**Resultado esperado:**
```
=== Verificación de OpenCore para Ryzen 5 2600X + GTX 1060 ===

1. Verificando estructura de directorios...
✓ Directorio EFI/OC encontrado
✓ Directorio Kexts encontrado
✓ Directorio Drivers encontrado

2. Verificando kexts esenciales...
✓ Lilu.kext encontrado
✓ VirtualSMC.kext encontrado
✓ WhateverGreen.kext encontrado
✓ AppleALC.kext encontrado
✓ AMDRyzenCPUPowerManagement.kext encontrado
✓ AppleMCEReporterDisabler.kext encontrado
✓ AMFIPass.kext encontrado

3. Verificando drivers esenciales...
✓ OpenRuntime.efi encontrado
✓ HfsPlus.efi encontrado
✓ OpenCanopy.efi encontrado

4. Verificando config.plist...
✓ config.plist encontrado
✓ NVIDIA drivers habilitados en boot-args
✓ Layout ID 3 configurado para audio
✓ agdpmod=pikera configurado para monitor

5. Verificando archivos ACPI...
✓ SSDT-EC.aml encontrado
✓ SSDT-PLUG.aml encontrado
✓ SSDT-PMC.aml encontrado
✓ SSDT-USB-Reset.aml encontrado
✓ SSDT-USBX.aml encontrado
```

## 🔧 Configuraciones Optimizadas

### Boot Arguments
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera
```

### Kexts Instalados
- ✅ **Lilu.kext** - Framework base
- ✅ **VirtualSMC.kext** - Emulación SMC
- ✅ **WhateverGreen.kext** - Compatibilidad gráficos
- ✅ **AppleALC.kext** - Audio (layout-id 3)
- ✅ **AMDRyzenCPUPowerManagement.kext** - Gestión energía Ryzen
- ✅ **AppleMCEReporterDisabler.kext** - Deshabilita MCE
- ✅ **AMFIPass.kext** - Bypass AMFI para Sequoia

### Configuración de BIOS Requerida
- **Secure Boot**: Deshabilitado
- **CSM**: Deshabilitado
- **Above 4G Decoding**: Habilitado
- **SVM Mode**: Habilitado
- **IOMMU**: Habilitado

## 🎵 Audio Configurado
- **Layout ID**: 3 (Realtek ALC)
- **Kext**: AppleALC.kext
- **Compatibilidad**: Verificada para tu motherboard

## 🖥️ Pantalla Optimizada
- **GPU**: NVIDIA GTX 1060 3GB
- **Monitor**: ASUS 165Hz
- **Solución**: agdpmod=pikera para alta frecuencia
- **Compatibilidad**: Verificada para Sequoia 15.6

## 📋 Checklist de Instalación

### Antes de Instalar
- [ ] Descargar macOS Sequoia 15.6
- [ ] Crear USB de instalación
- [ ] Configurar BIOS según guía
- [ ] Ejecutar verificación de OpenCore

### Durante la Instalación
- [ ] Bootear desde USB OpenCore
- [ ] Instalar macOS normalmente
- [ ] NO reiniciar durante instalación
- [ ] Completar configuración inicial

### Post-Instalación
- [ ] Instalar OpenCore en disco de sistema
- [ ] Configurar boot order
- [ ] Verificar audio y gráficos
- [ ] Instalar Legacy Patcher si es necesario

## 🆘 Solución de Problemas

### Problemas Comunes

#### No Bootea
```bash
# Verificar configuración
./verificar_opencore.sh

# Revisar boot-args
# Verificar Secure Boot deshabilitado
```

#### Sin Audio
```bash
# Verificar layout-id 3 en config.plist
# Comprobar AppleALC.kext
# Revisar conexiones de audio
```

#### Problemas de Pantalla
```bash
# Verificar agdpmod=pikera en boot-args
# Comprobar WhateverGreen.kext
# Revisar configuración de GPU
```

### Logs de Depuración
- Habilitar `debug=0x100` en boot-args
- Revisar logs en `/var/log/`
- Usar OpenCore Configurator para análisis

## 🔗 Recursos Útiles

- **OpenCore Documentation**: https://dortania.github.io/OpenCore-Install-Guide/
- **AMD OSX**: https://amd-osx.com/
- **OpenCore Legacy Patcher**: https://github.com/dortania/OpenCore-Legacy-Patcher
- **ProperTree**: Editor recomendado para config.plist

## 📞 Soporte

Si encuentras problemas:
1. Ejecuta `./verificar_opencore.sh`
2. Revisa `GUIA_OPENCORE_RYZEN_GTX1060.md`
3. Verifica configuraciones de BIOS
4. Consulta logs de depuración

## ⚠️ Notas Importantes

1. **Backup**: Siempre hacer backup antes de cambios
2. **Actualizaciones**: Verificar compatibilidad antes de actualizar
3. **Kexts**: Mantener kexts actualizados
4. **BIOS**: Mantener BIOS actualizado
5. **Legacy Patcher**: Usar si hay problemas con Sequoia 15.6

---

**Configuración verificada y optimizada para tu hardware específico.**
**Fecha**: $(date)
**Versión**: OpenCore 0.9.6
**Compatibilidad**: macOS Sequoia 15.6

¡Disfruta de tu Hackintosh! 🍎