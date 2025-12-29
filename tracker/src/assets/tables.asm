IF !DEF(TABLES_GBASM)
DEF TABLES_GBASM EQU 0
INCLUDE "data/charmap.inc"
INCLUDE "macros/macros.inc"
SECTION "TEXT_TABLES", ROM0

SETCHARMAP ascii
TextTables::
EncodeText "Hello", 12
TrackNamesTable::
EncodeText "My motif", TRACKTITLES_MAX_LENGTH
EncodeText "Bach's Prelude", TRACKTITLES_MAX_LENGTH
EncodeText "C up down", TRACKTITLES_MAX_LENGTH
db 0 ; text table terminator
TrackNamesTableEnd::
ENDC