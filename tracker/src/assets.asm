IF !DEF(ASSETS_GBASM)
DEF ASSETS_GBASM EQU 0
;;; this loads the binary data / assets into the ROM
SECTION "GraphicsData", ROM0[$2000], ALIGN[8]
TilesROM:
;; uitiles include already a blank tile
UITiles:
INCBIN "assets/tiles/ui-base-tilemap.2bpp"
UITilesEnd:
TilesROMEnd:
MusicalTiles:
INCBIN "assets/tiles/musical-elements.2bpp"
MusicalTilesEnd:
SpritesROM:
INCBIN "assets/tiles/sprites-tracker.2bpp"
SpritesROMEnd:
AsciiTiles:
INCBIN "assets/tiles/ascii-basic.2bpp"
AsciiTilesEnd:
TileMaps:
TrackerUI:
INCLUDE "assets/screens/tracker-ui.asm"
TrackerUIEnd:
TileMapsEnd:
ENDC