IF !DEF(MEMORY_MAP_GBASM)
DEF MEMORY_MAP_GBASM EQU 0
SECTION "VARIABLES", WRAM0[_RAM]
;; MSB[DOWN UP LEFT RIGHT START SELECT B A]LSB
GlobalVariables:
wLastUpdatedInput: db
wLastInputStrings: ds 16
wLastInputSPointer: db

wFunPointer: dw
wCurrentTilemap: dw
wCurrentTilemapOffset: db ; offset-127 value
wCurrentWindowTilemap: dw
wCurrentWindowTilemapOffset: db ; offset-127 value
GlobalVariablesEnd:

;; this defines the GameState structure
SECTION "GameState", WRAM0[GlobalVariablesEnd]

GameState:
    GameState.mode:: db ; room ID 1 byte
    GameState.trackAsText:: ds TRACKTITLES_MAX_LENGTH + 1; string for speed
    GameState.stateMachineState: db ; just an ID
GameStateEnd:

SECTION "TileSets", VRAM[$9000]


SECTION "HighVars", HRAM[$FF80]
FirstHRAMEntry:
IF (DEF(ENABLE_VBLANKINT) && ENABLE_VBLANKINT == 1)
inVBlank: db
ENDC
wCurKeys: db
wPrevKeys: db
wNewlyPressed: db
wNewlyReleased: db
;; time keeping
wTimeCounter: db
wFrameCounter: db
wFrameCounter60: db ; 0 <=  x <= 60
wSecCounter: db

;; music engine
AudioChannelFlags:
wMusicFlagsCH1: db
wMusicOffsetCH1: db
wMusicTimerCH1: db

wMusicFlagsCH2: db
wMusicOffsetCH2: db
wMusicTimerCH2: db


wMusicFlagsCH3: db
wMusicOffsetCH3: db
wMusicTimerCH3: db


wMusicFlagsCH4: db
wMusicOffsetCH4: db
wMusicTimerCH4: db

AudioChannelFlagsEnd:
wAudioMasterClock: db
wOverallOffsetPitch: db
wMusicTrack: db ; top bit is the "changed" flag, the rest is the track num
lastEntry: db
ENDC