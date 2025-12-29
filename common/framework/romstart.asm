IF !DEF(FRAMEWORK_ROMSTART_ASM)
DEF FRAMEWORK_ROMSTART_ASM EQU 0

SECTION "RESERVED", ROM0[$0]

ds $40 - @, 0

SECTION "HEADER", ROM0[$0100]
; that's where the actual ROM header starts, we just reserve until 0x150 for it
; of course we could do more, see the Pan doc for it
; https://gbdev.io/pandocs/The_Cartridge_Header

  jp EntryPoint
  ds $150 - @, $00 ; room for the nintendo logo

SECTION "STARTUPCODE", ROM0[$150]
jp EntryPoint
ENDSECTION

DEF _last_section_stop = STARTOF("STARTUPCODE") + SIZEOF("STARTUPCODE")
ENDC