IF !DEF(MACROS_AUDIO_BASE_ASM)
DEF MACROS_AUDIOMACROS_ASM = 0
INCLUDE "macros/audio_midi.inc"

EXPORT DEF NOMINAL_GB_BPM EQU (15 * 60 / 8)

; Declare an audio track
; @param \1 track number
; @param \2 function label to call to play that track
; @param ... repeat as many times (up to 126 times) to declare all track numbers
; track numbers should be successive and start with 0
MACRO DeclareTracks
    ASSERT !DEF(MAX_TRACKNUM) ; to ensure this is called only once
    PRINTLN "DeclareTracks: NARG = {_NARG}"
    ASSERT _NARG % 2 == 0
    ; first run a sanity check for each label provided
    ;FOR TRK, 0, _NARG / 2, 1
    ;    DEF _ARGLBL = \1
    ;    DEF _A = \2
    ;    PRINTLN "Testing existence of [\1], i.e. [\2]"
    ;    SHIFT 2
    ;    
    ;    ; ASSERT \<_ARGLBLN> ; test that the label given as argument exists
    ;ENDR
    ;FAIL 
    ; then define MAX_TRACKNUM and generate the code for AudioPlay 
    EXPORT DEF MAX_TRACKNUM EQU (_NARG / 2)
    AudioPlay::
        push af
        push de
        ldh a, [wAudioMasterClock] ; load audio master clock
        bit 7, a
        jr nz, .audioPlayEnd ; if the "pause audio" bit is set, skip
        ld d, a
        ldh a, [wFrameCounter] ; load frame counter    
        and d ; compare to master clock
        cp d
        jr nz, .audioPlayEnd ;; if we are not in a frame matching the master clock, shortcut to the end
        ldh a, [wMusicTrack]
        bit 7, a ; is the "changed" bit set in wMusicTrack
        jr z, .callFun ; if not, just call the function
        ;; the "changed" bit is set, reset it and process data
        and a, $7f ; reset top bit
        ldh [wMusicTrack], a
        ; now match the track num
        FOR TRK, 0, _NARG / 2, 1
            ;DEF TrkLbl = \2
            ;DEF TrkNum = \1
            PRINTLN "Track label \2 and track num \1"
            .testTrk\1
                cp a, \1
                jr nz, .notTrk\1
                StoreFunctionPointer \2, wAudioFunPointer
            .notTrk\1
            SHIFT 2
        ENDR
        .callFun
            CallFunctionPointer wAudioFunPointer
        .audioPlayEnd
            pop de
            pop af
    ret
ENDM ; end macro DefineTracks

ENDC

