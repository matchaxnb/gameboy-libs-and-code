IF !DEF(TABLES_GBASM)
DEF TABLES_GBASM EQU 0
SECTION "TEXT_TABLES", ROM0
/** This deserves an explanation

We encode our text tables as follows:

<N> [<C>...] [<N> [<C>...]]... <0>

N is the offset to the Next element in the table
C is the characters in the string in whatever
charmap we are using

<N> stores the offset to the next <N>

If <N> is 0, then the table is at its end.

We call that encoding pakstr

Hints:

    - You can set various labels at some points to mark subsections
    - 
**/
SETCHARMAP ascii
TextTables:
hello: db 6, "HELLO"
DEF MAX_SPEED_INGAME = 630
SpeedTextDB: 
    DEF _spd = 0.0
    DEF cnt = 0
REPT MAX_SPEED + 1
; SpeedTextDB.{d:cnt}
    DEF COMPUTED = floor((({_spd} / MAX_SPEED) * MAX_SPEED_INGAME))
    DEF COMPUTED = COMPUTED >> 16
    db STRLEN(STRFMT("{d:COMPUTED}")) + 1, STRFMT("{d:COMPUTED}")
    DEBUGP "Line is "
    DEBUGP "ADDRESS = "
    DEBUGP "\@, "
    DEBUGP "LENGTH = "
    DEBUGP STRLEN(STRFMT("{d:COMPUTED}_kph"))
    DEBUGP ", STRING = "
    DEBUGPLN STRFMT("{d:COMPUTED}_kph")
    ; 03484C45 for example
; SpeedTextDB.{d:cnt}end
    DEF cnt = cnt + 1
    DEF _spd = _spd + 1.0

ENDR
SpeedTextDBEnd:
db 0 ; text table terminator
PURGE _spd
PURGE cnt
ENDC

