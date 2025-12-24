

;; DiatonicC:
;; DiatonicC_Bass:
;; 
;; 
;; AU_DataPacked %10, 12, PERIOD_C2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_D2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_E2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_F2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_G2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_A2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_B2, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %10, 12, PERIOD_C3, 1, 0, 10, 0, 4, $01  ; q.
;;     
;; 
;; DiatonicC_BassEnd:
;; 
;; 
;; ; === BWV 846 in C major — Treble (first 4 measures, packed) ===
;; ; duty=%01, trigger=1, length_enable=0, env_down, env_speed=BWV846_ENVSPD
;; 
;; DiatonicC_Treble:
;; AU_DataPacked %11, 12, PERIOD_C4, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_B3, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_A3, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_G3, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_F3, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_E3, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_D3, 1, 0, 10, 0, 4, $01  ; q.
;; AU_DataPacked %11, 12, PERIOD_C3, 1, 0, 10, 0, 4, $01  ; q.
;;     
;; 
;; DiatonicC_TrebleEnd:
;; 
;; DiatonicCAlt_Bass:
;; 
;; DiatonicCAlt_BassEnd:

DiatonicC:
DiatonicC_Bass:
    AU_CompactAdjustment %10, 13, 0, 4
        PianoNoteShort C3, 4
        PianoNoteShort D3, 4
        PianoNoteShort E3, 4
        PianoNoteShort F3, 4
        PianoNoteShort G3, 4
        PianoNoteShort A3, 4
        PianoNoteShort B3, 4
        PianoNoteShort C4, 4

DiatonicC_BassEnd:

DiatonicC_Treble:
    AU_CompactAdjustment %00, 8, 0, 2
        PianoNoteShort C5, 4
        PianoNoteShort B4, 4
        PianoNoteShort A4, 4
        PianoNoteShort G4, 4
        PianoNoteShort F4, 4
        PianoNoteShort E4, 4
        PianoNoteShort D4, 4
        PianoNoteShort C4, 4
    PianoRestShort 1
DiatonicC_TrebleEnd:
