IF !DEF(INTERRUPTS_ASM)
DEF INTERRUPTS_ASM EQU 0

SECTION "VBLANKINT", ROM0[$0040]
push af
push bc
push de
push hl
jp VBlankInterruptHandler

SECTION "STATINT", ROM0[$0048]
push af
jp StatInterruptHandler
nop
nop

; SECTION "TIMERINT", ROM0[$0050]
; 
; ds $0058 - @, 0
; 
; SECTION "SERIALINT", ROM0[$0058]
; 
; ds SIZEOF("TIMERINT"), 0
; 
; SECTION "JOYPADINT", ROM0[$0060]
; 
; ds SIZEOF("TIMERINT"), 0

SECTION FRAGMENT "INTERRUPT_HANDLERS", ROM0
StatInterruptHandler::
  ;; teehee, magic
  jr .out
  ldh a, [rLY]
  srl a
  and %10000
  ld a, DEFAULT_PALETTE
  jr z, .alt
  cpl
.alt
  ld [rBGP], a

.out:
  pop af
reti  

VBlankInterruptHandler::
  ld hl, inVBlank
  ld [hl], 0xf0
  ldh a, [wFrameCounter]
  inc a
  ldh [wFrameCounter], a
  cp a, 0
  jr nz, .noCarry
  ldh a, [wTimeCounter]
  inc a
  ldh [wTimeCounter], a
.noCarry:
  ldh a, [wFrameCounter60]
  inc a
;; now handle seconds
  ldh [wFrameCounter60], a
  cp a, 60
  jr c, .noIncSec
  ;; a == 60
  ld a, 0
  ldh [wFrameCounter60], a
  ldh a, [wSecCounter]
  inc a
  ldh [wSecCounter], a
  jr .end
.noIncSec:
  inc a
  ldh [wFrameCounter60], a
.end:
  ld a, DEFAULT_PALETTE
  ld [rBGP], a
.out:
  ; restore state
  pop hl
  pop de
  pop bc
  pop af
reti

ENDC