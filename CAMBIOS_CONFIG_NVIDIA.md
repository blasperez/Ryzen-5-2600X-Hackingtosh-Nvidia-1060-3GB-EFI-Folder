# Cambios Realizados para Solucionar Problemas con NVIDIA GTX 1060

## Problema Identificado
- El sistema crasheaba con pantalla negra al conectar dos monitores
- Las DeviceProperties de NVIDIA tenían entradas incorrectas (@0, @1, @2, @3) que no existen en el hardware
- Boot-args demasiado complejos causaban conflictos

## Cambios Aplicados

### 1. DeviceProperties de NVIDIA - SIMPLIFICADO
**Antes (INCORRECTO):**
- Tenía entradas @0,compatible, @1,compatible, @2,compatible, @3,compatible
- Tenía NVDA,Features y NVDA,NVArch que causaban conflictos
- Demasiadas propiedades innecesarias

**Ahora (CORRECTO):**
```xml
<key>PciRoot(0x0)/Pci(0x3,0x0)/Pci(0x0,0x0)</key>
<dict>
    <key>AAPL,slot-name</key>
    <string>Slot-1</string>
    <key>device-id</key>
    <data>HAIAAA==</data>
    <key>model</key>
    <string>NVIDIA GeForce GTX 1060 3GB</string>
</dict>
```
Solo las propiedades esenciales, sin entradas de display falsas.

### 2. Boot-args - SIMPLIFICADO
**Antes:**
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=7 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware ipc_control_port_options=0 -lilubetaall
```

**Ahora:**
```
-v debug=0x100 keepsyms=1 npci=0x2000 alcid=12 agdpmod=pikera
```
Solo los parámetros esenciales para AMD + NVIDIA.

### 3. Kexts Ajustados
**Agregado:**
- AmdTscSync.kext - Para sincronización TSC en procesadores AMD (IMPORTANTE)

**Mantenidos:**
- Lilu.kext
- VirtualSMC.kext
- WhateverGreen.kext
- AppleALC.kext
- RealtekRTL8111.kext
- AMDRyzenCPUPowerManagement.kext
- RestrictEvents.kext
- SMCProcessor.kext
- AMFIPass.kext
- AppleMCEReporterDisabler.kext

### 4. SSDTs Ajustados
**Cambiado:**
- Reemplazado SSDT-PLUG y SSDT-PMC por SSDT-HPET (más compatible con AMD)

**Mantenidos:**
- SSDT-EC.aml
- SSDT-HPET.aml
- SSDT-USB-Reset.aml
- SSDT-USBX.aml

### 5. Quirks Corregidos
- LapicKernelPanic: cambiado de true a **false** (importante para estabilidad)

### 6. Audio
- Layout-id cambiado a **12** (mejor para ASUS TUF)

## Por qué estos cambios solucionan el problema

1. **DeviceProperties limpias**: Las entradas @0, @1, @2, @3 incorrectas causaban que macOS intentara inicializar displays que no existen, causando crash con dos monitores.

2. **Boot-args simplificados**: Menos parámetros = menos conflictos. Solo lo esencial.

3. **AmdTscSync.kext**: Crítico para sincronización de tiempo en CPUs AMD multi-core.

4. **SSDT-HPET**: Mejor manejo de interrupciones para AMD.

5. **LapicKernelPanic=false**: Evita kernel panics relacionados con LAPIC en AMD.

## Resultado Esperado
- ✅ Sistema arranca correctamente
- ✅ Funciona con UN monitor
- ✅ Funciona con DOS monitores sin crashear
- ✅ Audio funcional
- ✅ NVIDIA detectada correctamente

## Nota Importante
El problema principal era que las DeviceProperties de NVIDIA tenían entradas de display (@0, @1, @2, @3) que macOS intentaba inicializar pero no existían físicamente, causando el crash al conectar el segundo monitor.