# 🛡️ PREVENCIÓN de Pantalla Negra con OpenCore Legacy Patcher

## ⚠️ IMPORTANTE: Configuración ANTES de aplicar OCLP

### 🔴 El Problema
Cuando aplicas OpenCore Legacy Patcher (OCLP) en un sistema con NVIDIA, puede resultar en pantalla negra al reiniciar. **NO PUEDES ejecutar scripts si ya tienes pantalla negra**, por eso esta guía es PREVENTIVA.

## ✅ Configuración Ya Aplicada

He agregado estos boot-args específicos para OCLP:
```
ipc_control_port_options=0 -lilubetaall
```

Además de los que ya teníamos para NVIDIA:
```
agdpmod=pikera -disablegfxfirmware
```

## 🚨 ANTES de Aplicar OCLP

### Paso 1: Crear Punto de Restauración
```bash
# Hacer backup del config.plist actual
cp /Volumes/EFI/EFI/OC/config.plist /Volumes/EFI/EFI/OC/config.plist.pre-oclp

# Hacer backup completo de la carpeta EFI
cp -R /Volumes/EFI/EFI /Volumes/EFI/EFI-BACKUP-PRE-OCLP
```

### Paso 2: Verificar Entradas de Emergencia
He agregado 2 entradas de arranque de emergencia en OpenCore:

1. **macOS Recovery (Sin GPU NVIDIA)** - Desactiva NVIDIA temporalmente
2. **macOS Safe Mode** - Modo seguro con `-x -v`

Para verlas:
- Al arrancar, presiona **Espacio** en el menú de OpenCore
- Aparecerán las opciones adicionales

## 🔧 Cómo Usar las Entradas de Emergencia

### Si la Pantalla se Pone Negra:

1. **Reinicia** (mantén presionado el botón de encendido)

2. En el menú de OpenCore:
   - Presiona **Espacio** para ver todas las opciones
   - Selecciona **"macOS Recovery (Sin GPU NVIDIA)"**
   - Esto arrancará con `nv_disable=1`

3. Una vez dentro con video funcionando:
   ```bash
   # Opción A: Revertir OCLP
   sudo /Library/Application\ Support/OpenCore-Legacy-Patcher/OpenCore-Legacy-Patcher.app/Contents/MacOS/OpenCore-Legacy-Patcher --revert
   
   # Opción B: Modificar boot-args permanentemente
   sudo nvram boot-args="debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=7 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware ipc_control_port_options=0 -lilubetaall -wegnoegpu"
   ```

## 🎯 Boot-args Específicos para OCLP + NVIDIA

### Boot-args actuales configurados:
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=7 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware ipc_control_port_options=0 -lilubetaall
```

### Explicación de los nuevos parámetros:
- `ipc_control_port_options=0` - Necesario para OCLP en macOS modernos
- `-lilubetaall` - Habilita todas las características beta de Lilu
- `agdpmod=pikera` - Evita pantalla negra con NVIDIA
- `-disablegfxfirmware` - Desactiva firmware de gráficos problemático

## 🔄 Proceso Seguro para Aplicar OCLP

1. **Verifica que tienes las entradas de emergencia** (presiona Espacio en OpenCore)
2. **Haz backup de tu EFI**
3. **Aplica OCLP**
4. **Si hay pantalla negra**, usa la entrada "macOS Recovery (Sin GPU NVIDIA)"

## 💡 Alternativas Adicionales

### Opción 1: Arranque en Modo Texto
Si necesitas ver qué está pasando:
- En OpenCore, presiona **Cmd+V** antes de seleccionar macOS
- Verás todos los mensajes de arranque

### Opción 2: Reset NVRAM
Si nada funciona:
- En OpenCore, presiona **Espacio**
- Selecciona **Reset NVRAM**
- El sistema se reiniciará con valores por defecto

### Opción 3: USB de Emergencia
Mantén un USB con:
- OpenCore configurado sin OCLP
- macOS installer
- Tu backup de EFI

## 📋 Checklist Pre-OCLP

- [ ] Backup de config.plist hecho
- [ ] Backup de carpeta EFI completa
- [ ] Verificadas las entradas de emergencia en OpenCore
- [ ] Boot-args correctos configurados
- [ ] USB de emergencia preparado

## 🆘 Comandos de Emergencia (Memoriza)

Si tienes que trabajar a ciegas:

```bash
# Desactivar NVIDIA completamente
sudo nvram boot-args="nv_disable=1 -v"
sudo reboot

# Restaurar backup
cp /Volumes/EFI/EFI/OC/config.plist.pre-oclp /Volumes/EFI/EFI/OC/config.plist
sudo reboot

# Limpiar NVRAM
sudo nvram -c
sudo reboot
```

---

**RECUERDA**: Es mejor PREVENIR que tener que solucionar con pantalla negra. ¡Haz los backups ANTES de aplicar OCLP!