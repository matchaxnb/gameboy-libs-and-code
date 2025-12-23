IF !DEF(ASSETS_GBASM)
DEF ASSETS_GBASM EQU 0
;;; this loads the binary data / assets into the ROM
SECTION "GraphicsData", ROM0[$2000], ALIGN[8]
TilesROM:
FontData:
  INCBIN "assets/tiles/ascii-basic.2bpp"
FontDataEnd:
TileData:
  INCBIN "assets/tiles/gameelems.2bpp"
TileDataEnd:
TilesROMEnd:
TileMaps:
INCLUDE "assets/screens/titlescreen.asm"
TileMapsEnd:
ENDC