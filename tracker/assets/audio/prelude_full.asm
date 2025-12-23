IF DEF(PIANO_DUTY_CYCLE)
PURGE PIANO_DUTY_CYCLE
ENDC

IF DEF(PIANO_INITIAL_VOL)
PURGE PIANO_INITIAL_VOL
ENDC

IF DEF(CONVERSION_RATIO)
PURGE CONVERSION_RATIO
ENDC

IF DEF(PIANO_ENVSPD)
PURGE PIANO_ENVSPD
ENDC

;; parameters for bass
DEF PIANO_DUTY_CYCLE = %10
DEF PIANO_INITIAL_VOL = 12
DEF CONVERSION_RATIO = 3
DEF PIANO_ENVSPD = 7

BWV846Full_Bass:

DEBUGPLN "Bass: BAR 1"
REPT 2
    PianoNote C3, 1
    PianoNote E3, 6
    PianoRest 1
ENDR

; bar 2
DEBUGPLN "Bass: BAR 2"
REPT 2
    PianoNote C3, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 3
DEBUGPLN "Bass: BAR 3"
REPT 2
    PianoNote B2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 4
DEBUGPLN "Bass: BAR 4"
REPT 2
    PianoNote C3, 1
    PianoNote E3, 6
    PianoRest 1
ENDR

; bar 5
DEBUGPLN "Bass: BAR 5"
REPT 2
    PianoNote C3, 1
    PianoNote E3, 6
    PianoRest 1
ENDR

; bar 6
DEBUGPLN "Bass: BAR 6"
REPT 2
    PianoNote C3, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 7
DEBUGPLN "Bass: BAR 7"
REPT 2
    PianoNote B2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 8
DEBUGPLN "Bass: BAR 8"
REPT 2
    PianoNote B2, 1
    PianoNote C3, 6
    PianoRest 1
ENDR

; bar 9
DEBUGPLN "Bass: BAR 9"
REPT 2
    PianoNote A2, 1
    PianoNote C3, 6
    PianoRest 1
ENDR

; bar 10
DEBUGPLN "Bass: BAR 10"
REPT 2
    PianoNote D2, 1
    PianoNote Gb2, 6
    PianoRest 1
ENDR

; bar 11
DEBUGPLN "Bass: BAR 11"
REPT 2
    PianoNote G2, 1
    PianoNote B2, 6
    PianoRest 1
ENDR

; bar 12
DEBUGPLN "Bass: BAR 12"
REPT 2
    PianoNote G2, 1
    PianoNote Bb2, 6
    PianoRest 1
ENDR

; bar 13
DEBUGPLN "Bass: BAR 13"
REPT 2
    PianoNote F2, 1
    PianoNote A2, 6
    PianoRest 1
ENDR

; bar 14
DEBUGPLN "Bass: BAR 14"
REPT 2
    PianoNote F2, 1
    PianoNote Ab2, 6
    PianoRest 1
ENDR

; bar 15
DEBUGPLN "Bass: BAR 15"
REPT 2
    PianoNote E2, 1
    PianoNote G2, 6
    PianoRest 1
ENDR

; bar 16
DEBUGPLN "Bass: BAR 16"
REPT 2
    PianoNote E2, 1
    PianoNote F2, 6
    PianoRest 1
ENDR

; bar 17
DEBUGPLN "Bass: BAR 17"
REPT 2
    PianoNote D2, 1
    PianoNote F2, 6
    PianoRest 1
ENDR

; bar 18
DEBUGPLN "Bass: BAR 18"
REPT 2
    PianoNote G2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 19
DEBUGPLN "Bass: BAR 19"
REPT 2
    PianoNote C3, 1
    PianoNote E3, 6
    PianoRest 1
ENDR

; bar 20
DEBUGPLN "Bass: BAR 20"
REPT 2
    PianoNote C3, 1
    PianoNote G3, 6
    PianoRest 1
ENDR

; bar 21
DEBUGPLN "Bass: BAR 21"
REPT 2
    PianoNote F2, 1
    PianoNote F3, 6
    PianoRest 1
ENDR

; bar 22
DEBUGPLN "Bass: BAR 22"
REPT 2
    PianoNote Gb2, 1
    PianoNote C3, 6
    PianoRest 1
ENDR

; bar 23
DEBUGPLN "Bass: BAR 23"
REPT 2
    PianoNote Ab2, 1
    PianoNote F3, 6
    PianoRest 1
ENDR


; bar 24
DEBUGPLN "Bass: BAR 24"
REPT 2
    PianoNote B2, 1
    PianoNote F3, 6
    PianoRest 1
ENDR

; bar 25
DEBUGPLN "Bass: BAR 25"
REPT 2
    PianoNote G2, 1
    PianoNote E3, 6
    PianoRest 1
ENDR

; bar 26
DEBUGPLN "Bass: BAR 26"
REPT 2
    PianoNote G2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 27
DEBUGPLN "Bass: BAR 27"
REPT 2
    PianoNote G2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 28
DEBUGPLN "Bass: BAR 28"
REPT 2
    PianoNote G2, 1
    PianoNote Eb3, 6
    PianoRest 1
ENDR

; bar 29
DEBUGPLN "Bass: BAR 29"
REPT 2
    PianoNote G2, 1
    PianoNote E3, 6
    PianoRest 1
ENDR

; bar 30
DEBUGPLN "Bass: BAR 30"
REPT 2
    PianoNote G2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR

; bar 31
DEBUGPLN "Bass: BAR 31"
REPT 2
    PianoNote G2, 1
    PianoNote D3, 6
    PianoRest 1
ENDR


; bar 32
DEBUGPLN "Bass: BAR 32"
REPT 2
    PianoNote B2, 1
    PianoNote C3, 7
ENDR

; bar 33


DEF PIANO_ENVSPD = 0

PianoNote C3, 32

BWV846Full_BassEnd:



;; parameters for bass
PURGE PIANO_DUTY_CYCLE
PURGE PIANO_INITIAL_VOL
PURGE PIANO_ENVSPD
DEF PIANO_DUTY_CYCLE = %00
DEF PIANO_INITIAL_VOL = 13
DEF PIANO_ENVSPD = 5

BWV846Full_Treble:


; bar 1
DEBUGPLN "Treble: BAR 1"

REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 2
DEBUGPLN "Treble: BAR 2"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote A3, 1
        PianoNote D4, 1
        PianoNote F4, 1
    ENDR
ENDR

; bar 3
DEBUGPLN "Treble: BAR 3"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote D4, 1
        PianoNote F4, 1
    ENDR
ENDR

; bar 4
DEBUGPLN "Treble: BAR 4"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 5
DEBUGPLN "Treble: BAR 5"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote E3, 1
        PianoNote A3, 1
        PianoNote C4, 1
    ENDR
ENDR

; bar 6
DEBUGPLN "Treble: BAR 6"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote A3, 1
        PianoNote D4, 1
        PianoNote Gb4, 1
    ENDR
ENDR

; bar 7
DEBUGPLN "Treble: BAR 7"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote G4, 1
        PianoNote B4, 1
    ENDR
ENDR

; bar 8
DEBUGPLN "Treble: BAR 8"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 9
DEBUGPLN "Treble: BAR 9"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote E3, 1
        PianoNote A3, 1
        PianoNote C4, 1
    ENDR
ENDR

; bar 10
DEBUGPLN "Treble: BAR 10"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote A3, 1
        PianoNote D4, 1
        PianoNote Gb4, 1
    ENDR
ENDR

; bar 11
DEBUGPLN "Treble: BAR 11"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D3, 1
        PianoNote G3, 1
        PianoNote B3, 1
    ENDR
ENDR

; bar 12
DEBUGPLN "Treble: BAR 12"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote Db4, 1
        PianoNote G4, 1
        PianoNote Bb4, 1
    ENDR
ENDR

; bar 13
DEBUGPLN "Treble: BAR 13"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote A3, 1
        PianoNote D4, 1
        PianoNote F4, 1
    ENDR
ENDR

; bar 14
DEBUGPLN "Treble: BAR 14"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote B3, 1
        PianoNote F4, 1
        PianoNote Ab4, 1
    ENDR
ENDR

; bar 15
DEBUGPLN "Treble: BAR 15"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 16
DEBUGPLN "Treble: BAR 16"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote C4, 1
        PianoNote F4, 1
        PianoNote A4, 1
    ENDR
ENDR

; bar 17
DEBUGPLN "Treble: BAR 17"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote A3, 1
        PianoNote D4, 1
        PianoNote F4, 1
    ENDR
ENDR

; bar 18
DEBUGPLN "Treble: BAR 18"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote G4, 1
        PianoNote B4, 1
    ENDR
ENDR

; bar 19
DEBUGPLN "Treble: BAR 19"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 20
DEBUGPLN "Treble: BAR 20"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 21
DEBUGPLN "Treble: BAR 21"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote C4, 1
        PianoNote F4, 1
        PianoNote A4, 1
    ENDR
ENDR

; bar 22
DEBUGPLN "Treble: BAR 22"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote C4, 1
        PianoNote Gb4, 1
        PianoNote A4, 1
    ENDR
ENDR

; bar 23
DEBUGPLN "Treble: BAR 23"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote Ab4, 1
        PianoNote B4, 1
    ENDR
ENDR

; --- Dominant (G) pedal begins (bars 24–31)
; bar 24
DEBUGPLN "Treble: BAR 24"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote G4, 1
        PianoNote B4, 1
    ENDR
ENDR

; bar 25
DEBUGPLN "Treble: BAR 25"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 26
DEBUGPLN "Treble: BAR 26"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D3, 1
        PianoNote G3, 1
        PianoNote C4, 1
    ENDR
ENDR

; bar 27
DEBUGPLN "Treble: BAR 27"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote G4, 1
        PianoNote B4, 1
    ENDR
ENDR

; bar 28
DEBUGPLN "Treble: BAR 28"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote Eb4, 1
        PianoNote A4, 1
        PianoNote C5, 1
    ENDR
ENDR

; bar 29
DEBUGPLN "Treble: BAR 29"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; bar 30
DEBUGPLN "Treble: BAR 30"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote G4, 1
        PianoNote C5, 1
    ENDR
ENDR

; bar 31
DEBUGPLN "Treble: BAR 31"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote D4, 1
        PianoNote G4, 1
        PianoNote B4, 1
    ENDR
ENDR

; --- Tonic (C) pedal & close (bars 32–35)
; bar 32
DEBUGPLN "Treble: BAR 32"
REPT 2
    PianoRest 2
    REPT 2
        PianoNote G3, 1
        PianoNote C4, 1
        PianoNote E4, 1
    ENDR
ENDR

; BAR 33

IF DEF(PIANO_ENVSPD)
PURGE PIANO_ENVSPD
ENDC
DEF PIANO_ENVSPD = 0

    PianoNote E4, 32


BWV846Full_TrebleEnd: