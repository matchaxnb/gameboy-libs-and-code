DEF TILEBLOCK_SIZE = 4 ; load tiles 4 by 4
; @param de: Source address
; @param hl: Destination address
; @param b: tile offset to apply (0-127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; @mutates hl will be mutated
; loads a tilemap but applies an offset to each tile value
; EXCEPT 0 (which remains 0)
LoadTilemapWithPositiveOffset:
  push bc ; we will restore that part of the context in the end
  ;; sanity check
  xor a
  or c
  jr z, .endLt
.loadLoop
  REPT TILEBLOCK_SIZE
  ld a, [de]
  cp 0
  jr z, .ldr\@
  add a, b
.ldr\@:
  ld [hli], a
  inc de
  ENDR
  dec c
  ld a, c
  cp a, 0
  jr nz, .loadLoop
.endLt
  pop bc ; context restored
ret

; @param de: Source address
; @param hl: Destination address
; @param b: tile offset to apply (0-127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; @mutates de and hl will be mutated
; loads a tilemap but applies an offset to each tile value.
; EXCEPT 0 (which remains 0)
LoadTilemapWithNegativeOffset:
  push bc ; we will restore that part of the context in the end
  ; sanity check
  xor a
  or c
  jr z, .endLt
.loadLoop
  REPT TILEBLOCK_SIZE
  ld a, [de]
  cp 0
  jr z, .ldr\@
  sub a, b  
.ldr\@:  
  ld [hli], a
  inc de
  ENDR
  dec c
  ld a, c
  cp a, 0
  jr nz, .loadLoop
.endLt
  pop bc ; context restored
ret


; @param de: Source address to load from in ROM or elsewhere
; @param hl: Base address for rendering (usually $9800)
; @param b: tile offset to apply (in 2's complement)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; loads a tilemap but applies an offset to each tile value.
; a tilemap is 
LoadTilemapWithOffset:
  push bc ; we'll restore it in the end
  ld b, a
  cp a, %10000000
  jr nc, .negOffset
  ; .posOffset
  call LoadTilemapWithNegativeOffset
  jr .eof
.negOffset:
  ; xor a, $ff
  cpl
  inc a
  ld c, a
  call LoadTilemapWithNegativeOffset
.eof:
  pop bc
ret
