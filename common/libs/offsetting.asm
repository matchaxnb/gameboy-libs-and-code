IF !DEF(LIBS_OFFSETTING_ASM)
DEF LIBS_OFFSETTING_ASM = 0
INCLUDE "macros/macros.inc"
SECTION FRAGMENT "PROGRAM", ROM0

; @param de: address to offset
; @param c: number of 16-bytes blocks to offset to. must be positive
; mutates:
;   - de so that in the end de has become de + 16 * c
OffsetAddressBlockPos::
  push hl; we're going to use arithmetic on HL
  ; push bc; we're going to keep bc intact
  ldr16 hl, de ; HL <- base address wanted
  ld de, 16  ; 1 block
  ld a, c ; A <- C
.loopMul:
  add hl, de ; add 1-block offset to hl
  dec a ; decrement register a
  cp a, 0 ; compare to 0
  jp nz, .loopMul ; do that until we're done
  ; we're now done offsetting
; .eof
  LD_DE_HL ; copy offset-ed address to de
  ; pop bc; restore pushed bc
  pop hl ; restore pushed hl
  ; our job here is done
  ret

; @param de: address to offset
; @param c: number of 16-bytes blocks to rewind to. must be positive
; mutates:
;   - de so that in the end de has become de - 16 * c
; rant: there is no subtractive 16 bit arith in GBZ80 so we go dirty
OffsetAddressBlockNeg::
  push bc ; we'll keep bc intact
.loopw:
  ld a, e
  cp a, 17
  jp c, .complex
  ; simple case where e >= 16, just subtract 16
  sub a, 16
  ld e, a 
  jp .loopend
.complex:
  ; e is < 16, so:
  ; e <- 0xff - e
  ld a, 0xff
  sub e
  ld e, a ; e is now its complement
  dec d
  ; decrease d
  ; jp .loopend is useless
.loopend
  ; test if we've done the wanted number of iterations
  ld a, c
  cp a, 0
  jp nz, .loopw
; end of work, restore context
  pop bc  ; restore pushed register
  ret

ENDC