IF !DEF(LOW_LEVEL_GBASM)
DEF LOW_LEVEL_GBASM EQU 0

IF (DEF(ENABLE_VBLANKINT) && ENABLE_VBLANKINT == 1)

SECTION "VBLANKINT", ROM0[$0040]
push af
push bc
push de
push hl
jp VBlankInterruptHandler

SECTION "STATINT", ROM0[$0048]
push af
jp StatInterruptHandler

SECTION FRAGMENT "PROGRAM", ROM0
StatInterruptHandler:
  ;; teehee, magic
  ldh a, [rLY]
  srl a
  and %10000
  ld a, DEFAULT_PALETTE
  jr z, .alt
  cpl
.alt
  ld [rBGP], a

.out
  pop af
reti  
VBlankInterruptHandler:
  ld hl, inVBlank
  ld [hl], 0xf0
  ldh a, [wFrameCounter]
  inc a
  ldh [wFrameCounter], a
  cp a, 0
  jp nz, .noCarry
  ldh a, [wTimeCounter]
  inc a
  ldh [wTimeCounter], a
.noCarry:
  ldh a, [wFrameCounter60]
  inc a
;; now handle seconds
  ldh [wFrameCounter60], a
  cp a, 60
  jp c, .noIncSec
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

  ; restore state
  pop hl
  pop de
  pop bc
  pop af
reti
ENDC ; enable VBlankInt

ENDC