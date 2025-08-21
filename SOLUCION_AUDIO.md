# Solución para Audio Realtek ALCS1200A

## Problema
El audio no funcionó después de instalar el parche de OpenCore Legacy Patcher. Se había configurado incorrectamente el layout ID 3, cuando la placa es una ASUS TUF Gaming Plus II con codec Realtek ALCS1200A.

## Solución Aplicada

### Cambios Realizados:

1. **Boot-args actualizado:**
   - Cambiado de `alcid=3` a `alcid=7` (recomendado para ASUS TUF Gaming Plus II)

2. **DeviceProperties actualizado:**
   - layout-id cambiado de `<integer>3</integer>` a `<integer>7</integer>`

## Layouts Disponibles para ALCS1200A

| ID | Descripción | Placa Base Compatible |
|----|-------------|----------------------|
| 1  | toleda - Genérico | Universal |
| 2  | toleda - Genérico | Universal |
| 3  | toleda - Genérico | Universal |
| **7**  | **Kila2** | **B550M Gaming Carbon WIFI / ASUS TUF Gaming Plus II** ✅ |
| 11 | owen0o0 | Universal |
| 12 | mobilestebu | ASUS TUF-Z390M-Gaming |
| 23 | VictorXu | MSI B460I GAMING EDGE WIFI |
| 49 | VictorXu | Asrock Z490M-ITX |
| 50 | VictorXu | Gigabyte B460M Aorus Pro |
| 51 | GeorgeWan | ASROCK-Z490-Steel-Legend |
| 52 | GeorgeWan | MSI-Mortar-B460M |
| 69 | Lorys89/Vorshim92 | ASROCK Z490M ITX AC |

## Cómo Verificar el Audio

### 1. Verificar que AppleALC está cargado:
```bash
kextstat | grep -i AppleALC
```

### 2. Verificar el codec detectado:
```bash
ioreg -l | grep -i "alc"
```

### 3. Ver dispositivos de audio:
```bash
system_profiler SPAudioDataType
```

### 4. Probar el audio:
```bash
# Reproducir sonido de prueba
afplay /System/Library/Sounds/Ping.aiff
```

## Si el Audio No Funciona

### Opción 1: Probar Otro Layout
Para ASUS TUF Gaming Plus II, prueba estos layouts en orden:
1. Layout 7 (B550M Gaming / ASUS TUF) - **CONFIGURADO ACTUALMENTE**
2. Layout 11 (genérico owen0o0)
3. Layout 1 (genérico toleda básico)
4. Layout 2 (genérico toleda extendido)
5. Layout 5 (reportado por algunos usuarios ASUS TUF)

### Opción 2: Usar el Script de Test
```bash
./test_audio_layouts.sh
```
Este script te permite:
- Cambiar fácilmente entre layouts
- Probar el audio actual
- Ver la configuración actual
- Restaurar backups

### Opción 3: Cambio Manual
Para cambiar manualmente el layout:

1. **En Terminal (temporal):**
```bash
# Cambiar a layout 11 por ejemplo
sudo nvram boot-args="debug=0x100 keepsyms=1 npci=0x2000 nvda_drv_vrl=1 ngfxcompat=1 ngfxgl=1 amfi_get_out_of_my_way=1 alcid=11 -allow-root -nvda_drv=1 -v -no_compat_check agdpmod=pikera -disablegfxfirmware"
```

2. **En config.plist (permanente):**
- Buscar `alcid=12` y cambiar el número
- Buscar `<key>layout-id</key>` y cambiar el `<integer>12</integer>`

## Requisitos

### Kexts Necesarios:
- ✅ **AppleALC.kext** - Principal driver de audio
- ✅ **Lilu.kext** - Framework requerido por AppleALC

### Verificar que están habilitados:
```bash
ls -la EFI/OC/Kexts/ | grep -E "AppleALC|Lilu"
```

## Troubleshooting Adicional

### Si no hay ningún sonido:
1. **Verificar volumen:** Asegúrate de que no esté silenciado
2. **Verificar salida:** Ve a Preferencias > Sonido y selecciona la salida correcta
3. **Reset NVRAM:** En el bootloader, selecciona "Reset NVRAM"
4. **Verificar BIOS:** Asegúrate de que el audio esté habilitado en BIOS

### Si el micrófono no funciona:
- Algunos layouts solo soportan salida de audio
- Prueba layouts 11, 12, o 7 que suelen tener mejor soporte de entrada

### Si hay ruido o distorsión:
1. Prueba otro layout
2. Verifica que no haya conflictos con otros kexts
3. Deshabilita mejoras de audio en BIOS si las hay

## Comandos Útiles

```bash
# Ver el layout actual configurado
grep -o "alcid=[0-9]*" EFI/OC/config.plist

# Limpiar caché de audio
sudo killall coreaudiod

# Ver logs de AppleALC
log show --last 5m | grep -i AppleALC

# Verificar que el codec está parcheado
ioreg -l | grep -i "alc-layout-id"
```

## Notas Importantes

- **Layout 7** es recomendado para ASUS TUF Gaming Plus II y placas B550M Gaming
- El layout 7 suele funcionar bien con placas ASUS TUF Gaming modernas
- Si el layout 7 no funciona, usa el script `audio_asus_tuf_gaming_plus_ii.sh`
- Después de cambiar el layout, **siempre reinicia** para aplicar los cambios
- Algunos layouts pueden funcionar parcialmente (solo salida o solo entrada)

---

**¡El audio debería funcionar ahora con el layout 7 para tu ASUS TUF Gaming Plus II!** 🎵

Si aún tienes problemas, ejecuta `./test_audio_layouts.sh` para probar diferentes configuraciones.