INCLUDE "macros/macros.inc"
; this is a multiplier for all event durations, because by default it's quite fast.
; helps with converting conventional quarter notes.
DEF CONVERSION_RATIO = 1
AnnoyingE:
AnnoyingE_Bass:
    AU_CompactAdjustment %10, 10, 0, 5    
    PianoNoteShort E4, 4
    PianoRestShort 8
    PianoNoteShort B3, 4
    PianoRestShort 8
AnnoyingE_BassEnd:

AnnoyingE_Treble:
    AU_CompactAdjustment %11, 8, 0, 3
    PianoRestShort 4
    PianoNoteShort B4, 4
    PianoNoteShort B4, 4
    AU_CompactAdjustment %11, 7, 0, 3
    PianoRestShort 4
    PianoNoteShort B4, 4
    PianoNoteShort B4, 4
AnnoyingE_TrebleEnd:

AnnoyingC:
AnnoyingC_Bass:
    AU_CompactAdjustment %11, 10, 0, 1
    PianoNoteShort C4, 4
    PianoRestShort 8
    PianoNoteShort G3, 4
    PianoRestShort 8
    
AnnoyingC_BassEnd:


AnnoyingC_Treble:
    AU_CompactAdjustment %00, 0, 0, 0
    PianoRestShort 4
    AU_CompactAdjustment %00, 8, 0, 1
    PianoNoteShort G4, 4
    PianoNoteShort G4, 4
    
    AU_CompactAdjustment %00, 0, 0, 0
    PianoRestShort 4
    AU_CompactAdjustment %00, 7, 0, 1
    PianoNoteShort G4, 4
    PianoNoteShort G4, 4
    AU_CompactAdjustment %00, 8, 0, 1 ; restore initial synth setting
    

AnnoyingC_TrebleEnd:

