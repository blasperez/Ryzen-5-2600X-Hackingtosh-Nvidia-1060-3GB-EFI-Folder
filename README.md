# Hackintosh OpenCore - ASUS TUF GAMING B450-PLUS II + Ryzen 5 2600X + GTX 1060 3GB

[![OpenCore](https://img.shields.io/badge/OpenCore-0.9.x-blue)](https://github.com/acidanthera/OpenCorePkg)
[![macOS](https://img.shields.io/badge/macOS-Monterey%2B-brightgreen)](https://www.apple.com/macos/)
[![Status](https://img.shields.io/badge/Status-Working-success)](https://github.com/blasperez/Ryzen-5-2600X-Hackingtosh-Nvidia-1060-3GB-EFI-Folder)

## 🖥️ Hardware Specifications

| Component | Model | Status |
|-----------|-------|--------|
| **Motherboard** | ASUS TUF GAMING B450-PLUS II | ✅ Working |
| **CPU** | AMD Ryzen 5 2600X (6C/12T) | ✅ Working |
| **GPU** | NVIDIA GeForce GTX 1060 3GB (Gigabyte) | ✅ Working |
| **RAM** | 16GB DDR4-2666 (2x8GB) | ✅ Working |
| **Audio** | Realtek ALCS1200A | ✅ Working (Layout 7) |
| **Ethernet** | Realtek RTL8111 | ✅ Working |
| **Storage** | NVMe/SATA | ✅ Working |

## ✨ Features

### What's Working
- ✅ **CPU Power Management** - Native AMD power management
- ✅ **GPU Acceleration** - Full graphics acceleration with NVIDIA
- ✅ **Audio** - Full audio with AppleALC (Layout ID: 7)
- ✅ **Ethernet** - Native ethernet with RealtekRTL8111
- ✅ **USB Ports** - All USB ports mapped correctly
- ✅ **NVRAM** - Native NVRAM working
- ✅ **iCloud/iMessage** - Working with proper SMBIOS

### What's Not Working / Partially Working
- ⚠️ **Sleep/Wake** - Common limitation on AMD systems
- ⚠️ **DRM** - Some DRM content may not work with NVIDIA
- ❌ **Sidecar** - Requires Intel CPU with iGPU

## 🔧 BIOS Settings

### Disable
- Fast Boot
- Secure Boot
- CSM (Compatibility Support Module)
- Serial/COM Port
- Parallel Port
- Above 4G Decoding (may cause issues with NVIDIA)

### Enable
- EHCI/XHCI Hand-off
- OS Type: Other OS
- SATA Mode: AHCI
- SVM Mode (for virtualization)

## 📦 Included Kexts

| Kext | Version | Description |
|------|---------|-------------|
| Lilu | Latest | Patching framework |
| WhateverGreen | Latest | Graphics patching |
| AppleALC | Latest | Audio support |
| RealtekRTL8111 | Latest | Ethernet driver |
| VirtualSMC | Latest | SMC emulation |
| AMDRyzenCPUPowerManagement | Latest | CPU power management |
| RestrictEvents | Latest | CPU name fixes |

## 🚀 Installation

1. **Download the EFI folder** from this repository
2. **Mount your EFI partition** using tools like MountEFI
3. **Copy the EFI folder** to your EFI partition
4. **Generate new SMBIOS** using GenSMBIOS for iMacPro1,1
5. **Adjust BIOS settings** as listed above
6. **Boot from OpenCore** and install macOS

## ⚙️ Post-Installation

### ⚠️ IMPORTANT: OpenCore Legacy Patcher (OCLP)
**READ `PREVENCION_PANTALLA_NEGRA_OCLP.md` BEFORE applying OCLP!**

The config includes:
- Special boot-args for OCLP: `ipc_control_port_options=0 -lilubetaall`
- Emergency boot entries (press Space in OpenCore menu)
- NVIDIA-specific fixes: `agdpmod=pikera -disablegfxfirmware`

### Fix Audio (if needed)
```bash
# Current layout is 7, if not working try:
./audio_asus_tuf_gaming_plus_ii.sh
```

### Emergency Recovery Options
If screen goes black:
1. Restart and press **Space** in OpenCore
2. Select **"macOS Recovery (Sin GPU NVIDIA)"**
3. This will boot with `nv_disable=1` to recover

### Verify Installation
```bash
# Check CPU
sysctl -n machdep.cpu.brand_string

# Check GPU
system_profiler SPDisplaysDataType | grep "Chipset Model"

# Check Audio
system_profiler SPAudioDataType
```

## 🔍 Troubleshooting

### Black Screen Issues
- Boot arguments include `agdpmod=pikera` and `-disablegfxfirmware` for NVIDIA compatibility
- If issues persist, try `nv_disable=1` temporarily

### Audio Not Working
- Layout ID 7 is configured for ASUS TUF B450-PLUS II
- Alternative layouts: 11, 1, 2, 5
- Use the included script to test different layouts

### Performance Issues
- Ensure AMD patches are enabled in config.plist
- Verify BIOS settings, especially C-States and Cool'n'Quiet

## 📝 Notes

- This EFI is specifically configured for ASUS TUF GAMING B450-PLUS II
- SMBIOS is set to iMacPro1,1 (optimal for Ryzen CPUs)
- Remember to generate your own serial numbers for iCloud/iMessage

## 🤝 Credits

- [OpenCore Team](https://github.com/acidanthera/OpenCorePkg)
- [AMD-OSX Community](https://amd-osx.com)
- [Dortania Guides](https://dortania.github.io/OpenCore-Install-Guide/)

## ⚠️ Disclaimer

This repository is for educational purposes only. Please comply with Apple's EULA and your local laws.

---

**Last Updated:** January 2025
**OpenCore Version:** 0.9.x
**Tested macOS:** Monterey, Ventura, Sonoma