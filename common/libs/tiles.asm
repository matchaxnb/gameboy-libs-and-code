IF !DEF(LIBS_TILES_ASM)
DEF LIBS_TILES_ASM = 0
INCLUDE "macros/macros.inc"
SECTION FRAGMENT "PROGRAM", ROM0

; @param de: Source address
; @param hl: Destination address
; @param b: Number of tiles to copy (0-255) (1 tile = 16 bytes, in 2bpp format)
; @param c: tile offset (+-127) in 2's complement
; this is a register-only memcopy with offset, useful for loading
; 8x8 tiles (16 bytes each) with an offset in the source address
; like when loading a charset
CopyTilesWithOffset:
  ;; first, we compute the proper offset to load from
  ld a, c ; A <- C
  cp a, %10000000; test for negative number
  jr nc, .negOffset ; if C >= 128, treat it as negative 2cc number
  ; else we have a positive offset
; .posOffset:
  ; c is already loaded nicely
  call OffsetAddressBlockPos
  jr .nowLoad
.negOffset:
  ;; a little bit of two's complement here
  ; xor a, $ff ; invert bits in a
  cpl ; xor a, $ff
  inc a ; add 1 to get the absolute value for the offset
  ld c, a ; C <- A
  call OffsetAddressBlockNeg
.nowLoad:
  ;; at this point DE contains the source address we want
  ;; so we can just call Memcopy
  ;; after having prepared bc
  ;; currently b contains number of tiles to copy
  ;; we just need to multiply that by 16
  ;; it's a simple matter of x2, x2, x2, x2 (sla 4 times)
  ;; 
  ld a, b
  ld c, a
  ld b, 0

  SHIFT_REGPAIR b, c, 4
  ;; now bc contains the amount of data to load
  call Memcopy
  ret

  ; @param de Tile address to blank
  ; @param a Pattern to blank it with (will be repeated)
BlankTile:
  push de
  REPT 16
  ld [de], a
  inc de
  ENDR
  pop de
ret
; @param bc Tile 1 to merge
; @param hl Tile 2 to merge
; @param de Target memory address
; Merge together 2 tiles from ROM to RAM
; If you are targeting VRAM, you can do it
; only during VBlank but you'll get an addressable tile directly
MergeTiles:
  ;; merging is just OR-ing the 16 bytes, 1 pair at a time
  ;; estimated duration: 16 * (2 + 2 + 1 + 1 + 2 + 1) = 144 cycles
  ;; each pixel take 9 cycles
  REPT 16
  ld a, [bc]  ; costs 2
  or a, [hl] ; a now contains bc | hl ; costs 2
  ld [de], a ; costs 2
  inc hl ; costs 1
  inc bc ; costs 1
  inc de ; costs 1
  ENDR
ret
; @param a  Tile 1 by index to merge
; @param b  Tile 2 by index to merge
; @param d  Target tile ID (will be in VRAM)
; Merge together 2 tiles from ROM to RAM
; If you are targeting VRAM, you can do it
; only during VBlank but you'll get an addressable tile directly
MergeTilesByID:
  ;; merging is just OR-ing the 16 bytes, 1 pair at a time
  ld hl, 0
  cp a, 0
  jr z, .doneOffsetA
  ld hl, 16 ; size of a tile in bytes
  .offsetA
    add hl, hl
    dec a
    jr nz, .offsetA
  .doneOffsetA
  ld a, b ; A <- B
  ld bc, TILES_ROM_LOCATION
  add hl, bc ; now hl contains the address of the tile
  push hl ; store the computed address for tile 1 on stack
  ;; handle B now
  ld hl, 0
  cp a, 0
  jr z, .doneOffsetB
  ld hl, 16
  .offsetB
    add hl, hl
    dec a
    jr nz, .offsetB
  .doneOffsetB
  ld bc, TILES_ROM_LOCATION
  add hl, bc ; now hl contains the address of tile 2
  push hl ; push the second address on stack
  ;; handle D now
  ld a, d
  ld hl, 0
  cp a, 0
  jr z, .doneOffsetD
  ld hl, 16
  .offsetD
    add hl, hl
    dec a
    jr nz, .offsetD
  .doneOffsetD
  ld bc, TILES_LOCATION ; this is in VRAM
  add hl, bc ; now hl contains the destination address
  ldr16 de, hl ; <- de, hl
  pop hl
  pop bc
  WaitForVBlank
  jp MergeTiles ;; 
ret



LoadTileset:
  
  call Memcopy
ret

ENDC