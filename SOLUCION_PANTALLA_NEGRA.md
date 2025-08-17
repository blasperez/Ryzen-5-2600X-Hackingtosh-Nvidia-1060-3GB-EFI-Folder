# Solución para Pantalla Negra después de OpenCore Legacy Patcher

## Problema
Después de aplicar el parche de OpenCore Legacy Patcher, el sistema no muestra imagen al entrar a macOS con una GTX 1060 3GB.

## Cambios Aplicados

### 1. Boot-args Modificados
Se agregaron los siguientes parámetros al `config.plist`:

**Antes:**
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check
```

**Después:**
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware
```

**Nuevos parámetros agregados:**
- `agdpmod=pikera`: Evita problemas de pantalla negra con NVIDIA
- `-disablegfxfirmware`: Mejora la compatibilidad con tarjetas NVIDIA

### 2. DeviceProperties Mejorados
Se agregaron propiedades adicionales para la GTX 1060:

```xml
<key>AAPL,slot-name</key>
<string>Slot-1</string>
<key>@0,compatible</key>
<string>NVDA,NVMac</string>
<key>@0,device_type</key>
<string>display</string>
<key>@0,name</key>
<string>NVDA,Display-A</string>
<!-- ... más propiedades para Display-B, C, D -->
```

## Pasos para Aplicar la Solución

### Paso 1: Verificar la Configuración
1. Asegúrate de que los cambios se aplicaron correctamente al `config.plist`
2. Verifica que tienes `WhateverGreen.kext` y `Lilu.kext` en tu carpeta `EFI/OC/Kexts/`

### Paso 2: Reiniciar y Probar
1. Guarda los cambios en el `config.plist`
2. Reinicia el sistema
3. Selecciona macOS desde el bootloader de OpenCore

### Paso 3: Si el Problema Persiste

#### Opción A: Modo Seguro
1. Reinicia y mantén presionada la tecla **Shift** durante el arranque
2. Una vez en modo seguro, abre Terminal
3. Ejecuta:
```bash
sudo nvram boot-args="debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=3 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware"
```
4. Reinicia normalmente

#### Opción B: Boot-args de Emergencia
Si nada funciona, usa el archivo `config_emergencia.plist` que incluye:
```
nv_disable=1
```
Esto deshabilitará temporalmente los drivers de NVIDIA para diagnosticar.

#### Opción C: Verificar Drivers
1. Ve a **Preferencias del Sistema > Software Update**
2. Instala cualquier actualización de NVIDIA disponible
3. Reinicia el sistema

## Verificación

Para verificar que los cambios se aplicaron correctamente:

```bash
sudo nvram -p | grep boot-args
```

Deberías ver los nuevos parámetros incluidos.

## Kexts Necesarios

Asegúrate de tener estos kexts en tu carpeta `EFI/OC/Kexts/`:

- ✅ **WhateverGreen.kext** - Esencial para NVIDIA
- ✅ **Lilu.kext** - Framework necesario
- ✅ **AMFIPass.kext** - Para compatibilidad con macOS moderno

## Troubleshooting Adicional

### Si la pantalla sigue negra:
1. **Deshabilitar WhateverGreen temporalmente**: Comenta la línea en el config.plist
2. **Usar drivers nativos**: Elimina `nvda_drv=1` de los boot-args
3. **Verificar conexiones**: Asegúrate de que el monitor esté conectado correctamente

### Para diagnosticar:
1. Agrega `-v` a los boot-args para ver logs detallados
2. Usa `nv_disable=1` temporalmente
3. Verifica que no haya conflictos con otros kexts

## Notas Importantes

- **Backup**: Siempre haz una copia de seguridad de tu `config.plist` antes de hacer cambios
- **Versión de macOS**: Esta solución está probada en macOS 12+ con OpenCore Legacy Patcher
- **Hardware**: Específicamente para GTX 1060 3GB, pero puede funcionar con otras tarjetas NVIDIA similares

## Contacto

Si el problema persiste después de aplicar todos estos pasos, considera:
1. Revisar los logs de OpenCore
2. Verificar la compatibilidad de tu hardware
3. Buscar ayuda en foros especializados de hackintosh

---

**¡Buena suerte!** 🍀