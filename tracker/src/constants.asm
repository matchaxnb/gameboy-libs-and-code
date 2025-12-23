IF !DEF(CONSTANTS_GBASM)
DEF CONSTANTS_GBASM EQU 0
;;; this defines a set of constants (load after assets are referenced)
;;; but before we do any init
;;; this must contain no code, just DEF and asserts

DEF TILES_LOCATION = _VRAM9000
DEF TILES_ROM_LOCATION = TilesROM
DEF TILEMAP_LOCATION = TILES_LOCATION + $0800
DEF GFX_TILES_LOCATION = TILES_LOCATION + FontDataEnd - FontData
DEF GFX_TILES_OFFSET = (FontDataEnd - FontData) / 16 - 1

PRINTLN "Tiles location: {TILES_LOCATION}; Tilemap location: {TILEMAP_LOCATION}; GFX tiles location: {GFX_TILES_LOCATION}; GFX tiles offset: {GFX_TILES_OFFSET}"
;;; Sanity checks
ASSERT GFX_TILES_OFFSET <= 255
ASSERT (EndTitleScreenTM - TitleScreenTM) / 4 <= 255
ENDC