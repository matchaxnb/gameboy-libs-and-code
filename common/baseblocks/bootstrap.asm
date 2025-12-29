IF !DEF(BASEBLOCKS_BOOTSTRAP_GBASM)
DEF BASEBLOCKS_BOOTSTRAP_GBASM EQU 0

INCLUDE "macros/macros.inc"
SECTION "BOOTSTRAPCODE", ROM0[_last_section_stop]
EntryPoint::
; turn off the screen
TurnOffInterrupts
DisableLCD


; clear HRAM (setting 0 everywhere)
ld d, 0
ld hl, firstHRAMEntry
ld bc, lastHighVariableEntry - firstHRAMEntry
call InitMemChunk
;; reset conventional RAM to 0
 ld hl, firstVariableEntry
 ld bc, lastVariableEntry - firstVariableEntry
 ld d, 0
 call InitMemChunk
;
; load a palette
ld a, DEFAULT_PALETTE
ld [rBGP], a

;; turn on the screen
ld a, 7
ld [rWX], a
ld a, 144 - 8
ld [rWY], a
ld a, DISPLAY_FLAGS
ldh [rLCDC], a


IF (USE_GAME_STATE)
ld hl, GameState
ld bc, GameStateEnd - GameState
ld d, 0
call InitMemChunk
ENDC

SetupInterrupts

PrepareForVRAMWrite
; now clean OAM RAM
ld hl, _OAMRAM
ld bc, 160
ld d, 0
call InitMemChunk

; let user hook into SetupTiles
jp SetupTiles
PostSetupTiles::

; let user hook into SetupTilemaps
jp SetupTilemaps
PostSetupTilemaps::


EnableLCD


; the gameloop will takeover from there, but first StartGame lets us perform final adjustments

jp StartGame

ENDSECTION
REDEF _last_section_stop = STARTOF("BOOTSTRAPCODE") + SIZEOF("BOOTSTRAPCODE")
ENDC