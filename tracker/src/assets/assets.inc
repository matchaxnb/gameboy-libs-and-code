IF !DEF(ASSETS_ASM)
DEF ASSETS_ASM EQU 0
INCLUDE "macros/macros.inc"
;;; this loads the binary data / assets into the ROM
SECTION "GRAPHICS_DATA", ROM0[_last_section_stop]
    TilesROM::
    ;; uitiles include already a blank tile
    UITiles::
    INCBIN "assets/tiles/ui-base-tilemap.2bpp"
    UITilesEnd::
    TilesROMEnd::
    MusicalTiles::
    INCBIN "assets/tiles/musical-elements.2bpp"
    MusicalTilesEnd::
    SpritesROM::
    INCBIN "assets/tiles/sprites-tracker.2bpp"
    SpritesROMEnd::
    AsciiTiles::
    INCBIN "assets/tiles/ascii-basic.2bpp"
    AsciiTilesEnd::
    TileMaps::
    TrackerUI::
    INCLUDE "assets/screens/tracker-ui.inc"
    TrackerUIEnd::
    TileMapsEnd::
    
ENDSECTION

REDEF _last_section_stop = STARTOF("GRAPHICS_DATA") + SIZEOF("GRAPHICS_DATA")
    ;;; this defines a set of constants (load after assets are referenced)
;;; but before we do any init
;;; this must contain no code, just DEF and asserts


EXPORT DEF TILES_ROM_LOCATION = TilesROM

;; layout: UI tiles, then Musical tiles, then the rest
EXPORT DEF ASCII_TILES_SKIPLOAD = 16
EXPORT DEF MUSICAL_TILES_SKIPEND = 16
ZoneLength UITiles, UI_TILES_SIZE, 0
ZoneLength MusicalTiles, MUSICAL_TILES_SIZE, MUSICAL_TILES_SKIPEND
ZoneLength SpritesROM, SPRITE_TILES_SIZE, 0
ZoneLength AsciiTiles, ASCII_TILES_SIZE, ASCII_TILES_SKIPLOAD
ZoneLength TrackerUI, TRACKER_UI_TILEMAP_SIZE, 0

EXPORT DEF UI_TILES_COUNT = UI_TILES_SIZE / 16
EXPORT DEF MUSICAL_TILES_COUNT = MUSICAL_TILES_SIZE / 16
EXPORT DEF SPRITE_TILES_COUNT = SPRITE_TILES_SIZE / 16
EXPORT DEF ASCII_TILES_COUNT = ASCII_TILES_SIZE / 16

EXPORT DEF UI_TILES_OFFSET = 0 ; because it's the first thing we load
EXPORT DEF MUSICAL_TILES_OFFSET = UI_TILES_OFFSET + UI_TILES_COUNT
EXPORT DEF SPRITE_TILES_OFFSET = MUSICAL_TILES_OFFSET + MUSICAL_TILES_COUNT


EXPORT DEF LAST_TILE_OFFSET = MUSICAL_TILES_OFFSET + MUSICAL_TILES_COUNT

EXPORT DEF GFX_TILES_OFFSET = UI_TILES_OFFSET


PRINTLN "Tiles location: {TILES_LOCATION}; Tilemap location: {TILEMAP_LOCATION}"
PRINTLN "# of ui tiles: {UI_TILES_COUNT}, of musical tiles: {MUSICAL_TILES_COUNT}"
;;; Sanity checks

ASSERT LAST_TILE_OFFSET <= 255
ASSERT (TRACKER_UI_TILEMAP_SIZE) / 4 <= 255
ENDC