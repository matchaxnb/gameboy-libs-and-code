IF !DEF(MACROS_GENERAL_MACROS_ASM)
DEF MACROS_GENERAL_MACROS_ASM EQU 0
;;; memory map
DEF MCOFFSET_RETADDR EQU 0xC000 ; to 0xC001, relative 
DEF MCOFFSET_OFFSET EQU 0xC002 ; single byte
DEF ENABLE_VBLANKINT EQU 1      ; use VBlank interrupt
DEF PRINT_DEBUG EQU 0

ASSERT (PRINT_DEBUG == 0 || PRINT_DEBUG == 1)
MACRO DEBUGP
  if (PRINT_DEBUG == 1)
    PRINT \1
  endc
ENDM

MACRO DEBUGPLN
  if (PRINT_DEBUG == 1)
    PRINTLN \1
  endc
ENDM

; @param r16 register to swap
; @param r16 register to swap
; costs 8 + 6 = 14 cycles
MACRO SWAP_REGISTERS
  CHECK_R16PAIR \1, \2
  push \1
  push \2
  pop \1
  pop \2
ENDM


MACRO swapreg
  SWAP_REGISTERS \1, \2
ENDM
; @param r8 a register to convert to two's complement
MACRO TWOS_COMPLEMENT
  ld a, \1
  ; xor a, $ff
  cpl
  inc a
  ld \1, a
ENDM

MACRO MTwosComp
  DEF \2 = (~\1 + 1)
ENDM

MTwosComp -1, MinusOneTwosComp

MACRO MOffsetSgn
  DEF \2 = \1 + 127
ENDM
MOffsetSgn -1, MinusOneOffsetSgn

; @arg \1 What to prepend to that computation
; @arg \2 base tileset addr
; @arg \3 number of tiles to skip

MACRO TILE_SKIP
  DEBUGPLN "[TILE_SKIP] Generating: \1, ( \2 ) + (( \3 ) * 16)"
  \1, ( \2 ) + (( \3 ) * 16)
ENDM

; @arg \1 left-side register (will be set to 0)
; @arg \2 right-side register
; @arg \3 shift count
; use this to shift-left a pair of registers (\1\2 << \3)
MACRO SHIFT_REGPAIR 
  ld \1, 0
  REPT \3
  sla \2 ; shift left the right-side register  
  jr c, .handleCarry\@
  sla \1 ; shift left-side register (we'll ignore carry)
  jp .next\@
.handleCarry\@
  sla \1 ; shift left-side
  inc \1 ; increment it too to set its last bit
.next\@:
  ENDR
ENDM

; @arg \1 left-side register
; @arg \2 right-side register
; @arg \3 shift count
; use this to shift-right a pair of registers (\1\2 >> \3)
MACRO SHIFT_RIGHT_REGPAIR 
  REPT \3
  sra \1 ; shift right the left-side register  
  jr c, .handleCarry\@
  ;; no carry, so just shift-right
  sra \2 ; shift right the right-side register
  jp .next\@
.handleCarry\@
  sra \2 ; shift right-side register
  set 7, \2 ; set top-bit to 1
.next\@:
  ENDR
ENDM


MACRO DEFMIN
  IF \2 > \3
    DEBUGPLN "Defining (\1) to be (\3)"
    DEF \1 = ( \3 )
  ELSE
    DEBUGPLN "Defining (\1) to be (\2)"
    DEF \1 = ( \2 )
  ENDC
ENDM

MACRO DEFMAX
  IF \2 > \3
    DEBUGPLN "Defining (\1) to be (\2)"
    DEF \1 = ( \2 )
  ELSE
    DEBUGPLN "Defining \1 to be (\3)"
    DEF \1 = ( \3 )
  ENDC
ENDM

MACRO TWOS_COMPLEMENT_CONST
  STATIC_ASSERT \1 >= 0
  STATIC_ASSERT \1 <= 255
  (\1 ^ $ff) + 1
ENDM

MACRO CHECK_R16PAIR_NOAF
  ASSERT (STRCMP("\1", "hl") == 0 || STRCMP("\1", "bc") == 0 || STRCMP("\1", "de") == 0)
  ASSERT STRCMP("\1", "\2") != 0
  ASSERT (STRCMP("\2", "hl") == 0 || STRCMP("\2", "bc") == 0 || STRCMP("\2", "de") == 0)
ENDM

MACRO CHECK_R16PAIR_NOAFDST
  ASSERT (STRCMP("\1", "hl") == 0 || STRCMP("\1", "bc") == 0 || STRCMP("\1", "de") == 0)
  ASSERT STRCMP("\1", "\2") != 0
  ASSERT (STRCMP("\2", "hl") == 0 || STRCMP("\2", "bc") == 0 || STRCMP("\2", "de") == 0  || STRCMP("\2", "af") == 0)
ENDM

MACRO CHECK_R16PAIR
  ASSERT (STRCMP("\1", "hl") == 0 || STRCMP("\1", "bc") == 0 || STRCMP("\1", "de") == 0 || STRCMP("\1", "af") == 0)
  ASSERT STRCMP("\1", "\2") != 0
  ASSERT (STRCMP("\2", "hl") == 0 || STRCMP("\2", "bc") == 0 || STRCMP("\2", "de") == 0 || STRCMP("\2", "af") == 0)
ENDM

MACRO CHECK_R16_NOAF
  ASSERT (STRCMP("\1", "hl") == 0 || STRCMP("\1", "bc") == 0 || STRCMP("\1", "de") == 0)
ENDM

MACRO ldr16
  CHECK_R16PAIR_NOAFDST \1, \2
  if ( STRCMP("\1", "hl") == 0 )
    ldhl \2
  elif ( STRCMP("\1", "bc") == 0 )
    ldbc \2
  elif ( STRCMP("\1", "de") == 0 )
    ldde \2
  else
    FAIL "Improper use of ldr16"
  endc
ENDM

MACRO ldaTo
 CHECK_R16_NOAF \1
 if ( STRCMP("\1", "hl") == 0)
   ld l, a
   ld h, 0
 elif ( STRCMP("\1", "bc") == 0 ) 
   ld c, a
   ld b, 0
 elif ( STRCMP("\1", "de") == 0 )
   ld e, a
   ld d, 0
 else 
   FAIL "Improper use of ldaTo"
 endc
ENDM

MACRO ldaf
ASSERT ( STRCMP("\1", "bc") == 0 || STRCMP("\1", "de") == 0 || STRCMP("\1", "hl") == 0 )
if ( STRCMP("\1", "bc") == 0 )
  ld h, b
  ld l, c
elif (STRCMP("\1", "de") == 0)
  ld h, d
  ld l, e
else
  ld h, a
  ld l, f
endc
ENDM
MACRO ldhl 
ASSERT ( STRCMP("\1", "bc") == 0 || STRCMP("\1", "de") == 0 )
if ( STRCMP("\1", "bc") == 0 )
  ld h, b
  ld l, c
else
  ld h, d
  ld l, e
endc
ENDM

MACRO ldbc
ASSERT ( STRCMP("\1", "hl") == 0 || STRCMP("\1", "de") == 0)
if ( STRCMP("\1", "hl") == 0)
  ld b, h
  ld c, l
else
  ld b, d
  ld c, e
endc
ENDM

MACRO ldde
ASSERT ( STRCMP("\1", "hl") == 0 || STRCMP("\1", "bc") == 0 || STRCMP("\1", "af") == 0)
if ( STRCMP("\1", "hl") == 0)
  ld d, h
  ld e, l
elif ( STRCMP("\1", "bc") == 0)
  ld d, b
  ld e, c
else
  ld d, a
  ld e, 0
endc
ENDM

MACRO LD_HL_DE
  ld h, d
  ld l, e
ENDM

MACRO LD_DE_HL
  ld d, h
  ld e, l
ENDM


; wait for VBlank

; wait for VBlank and jump to label specified as first arg
; @param \1 (optional) label to jump to once we're done
MACRO WAIT_VBL_JP
  WAIT_VBL
  jp \1
ENDM
; @param \1 X position
; @param \2 Y position
; @param \3 tile ID to set
; @param \4 VRAM base addr
; return it in a
; mutates a, but does not set flags
MACRO VIEWPORT_TILE_ADDR
  ld a, \3
  DEF _tr = (\4) + (\2 * 32) + (\1)
  DEBUGPLN "At some point, will set tile \3 to address {_tr}"
  ld [_tr], a
  PURGE _tr
ENDM

; requires register c to be set as active input
; @param \1 "U|D|L|R|A|B|S|T"
; (i.e. up down left right a b start select)
; @param \2 jump condition (z or nz)
; @param \3 label to jump to
MACRO IS_BUTTON_STATUS
ASSERT ( "\2" === "z" || "\2" === "nz")
ASSERT STRLEN("\3") > 0
  ld a, c
  IF   ( "\1" === "D")
  and a, %10000000
  ELIF ( "\1" === "U")
  and a, %01000000
  ELIF ( "\1" === "L")
  and a, %00100000
  ELIF ( "\1" === "R")
  and a, %00010000
  ELIF ( "\1" === "S")
  and a, %00001000
  ELIF ( "\1" === "T")
  and a, %00000100
  ELIF ( "\1" === "B")
  and a, %00000010
  ELIF ( "\1" === "A")
  and a, %00000001
  ELSE
  FAIL ("IS_BUTTON_SET employed incorrectly")
  ENDC
  jp \2, \3
ENDM

; requires register c to be set as active input
; @param \1 "U|D|L|R|A|B|S|T"
; (i.e. up down left right a b start select)
; @param \2 jump condition (z or nz)
; @param \3 label to jump to
; @param \4 label to jump to otherwise
MACRO IS_BUTTON_STATUS_DUAL
ASSERT ( "\2" === "z" || "\2" === "nz")
ASSERT STRLEN("\3") > 0
  ld a, c
  IF   ( "\1" === "D")
  and a, %10000000
  ELIF ( "\1" === "U")
  and a, %01000000
  ELIF ( "\1" === "L")
  and a, %00100000
  ELIF ( "\1" === "R")
  and a, %00010000
  ELIF ( "\1" === "S")
  and a, %00001000
  ELIF ( "\1" === "T")
  and a, %00000100
  ELIF ( "\1" === "B")
  and a, %00000010
  ELIF ( "\1" === "A")
  and a, %00000001
  ELSE
  FAIL ("IS_BUTTON_SET employed incorrectly")
  ENDC
  jp \2, \3
  jp \4
ENDM

; requires register c to be set as active input
; @param \1 "U|D|L|R|A|B|S|T|UD|LR"
; (i.e. up down left right a b start select)
; @param \2 function to call once cmp is done
MACRO CallActiveInputHandlers
ASSERT STRLEN("\2") > 0
  ld a, c
  IF   ( 1 == 2)
  nop 
  ELIF ( "\1" === "UD" )
  and a, %11000000
  ELIF ( "\1" === "LR" )
  and a, %00110000
  ELIF ( "\1" === "D")
  and a, %10000000
  ELIF ( "\1" === "U")
  and a, %01000000
  ELIF ( "\1" === "L")
  and a, %00100000
  ELIF ( "\1" === "R")
  and a, %00010000
  ELIF ( "\1" === "S")
  and a, %00001000
  ELIF ( "\1" === "T")
  and a, %00000100
  ELIF ( "\1" === "B")
  and a, %00000010
  ELIF ( "\1" === "A")
  and a, %00000001
  ELSE
  FAIL ("IS_BUTTON_SET employed incorrectly")
  ENDC
  call \2
ENDM


MACRO IS_BUTTON_SET
  IS_BUTTON_STATUS \1, nz, \2
ENDM

MACRO IS_BUTTON_UNSET
  IS_BUTTON_STATUS \1, z, \2
ENDM

MACRO IS_BUTTON_SET_UNSET
  DEBUGPLN "For button \1, will jump to \2 if set and \3 if not"
  IS_BUTTON_STATUS_DUAL \1, nz, \2, \3
ENDM

; mutates a
IF (USE_VBLANK_INTERRUPT)
; mutates VBlank
MACRO WaitForVBlank
push hl
ld hl, inVBlank
xor a
cp a, [hl]
jr z, .waitVbl\@ ; if we're not in vblank, enter the loop
; otherwise ack the vblank flag and jump out
ld [hl], a
jr .out\@
.waitVbl\@:
  halt
  nop
  cp a, [hl]
  jr z, .waitVbl\@
  ld [hl], a
.out\@:
pop hl
ENDM

MACRO WaitForVBlank_mutateshl
ld hl, inVBlank
xor a
cp a, [hl]
jr z, .waitVbl\@ ; if we're not in vblank, enter the loop
; otherwise ack the vblank flag and jump out
ld [hl], a
jr .out\@
.waitVbl\@:
  halt
  nop
  cp a, [hl]
  jr z, .waitVbl\@
  ld [hl], a
.out\@:
ENDM


MACRO WaitForNonVBlank
push hl
ld hl, inVBlank
xor a
.waitNVbl\@
  ;halt
  nop
  cp a, [hl]
  jr nz, .waitNVbl\@
pop hl
ENDM


ELSE
FAIL "We do not support running without VBlank interrupt"
;MACRO WaitForVBlank
;.vbl\@: ld a, [rLY]
;        cp SCRN_Y
;        jr c, .vbl\@
;ENDM
;MACRO WaitForNonVBlank
;.nvbl\@: ld a, [rLY]
;        cp SCRN_Y
;        jr nc, .nvbl\@
;ENDM
;
ENDC


MACRO WAIT_VBL
WaitForVBlank
ENDM

MACRO WAIT_NVBL
WaitForNonVBlank
ENDM


MACRO DisableLCD
xor a
ld [rLCDC], a
ENDM

MACRO PrepareForVRAMWrite
.PrepareForVRAMWrite\@::
WaitForVBlank
DisableLCD
ENDM

MACRO EnableLCD
ld a, DISPLAY_FLAGS
ldh [rLCDC], a
ENDM

; this waits for write access to VRAM
; careful, you only have 228 cycles then
; mutates hl
MACRO WaitAccessVRAM
  ld hl, rSTAT
.wait\@: bit 1, [hl]
  jr nz, .wait\@ 
ENDM

MACRO CHARVALOFFSET
  IF (STRCMP("\2", " ") >= 0 && STRCMP("\2", "~") <= 0)
    DEF \1 = CHARVAL(\2) ; - 0x20
  ELSE
    FAIL("Unsupported character \2 for \1")
  ENDC
ENDM

; @param \1 Function label
; @param \2 Memory location
; mutates a
MACRO StoreFunctionPointer 
  .storeFunctionPointer_\@_\1:
    ld a, HIGH(\1)
    ld [\2], a
    ld a, LOW(\1)
    ld [\2 + 1], a
ENDM

; @param \1 Memory location
; call the function pointer
MACRO CallFunctionPointer
  .callFunctionPointer_\@_\1:
    ld bc, .postFP\@
    push bc
    ld a, [\1]
    ld h, a
    ld a, [\1 +1]
    ld l, a
    jp hl
    .postFP\@:
ENDM

; @param \1 a label
; @param \2 a def name
; @param \3 a value to remove, useful when you want to ignore part of a file
; if there's a label \1End, then DEF \2 = \1End - \1
MACRO ZoneLength
  ;ASSERT \1
  ;ASSERT \1End
  ASSERT STRLEN("\2") > 0
  EXPORT DEF \2 EQU (\1End - \1)
ENDM

; @param \1 a label
; @param \2 a def name
; @param \3 a value to remove, useful when you want to ignore part of a file
; if there's a label \1End, then DEF \2 = \1End - \1
MACRO ZoneLengthVar
  ;ASSERT \1
  ;ASSERT \1End
  ASSERT STRLEN("\2") > 0
  DEF \2 = (\1End - \1)
ENDM
/**
We encode our text tables as follows:

<N> [<C>...] [<N> [<C>...]]... <0>

N is the offset to the Next element in the table
C is the characters in the string in whatever
charmap we are using

<N> stores the offset to the next <N>

If <N> is 0, then the table is at its end.

Hints:
    - You can set various labels at some points to mark subsections

  
If you call this macro before setting a CHARMAP, unexpected results.
*/
; @param \1 a text to encode
; @param \2 maximum acceptable length (max 254)
; encodes text in the format described in the comment above
MACRO EncodeText
  ASSERT \2 < $ff
  ASSERT STRLEN(\1) <= \2
.textEntry\@:
  db STRLEN(\1) + 1, \1
ENDM

; a naive WaitForVBlank for startup situations
MACRO DumbWaitForVBlank
.vbl\@: ld a, [rLY]
        cp SCRN_Y
        jr c, .vbl\@
ENDM

MACRO DumbWaitForNonVBlank
.vbl\@: ld a, [rLY]
        cp SCRN_Y
        jr nc, .vbl\@
ENDM

DEF _TLECalls=0
MACRO TileLoadEntry
  DEF _TLECalls=_TLECalls+1
  vramAddress{_TLECalls}: dw
  tileID{_TLECalls}: db
  tileFlags{_TLECalls}: db
ENDM

MACRO TurnOffInterrupts
xor a
ldh [rIE], a
ldh [rIF], a
ldh [rSTAT], a
ENDM
MACRO SetupInterrupts
DEF _interrupt_mask = 0
DEF _stat_mode = 0
IF (USE_VBLANK_INTERRUPT) 
  DEF _interrupt_mask = _interrupt_mask | IEF_VBLANK
ENDC
IF (USE_STAT_INTERRUPT) 
  DEF _interrupt_mask = _interrupt_mask | IEF_STAT
  DEF _stat_mode = STATF_MODE00
ENDC

; setup registers for VBlank and STAT-MODE00 interrupts
ld a, _interrupt_mask
ldh [rIE], a
xor a
ldh [rIF], a
ld a, _stat_mode
ldh [rSTAT], a

;; enable interrupts
ei
nop 

ENDM

ENDC