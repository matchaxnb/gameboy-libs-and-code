IF !DEF(BOOTSTRAP_GBASM)
DEF BOOTSTRAP_GBASM EQU 0

SECTION "RESERVED", ROM0[$0]

ds $40 - @, 0

SECTION "HEADER", ROM0[$0100]
; that's where the actual ROM header starts, we just reserve until 0x150 for it
; of course we could do more, see the Pan doc for it
; https://gbdev.io/pandocs/The_Cartridge_Header

  jp EntryPoint
  ds $150 - @, $00 ; room for the nintendo logo

SECTION FRAGMENT "PROGRAM", ROM0
Libraries:
INCLUDE "libs/functions.asm"
EndLibraries:

SECTION "STARTUPCODE", ROM0[$150]

EntryPoint:
; Shut down audio circuitry
ld a, AUDENA_ON
ld [rAUDENA], a
; enable interrupts
IF (DEF(ENABLE_VBLANKINT) && ENABLE_VBLANKINT == 1)
; setup the timer
ld a, IEF_VBLANK | IEF_STAT
ldh [rIE], a
xor a
ldh [rIF], a
ld a, STATF_MODE00
ldh [rSTAT], a

ei ;; enable the interrupts, because we have defined a non-nop vector there
nop ;; in case
ELSE
  FAIL "We require VBLANKINT"
ENDC

; load a palette
ld a, DEFAULT_PALETTE
ld [rBGP], a



PrepareForVRAMWrite

;; reset RAM to 0
 ld hl, _RAM
 ld bc, GlobalVariablesEnd - GlobalVariables
 ld d, 0
 call InitMemChunkVBlankSafe
;
 ld hl, GameState
 ld bc, GameStateEnd - GameState
 ld d, 0
 call InitMemChunkVBlankSafe
 
 ; can't touch VRAM anything until we're in VBlank, so...



; start by clearing VRAM
 ld hl, _HRAM
 ld bc, lastEntry - FirstHRAMEntry
 ld d, 0
 call InitMemChunkVBlankSafe


ld hl, _OAMRAM
ld bc, OAM_COUNT * 4
call InitMemChunkVBlankSafe
; we may still have to wait





; copy tiles
; first, UI items


ld hl, TILES_LOCATION
ld de, UITiles
ld bc, UI_TILES_SIZE
call Memcopy

;; hl is auto-advanced by Memcopy
; then, musical elements
;
ld bc, MUSICAL_TILES_SIZE
ld de, MusicalTiles
call Memcopy

; then, sprites
ld bc, SPRITE_TILES_SIZE
ld de, SpritesROM
call Memcopy



ld hl, _SCRN1
ld d, 0
ld bc, 32*32
call InitMemChunkVBlankSafe

; ld c, (TrackerUIEnd - TrackerUI) / 4
ld b, GFX_TILES_OFFSET ; some tilemaps are built with an offset
;; importantly, use LoadTilemapWithOffset to ensure the current offset is stored
;; and can be
call LoadWindowTilemap

ld hl, _SCRN0
ld de, TrackerUI
ld c, (TrackerUIEnd - TrackerUI) / 4
ld b, GFX_TILES_OFFSET ; some tilemaps are built with an offset
;; importantly, use LoadTilemapWithOffset to ensure the current offset is stored
;; and can be
call LoadScreenTilemap

DEF DISPLAY_FLAGS = LCDCF_ON | LCDCF_BGON | LCDCF_WINON | LCDCF_BG8000 | LCDCF_WIN9C00
ld a, 7
ld [rWX], a
ld a, 144 - 8
ld [rWY], a
ld a, DISPLAY_FLAGS
ldh [rLCDC], a
; the gameloop will takeover from there

call LoadRemainingTilemaps

jp StartGame

LoadRemainingTilemaps:
  PrepareForVRAMWrite
  ld hl, CHARS_LOCATION
  ld bc, ASCII_TILES_SIZE
  ld de, AsciiTiles + ASCII_TILES_SKIPLOAD ; skip the first tile, which is blank
  call MemcopyVBlankSafe
  ld a, DISPLAY_FLAGS
  ldh [rLCDC], a
ret
ENDC