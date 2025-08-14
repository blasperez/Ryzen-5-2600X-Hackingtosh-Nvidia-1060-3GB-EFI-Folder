DefinitionBlock ("", "SSDT", 2, "HACK", "PCI", 0x00000000)
{
	External (_SB_.PCI0.D002, DeviceObj)
	Device (_SB.PCI0.D002)
	{
		Name (_ADR, 0x00000000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) Root Complex" },
				"device_type", Buffer () { "Host bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,0,0" },
			})
		}
	}
	External (_SB_.PCI0.IOMA, DeviceObj)
	Device (_SB.PCI0.IOMA)
	{
		Name (_ADR, 0x00000002)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) I/O Memory Management Unit" },
				"device_type", Buffer () { "IOMMU" },
				"AAPL,slot-name", Buffer () { "Internal@0,0,2" },
			})
		}
	}
	External (_SB_.PCI0.GPP0, DeviceObj)
	Device (_SB.PCI0.GPP0)
	{
		Name (_ADR, 0x00010001)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) PCIe GPP Bridge" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,1" },
			})
		}
	}
	External (_SB_.PCI0.GPP2, DeviceObj)
	Device (_SB.PCI0.GPP2)
	{
		Name (_ADR, 0x00010003)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) PCIe GPP Bridge" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3" },
			})
		}
	}
	External (_SB_.PCI0.GP17, DeviceObj)
	Device (_SB.PCI0.GP17)
	{
		Name (_ADR, 0x00070001)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,7,1" },
			})
		}
	}
	External (_SB_.PCI0.GP18, DeviceObj)
	Device (_SB.PCI0.GP18)
	{
		Name (_ADR, 0x00080001)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) Internal PCIe GPP Bridge 0 to Bus B" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,8,1" },
			})
		}
	}
	External (_SB_.PCI0.D023, DeviceObj)
	Device (_SB.PCI0.D023)
	{
		Name (_ADR, 0x00140000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "FCH SMBus Controller" },
				"device_type", Buffer () { "SMBus" },
				"AAPL,slot-name", Buffer () { "Internal@0,20,0" },
			})
		}
	}
	External (_SB_.PCI0.SBRG, DeviceObj)
	Device (_SB.PCI0.SBRG)
	{
		Name (_ADR, 0x00140003)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "FCH LPC Bridge" },
				"device_type", Buffer () { "ISA bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,20,3" },
			})
		}
	}
	External (_SB_.PCI0.GPP0.M2_1, DeviceObj)
	Device (_SB.PCI0.GPP0.M2_1)
	{
		Name (_ADR, 0x00000000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "XPG SX8200 Pro PCIe Gen3x4 M.2 2280 Solid State Drive" },
				"device_type", Buffer () { "Non-Volatile memory controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,1/0,0" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PTXH, DeviceObj)
	Device (_SB.PCI0.GPP2.PTXH)
	{
		Name (_ADR, 0x00000000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "400 Series Chipset USB 3.1 xHCI Compliant Host Controller" },
				"device_type", Buffer () { "USB controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,0" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT01, DeviceObj)
	Device (_SB.PCI0.GPP2.PT01)
	{
		Name (_ADR, 0x00000001)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "400 Series Chipset SATA Controller" },
				"device_type", Buffer () { "SATA controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,1" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02)
	{
		Name (_ADR, 0x00000002)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "400 Series Chipset PCIe Bridge" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2" },
			})
		}
	}
	External (_SB_.PCI0.GP17.APSP, DeviceObj)
	Device (_SB.PCI0.GP17.APSP)
	{
		Name (_ADR, 0x00000002)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) Platform Security Processor (PSP) 3.0 Device" },
				"device_type", Buffer () { "Encryption controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,7,1/0,2" },
			})
		}
	}
	External (_SB_.PCI0.GP17.XHC0, DeviceObj)
	Device (_SB.PCI0.GP17.XHC0)
	{
		Name (_ADR, 0x00000003)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Zeppelin USB 3.0 xHCI Compliant Host Controller" },
				"device_type", Buffer () { "USB controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,7,1/0,3" },
			})
		}
	}
	External (_SB_.PCI0.GP18.SATA, DeviceObj)
	Device (_SB.PCI0.GP18.SATA)
	{
		Name (_ADR, 0x00000002)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "FCH SATA Controller [AHCI mode]" },
				"device_type", Buffer () { "SATA controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,8,1/0,2" },
			})
		}
	}
	External (_SB_.PCI0.GP18.HDEF, DeviceObj)
	Device (_SB.PCI0.GP18.HDEF)
	{
		Name (_ADR, 0x00000003)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "Family 17h (Models 00h-0fh) HD Audio Controller" },
				"layout-id", Buffer () { 0x03, 0x00, 0x00, 0x00 },
				"AAPL,slot-name", Buffer () { "Internal@0,8,1/0,3" },
				"device_type", Buffer () { "Audio device" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02.PT20, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02.PT20)
	{
		Name (_ADR, 0x00000000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "400 Series Chipset PCIe Port" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2/0,0" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02.PT21, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02.PT21)
	{
		Name (_ADR, 0x00010000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "400 Series Chipset PCIe Port" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2/1,0" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02.PT24, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02.PT24)
	{
		Name (_ADR, 0x00040000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "400 Series Chipset PCIe Port" },
				"device_type", Buffer () { "PCI bridge" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2/4,0" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02.PT24.HDAU, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02.PT24.HDAU)
	{
		Name (_ADR, 0x00000001)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "GP106 High Definition Audio Controller" },
				"device_type", Buffer () { "Audio device" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2/4,0/0,1" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02.PT24.GFX0, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02.PT24.GFX0)
	{
		Name (_ADR, 0x00000000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "GP106 [GeForce GTX 1060 3GB]" },
				"device_type", Buffer () { "VGA compatible controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2/4,0/0,0" },
			})
		}
	}
	External (_SB_.PCI0.GPP2.PT02.PT20.RLAN, DeviceObj)
	Device (_SB.PCI0.GPP2.PT02.PT20.RLAN)
	{
		Name (_ADR, 0x00000000)
		Method (_DSM, 4, NotSerialized)
		{
			If (LEqual (Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
			Return (Package ()
			{
				"model", Buffer () { "RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller" },
				"device_type", Buffer () { "Ethernet controller" },
				"AAPL,slot-name", Buffer () { "Internal@0,1,3/0,2/0,0/0,0" },
			})
		}
	}
}
