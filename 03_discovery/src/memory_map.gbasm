IF !DEF(MEMORY_MAP_GBASM)
DEF MEMORY_MAP_GBASM EQU 0
SECTION "VARIABLES", WRAM0[$c000]
;; MSB[DOWN UP LEFT RIGHT START SELECT B A]LSB
GlobalVariables:
wLastUpdatedInput: db
wLastInputStrings: ds 16
wLastInputSPointer: db

wFunPointer: dw
GlobalVariablesEnd:

;; this defines the GameState structure
SECTION "GameState", WRAM0[GlobalVariablesEnd]

GameState:
    GameState.room:: db ; room ID 1 byte
UNION  ; 2 bytes
    GameState.velocity:: ds 1 ; 
    GameState.angle:: ds 1 ;
NEXTU
    GameState.movement:: ds 2 ; vector<H,V>
ENDU
    GameState.speedAsText:: ds 8 ; string for speed
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