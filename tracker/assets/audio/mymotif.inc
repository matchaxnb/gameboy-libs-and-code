INCLUDE "macros/macros.inc"
DEF CONVERSION_RATIO = 1
MyMotif:
MyMotif_Bass:
    
    REPT 4
        AU_CompactAdjustment %10, 13, 0, 4
        PianoNoteShort D3, 4
        PianoNoteShort F3, 4
        PianoNoteShort A3, 4
        AU_CompactAdjustment %10, 13, 0, 1
        PianoNoteShort G3, 4
        PianoNoteShort E3, 4
    ENDR
    PianoRestShort 2
    AU_CompactAdjustment %10, 13, 0, 3


MyMotif_BassEnd:

MyMotif_Treble:
    
    REPT 4
        AU_CompactAdjustment %00, 8, 0, 2
        PianoNoteShort D4, 4
        PianoNoteShort F4, 4
        PianoNoteShort A4, 4
        AU_CompactAdjustment %00, 8, 0, 4
        PianoNoteShort E4, 4
        PianoNoteShort G4, 4
    ENDR
    PianoRestShort 1

MyMotif_TrebleEnd:


; === BWV 846 in C major — Treble (first 4 measures, packed) ===
; duty=%01, trigger=1, length_enable=0, env_down, env_speed=BWV846_ENVSPD


