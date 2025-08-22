# Solución para Error AirPlayXPCHelper en Boot

## Problema Identificado
El sistema se atasca en el arranque con errores de:
- `AirPlayXPCHelper` 
- `AppleKeyStore: operation failed`
- `IOKit Daemon stall`

Estos errores son causados por incompatibilidad entre:
1. NVIDIA GPU 
2. Servicios de AirPlay/Media Streaming de macOS
3. Verificaciones de Board-ID

## Soluciones Aplicadas

### 1. Bloqueo de AirPlaySupport
Se agregó en `Kernel > Block`:
```xml
<dict>
    <key>Comment</key>
    <string>Block AirPlaySupport</string>
    <key>Enabled</key>
    <true/>
    <key>Identifier</key>
    <string>com.apple.driver.AirPlaySupport</string>
    <key>Strategy</key>
    <string>Disable</string>
</dict>
```

### 2. Boot-args Simplificados
**Nuevo:**
```
-v npci=0x2000 alcid=12 agdpmod=pikera -wegnoegpu
```
- `-wegnoegpu`: Deshabilita GPU integrada
- `agdpmod=pikera`: Fix para NVIDIA
- Removidos parámetros que causaban conflictos

### 3. RestrictEvents Configurado
En NVRAM añadido:
- `revpatch=sbvmm,cpuname,f16c`
- `revblock=media-streamer,pci-bridge`

Esto bloquea servicios problemáticos de streaming.

### 4. Quirks Ajustados
- `ProvideCurrentCpuInfo`: **false** (reduce conflictos)
- `DisableIoMapper`: **false**
- `DisableIoMapperMapping`: **false**

## Si Aún No Arranca

### Opción 1: Boot Seguro Sin GPU
En el boot picker, presiona tecla numérica para agregar boot-args temporales:
```
-v nv_disable=1 -x
```

### Opción 2: Reset NVRAM Completo
1. En boot picker presiona ESPACIO
2. Selecciona "Reset NVRAM"
3. Reinicia

### Opción 3: Editar desde Recovery
1. Arranca desde USB de instalación
2. Terminal:
```bash
diskutil mount disk0s1  # o tu partición EFI
cd /Volumes/EFI/EFI/OC/
nano config.plist
```
3. Busca `boot-args` y agrega: `nv_disable=1`

## Servicios Deshabilitados
- AirPlay
- Media Streaming 
- Board-ID checks innecesarios

Estos servicios no son esenciales y causan conflictos con NVIDIA.

## Resultado Esperado
✅ Boot exitoso sin atascarse en AirPlayXPCHelper
✅ Sistema funcional con NVIDIA
✅ Sin errores de AppleKeyStore