import "pe"

rule sidewinder_stage1_dropper : APT_Sidewinder {
	meta:
		author = "Ebryx DFIR"
		date = "09-04-2020"
		description = "Detects stage-1 JavaScript dropper"
		tlp = "Green"
	strings:
		$cnc1 = "o.pink" fullword
		$cnc2 = "o.Work" fullword
		$enum3 = "finally{window.close()" fullword
		$enum4 = "fileEnum" fullword
		$enum5 = "fileEnum.moveFirst()" fullword
		$enum6 = "GetFolder"
		$enum7 = "GetSpecialFolder"
		$com1 = "<script"
		$com2 = "javascript"
		$com3 = "</script>"
	condition:
		filesize >= 200KB and (1 of ($cnc*) and 2 of ($com*) and 3 of ($enum*))
}

rule sidewinder_linkzip_dll : APT_Sidewinder {
	meta:
		author = "Ebryx DFIR"
		date = "09-04-2020"
		description = "Detects LinkZip.dll exploit generator by James Forshaw"
		tlp = "Green"
	strings:
		$str1 = "James Forshaw 2017" fullword ascii
		$str2 = "LegalCopyrightCopyright"
		$str3 = "OriginalFilenameLinkZip.dll@"
		$str4 = "/_CorDllMainmscoree.dll"
		$str5 = "WinHttp.WinHttpRequest"
		$str6 = "$Example Assembly for DotNetToJScript"
		$str7 = "$56598f1c-6d88-4994-a392-af337abe5777" fullword ascii
		$str8 = "'System.Reflection.Assembly Load(Byte[])" fullword ascii
		$str9 = "mshta.exe"
	condition:
		filesize < 10KB and (6 of ($str*)) and uint16be(0) == 0x4D5A
}

rule sidewinder_duser_dll : APT_Sidewinder {
	meta:
		author = "Ebryx DFIR"
		date = "09-04-2020"
		description = "Detects DUser.dll dropped by stage-1 javascript dropper"
		tlp = "Green"
	strings:
		$str1 = "$92d2f2dd-43d1-49a9-9ab5-b56ad3eb4af9"
		$str2 = "_CorDllMain"
		$str3 = "\\DUSER.dll"
		$str4 = "mscoree.dll"
		$str5 = "copytight @"
		$str6 = "System.Diagnostics" fullword
		$str7 = "LwBFLmM.tmp " fullword wide
		$com1 = "Invoke"
		$com2 = "GetCurrentProcess"
		$exp1 = "FileRipper"
		$exp2 = "InitGadgets"
		$exp3 = "Gadgets"
	condition:
		filesize < 7KB and 4 of ($str*) and (any of ($exp*) and all of ($com*)) and uint16be(0) == 0x4D5A
}

rule sidewinder_spearphishing_lnk : APT_Sidewinder {
	meta:
		author = "Ebryx DFIR"
		date = "09-04-2020"
		description = "Detects .lnk file sent in email containing the command to contact C2 domain"
		tlp = "Green"
	strings:
		$str1 = "cftmo.exe"
		$str2 = "user-pc"
		$str3 = "C:\\Windows\\System32\\"
		$str4 = {6D 00 73 00 48 00 74 00 61}
	condition:
		filesize <= 297KB and all of them
}

rule maldoc_rtf_cve_2017_11882 : APT_Sidewinder {

	meta:
		author = "Ebryx DFIR"
		date = "25-08-2020"
		description = "Detects the maldoc in spear-phishing campaign by SideWinder"
		tlp = "Green"

	strings:
		$obj1 = "\\*\\objclass Equation.3"
		$obj2 = "\\*\\objclass Package"
		$obj3 = "4d6963726f736f6674204571756174696f6e20332e30" ascii

		$x1 = { 45 71 75 61 74 69 6F 6E }
		$x2 = { 50 61 63 6B 61 67 65 }
		$x3 = { 36 44 30 30 37 33 30 30 36 38 30 30 37 34 30 30 36 44 30 30 36 43 }
		$x4 = { 36 45 37 35 36 45 34 38 35 34 34 44 34 43 34 31 37 30 37 30 36 43 36 39 36 33 36 31 37 34 36 39 36 46 36 45 }
		$x5 = { 34 37 36 35 37 34 34 33 36 46 36 44 36 44 36 31 36 45 36 34 34 43 36 39 36 45 36 35 35 37 30 30 35 33 }
		$x6 = { 34 33 33 41 35 43 35 35 37 33 36 35 37 32 37 33 35 43 37 35 37 33 36 35 37 32 35 43 34 31 37 30 37 30 34 34 36 31 37 34 36 31 35 43 34 43 36 46 36 33 36 31 36 43 35 43 35 34 36 35 36 44 37 30 35 43 }
		$x7 = { 34 33 33 41 35 43 35 35 37 33 36 35 37 32 37 33 35 43 37 35 37 33 36 35 37 32 35 43 34 31 37 30 37 30 34 34 36 31 37 34 36 31 35 43 34 43 36 46 36 33 36 31 36 43 35 43 34 44 36 39 36 33 37 32 36 46 37 33 36 46 36 36 37 34 35 43 35 37 36 39 36 45 36 34 36 46 37 37 37 33 35 43 34 39 34 45 36 35 37 34 34 33 36 31 36 33 36 38 36 35 35 43 34 33 36 46 36 45 37 34 36 35 36 45 37 34 32 45 35 37 36 46 37 32 36 34 35 43 }
	
	condition:
		( 5 of ($x*) or (all of ($obj*) and 2 of ($x*))) and (uint32be(0) == 0x7B5C7274 or uint32be(0) == 0x7B5C2A5C) and filesize > 300KB
}

rule sidewinder_stage1_dropper_variant1 : APT_Sidewinder {

	meta:
		author = "Ebryx DFIR"
		date = "25-08-2020"
		description = "Detects Stage-1 javascript dropper"
		tlp = "Green"

	strings:
		$enum1 = "finally{window.close()" fullword
		$enum2 = "fileEnum"
		$enum3 = "fileEnum.moveFirst()" fullword
		$enum4 = "GetFolder"
		$enum5 = "GetSpecialFolder"
		$enum6 = "shells.Environment" ascii

		$str1 = "try{"
		$str2 = "var keeee"
		$str3 = "<script language=\"javascript\">"

	condition:
		filesize >= 100KB and (4 of ($enum*) and 2 of ($str*))
}