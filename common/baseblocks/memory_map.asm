IF !DEF(MEMORY_MAP_GBASM)
DEF MEMORY_MAP_GBASM = 0
SECTION FRAGMENT "VARIABLES", WRAM0
firstVariableEntry::
GlobalVariables::
    wCurrentTilemap:: dw
    wCurrentTilemapOffset:: db ; offset-127 value
    wCurrentWindowTilemap:: dw
    wCurrentWindowTilemapOffset:: db ; offset-127 value
GlobalVariablesEnd::

;; this is the zone where we store a number of tiles to load later into VRAM
;; VRAM (8 KiB) is made of the following:
;; 6 KiB for tiles (384 tiles max, but only addressable at a time)
;; 2 tilemaps of 1KiB each (on top)


;; this is a queue to load tiles
;; 
;; TileLoadQueue:
;; REPT 32
;;     TileLoadEntry
;; ENDR
;; this defines the GameState structure
ENDSECTION

SECTION FRAGMENT "HighVars", HRAM
firstHRAMEntry::
ENDSECTION

SECTION "TileSets", VRAM[_VRAM]
firstTilesetEntry::
ENDSECTION


ENDC