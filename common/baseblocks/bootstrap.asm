IF !DEF(BASEBLOCKS_BOOTSTRAP_GBASM)
DEF BASEBLOCKS_BOOTSTRAP_GBASM EQU 0

INCLUDE "macros/macros.inc"
SECTION "BOOTSTRAPCODE", ROM0
EntryPoint::
; turn off the screen
DisableLCD
; Shut down audio circuitry
ld a, AUDENA_OFF
ld [rAUDENA], a

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


; clear HRAM (setting 0 everywhere)
ld d, 0
ld hl, _HRAM
ld bc, lastEntry - _HRAM
call InitMemChunk
;; reset conventional RAM to 0
 ld hl, GlobalVariables
 ld bc, GlobalVariablesEnd - GlobalVariables
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


; the gameloop will takeover from there

jp StartGame









ENDC