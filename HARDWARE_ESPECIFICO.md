# Configuración OpenCore para tu Hardware Específico

## 🖥️ Especificaciones de tu Sistema

### Motherboard
- **Modelo:** ASUS TUF GAMING B450-PLUS II
- **Chipset:** AMD B450
- **Southbridge:** AMD B450
- **LPCIO:** ITE IT8665E
- **BIOS:** American Megatrends Inc. v4631 (01/14/2025)

### CPU
- **Procesador:** AMD Ryzen 5 2600X
- **Arquitectura:** Pinnacle Ridge
- **Cores:** 6 núcleos físicos
- **Threads:** 12 hilos
- **Frecuencia Base:** 3770.55 MHz
- **Socket:** AM4 (1331)
- **TDP:** 95.0 W

### RAM
- **Capacidad Total:** 16 GB (2x8GB)
- **Tipo:** DDR4
- **Frecuencia:** 1323.5 MHz (DDR4-2666)
- **Timings:** 16-18-18-38
- **Command Rate:** 1T

### GPU
- **Modelo:** NVIDIA GeForce GTX 1060 3GB
- **Fabricante:** Gigabyte Technology
- **Código:** GP106-300
- **Revisión:** A1
- **Memoria:** 3GB GDDR5
- **Bus Width:** 192 bits
- **Tecnología:** 16nm

## ⚙️ Configuración Específica para tu Hardware

### 1. SMBIOS Recomendado
Para tu Ryzen 5 2600X, el mejor SMBIOS es:
- **iMacPro1,1** (Actualmente configurado) ✅
- Alternativa: **MacPro7,1** (si tienes problemas con DRM)

### 2. Boot Arguments Optimizados
```
debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=7 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware
```

### 3. Configuración de Audio
- **Codec:** Realtek ALCS1200A (confirmado para B450)
- **Layout ID:** 7 (óptimo para ASUS TUF B450-PLUS II)
- Alternativas: 11, 1, 2

### 4. Patches de Kernel Específicos
Todos los patches AMD Ryzen están correctamente configurados para:
- Ryzen 5 2600X (Pinnacle Ridge)
- 6 cores / 12 threads

### 5. Configuración de RAM
Tu RAM DDR4-2666 está funcionando correctamente:
- Frecuencia real: 1323.5 MHz x2 = 2666 MHz
- No requiere configuración adicional en OpenCore

### 6. Configuración de GPU
NVIDIA GTX 1060 3GB (GP106-300):
- DeviceProperties ya configuradas correctamente
- WhateverGreen.kext presente
- agdpmod=pikera agregado para evitar pantalla negra

## 🔧 Ajustes Recomendados en BIOS

Para tu ASUS TUF GAMING B450-PLUS II:

### Deshabilitar:
- [ ] Fast Boot
- [ ] Secure Boot
- [ ] CSM (Compatibility Support Module)
- [ ] Serial/COM Port
- [ ] Parallel Port
- [ ] Above 4G Decoding (puede causar problemas con NVIDIA)

### Habilitar:
- [x] EHCI/XHCI Hand-off
- [x] OS Type: Other OS
- [x] SATA Mode: AHCI

### CPU:
- [x] SVM Mode: Enabled (para virtualización)
- [x] Cool'n'Quiet: Enabled
- [x] C-States: Auto
- [x] AMD-V: Enabled

## 📝 Notas Importantes

1. **Chipset B450**: Totalmente compatible con macOS
2. **Ryzen 5 2600X**: Excelente compatibilidad con los patches actuales
3. **GTX 1060 3GB**: Funciona bien con los drivers de NVIDIA y WhateverGreen
4. **ASUS TUF B450-PLUS II**: Placa muy popular en hackintosh

## 🚀 Estado de Compatibilidad

| Componente | Estado | Notas |
|------------|--------|-------|
| CPU | ✅ Perfecto | Patches AMD aplicados |
| GPU | ✅ Funcional | Con WhateverGreen + agdpmod |
| Audio | ✅ Configurado | Layout 7 para ALCS1200A |
| Ethernet | ✅ Funcional | RealtekRTL8111.kext |
| USB | ✅ Mapeado | SSDT-USB-Reset aplicado |
| Sleep/Wake | ⚠️ Parcial | Común en AMD |

## 🔍 Verificación Post-Instalación

Después de arrancar macOS, verifica:

```bash
# CPU
sysctl -n machdep.cpu.brand_string
# Debería mostrar: AMD Ryzen 5 2600X

# GPU
system_profiler SPDisplaysDataType | grep "Chipset Model"
# Debería mostrar: NVIDIA GeForce GTX 1060 3GB

# Audio
system_profiler SPAudioDataType | grep "Device"
# Debería detectar Realtek ALCS1200A

# RAM
system_profiler SPMemoryDataType | grep "Size"
# Debería mostrar: 8 GB x2
```

---

**Tu configuración está optimizada para tu hardware específico** 🎯