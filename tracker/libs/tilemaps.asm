DEF TILEBLOCK_SIZE = 4 ; load tiles 4 by 4
; do not call directly
; @param de: Source address
; @param hl: Destination address
; @param b: tile offset to apply (0-127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; @mutates hl will be mutated
; loads a tilemap but applies an offset to each tile value
; EXCEPT 0 (which remains 0)
___LoadTilemapWithPositiveOffset:
  xor a, a
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
ret

; do not call directly
; @param de: Source address
; @param hl: Destination address
; @param b: tile offset to apply (0-127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; @mutates de and hl will be mutated
; loads a tilemap but applies an offset to each tile value.
; EXCEPT 0 (which remains 0)
___LoadTilemapWithNegativeOffset:
  xor a, a
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
ret


; @param de: Source address to load from in ROM or elsewhere
; @param hl: Base address for rendering (usually $9800)
; @param b: tile offset to apply (in offset-127, so that the offset you want is b - 127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; loads a tilemap but applies an offset to each tile value (except 0)
__LoadTilemapWithOffset:
  ld a, b
  cp a, 127
  jr c, .negOffset ; if a < 127, then we have a negative offset to load
  sub a, 127
  ld b, a
  call ___LoadTilemapWithPositiveOffset
  jr .out
  .negOffset
    ; if 0 <= a <= 127, we just keep that value
  call  ___LoadTilemapWithNegativeOffset
  .out
ret

; @param de: Source address to load from in ROM or elsewhere
; @param hl: Base address for rendering (usually $9800)
; @param b: tile offset to apply (in offset-127, so that the offset you want is b - 127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; loads a tilemap but applies an offset to each tile value (except 0)
LoadScreenTilemap:
  push bc ; we'll restore it in the end
  ;; first store tilemap and offset to RAM
  ld a, d
  ld [wCurrentTilemap], a
  ld a, e
  ld [wCurrentTilemap+1], a
  ld a, b
  ld [wCurrentTilemapOffset], a
  call __LoadTilemapWithOffset
  pop bc
ret

; @param de: Source address to load from in ROM or elsewhere
; @param hl: Base address for rendering (usually $9800)
; @param b: tile offset to apply (in offset-127, so that the offset you want is b - 127)
; @param c: number of tile blocks to load (each tile block: 4 tiles)
; loads a tilemap but applies an offset to each tile value (except 0)
LoadWindowTilemap:
  push bc ; we'll restore it in the end
  ;; first store tilemap and offset to RAM
  ld a, d
  ld [wCurrentWindowTilemap], a
  ld a, e
  ld [wCurrentWindowTilemap+1], a
  ld a, b
  ld [wCurrentWindowTilemapOffset], a
  call __LoadTilemapWithOffset
eoload:
  pop bc
ret