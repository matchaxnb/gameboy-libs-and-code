IF !DEF(AUDIO_STATE_GBASM)
DEF AUDIO_STATE_GBASM EQU 0
SECTION FRAGMENT "PROGRAM", ROM0



DEF DUR_DIATONIC_C_BASS = (DiatonicC_BassEnd - DiatonicC_Bass) / AUDIO_PKTSIZE
DEF DUR_DIATONIC_C_TREBLE = (DiatonicC_TrebleEnd - DiatonicC_Treble) / AUDIO_PKTSIZE

DEF DUR_PRELUDE_C_BASS = (BWV846_BassEnd - BWV846_Bass) / AUDIO_PKTSIZE
DEF DUR_PRELUDE_C_TREBLE = (BWV846_TrebleEnd - BWV846_Treble) / AUDIO_PKTSIZE

DEF DUR_FULLPRELUDE_C_BASS = (BWV846Full_BassEnd - BWV846Full_Bass) / AUDIO_PKTSIZE
DEF DUR_FULLPRELUDE_C_TREBLE = (BWV846Full_TrebleEnd - BWV846Full_Treble) / AUDIO_PKTSIZE
PRINTLN "Full prelude duration (bass/treble): {DUR_FULLPRELUDE_C_BASS} / {DUR_FULLPRELUDE_C_TREBLE}"

DEF DUR_CPTPRELUDE_BASS = (BWV846Compact_BassEnd - BWV846Compact_Bass) / COMPACT_AUDIO_PKTSIZE
DEF DUR_CPTPRELUDE_TREB = (BWV846Compact_TrebleEnd - BWV846Compact_Treble) / COMPACT_AUDIO_PKTSIZE
DEF DUR_MYMOTIF_BASS = (MyMotif_BassEnd - MyMotif_Bass) / COMPACT_AUDIO_PKTSIZE
DEF DUR_MYMOTIF_TREB = (MyMotif_TrebleEnd - MyMotif_Treble) / COMPACT_AUDIO_PKTSIZE

PRINTLN "My motif duration (bass/treble): {DUR_MYMOTIF_BASS} / {DUR_MYMOTIF_TREB}"

AU_DefCompactMusicIntoCH1orCH2 CH1
AU_DefCompactMusicIntoCH1orCH2 CH2

AudioC1C2PlayTrack CH2, DiatonicC_Treble, DUR_DIATONIC_C_TREBLE, LP_DIATONIC_C_TREBLE
AudioC1C2PlayTrack CH1, DiatonicC_Bass, DUR_DIATONIC_C_BASS, LP_DIATONIC_C_BASS

; AudioC1C2PlayTrack CH2, BWV846_Treble, DUR_PRELUDE_C_TREBLE, 0
; AudioC1C2PlayTrack CH1, BWV846_Bass, DUR_PRELUDE_C_BASS, 0


AudioC1C2PlayTrack CH2, BWV846Full_Treble, DUR_FULLPRELUDE_C_TREBLE, 0
AudioC1C2PlayTrack CH1, BWV846Full_Bass, DUR_FULLPRELUDE_C_BASS, 0

CompactPlayAudio_CH1orCH2 CH1, MyMotif_Bass, DUR_MYMOTIF_BASS, 0
CompactPlayAudio_CH1orCH2 CH2, MyMotif_Treble, DUR_MYMOTIF_TREB, 0

CompactPlayAudio_CH1orCH2 CH1, BWV846Compact_Bass, DUR_CPTPRELUDE_BASS, 0
CompactPlayAudio_CH1orCH2 CH2, BWV846Compact_Treble, DUR_CPTPRELUDE_TREB, 0

PRINTLN "Duration in packets Prelude in C (treble/bass): {DUR_PRELUDE_C_TREBLE} / {DUR_PRELUDE_C_BASS}"

; DEF AUDIO_EVERY_OTHER = %11

;; reset flags and set new song bit when we change the audio track
Change_AudioTrack:
    push hl
    push bc
    push de
    push af
    or a, $80; set dirty flag
    ldh [wMusicTrack], a
    ld hl, AudioChannelFlags
    ld bc, AudioChannelFlagsEnd - AudioChannelFlags
    ld d, 0
    call InitMemChunk
    ldh a, [wAudioMasterClock]
    and a, $7f
    ldh [wAudioMasterClock], a
    pop af
    pop de
    pop bc
    pop hl
ret

AudioPlay:
    push af
    push de
    ldh a, [wAudioMasterClock]
    ld d, a
    bit 7, a
    jr nz, .audioPlayEnd
    ldh a, [wFrameCounter] ; load frame counter    
    and d ; compare to master clock
    cp d
    jr nz, .audioPlayEnd ;; if we are not in every other 4th frame, don't move
    ldh a, [wMusicTrack]
    bit 7, a ; is the "changed" bit set in wMusicTrack
    jr z, .callFun ; if not, just call the function
    ;; the "changed" bit is set, reset it and process data
    and a, $7f ; reset top bit
    ldh [wMusicTrack], a
    ; now match the track num
    .testMyMotif
        cp a, TRK_MYMOTIF
        jr nz, .notMyMotif
        StoreFunctionPointer AudioPlay_MyMotif, wFunPointer
    .notMyMotif
        cp a, TRK_PRELUDE
        jr nz, .notPrelude
        StoreFunctionPointer AudioPlay_Prelude, wFunPointer
    .notPrelude
        cp a, TRK_DIATONIC_C
        jp nz, .notDiatonicC
        StoreFunctionPointer AudioPlay_DiatonicC, wFunPointer
.notDiatonicC
.callFun
    CallFunctionPointer wFunPointer
.audioPlayEnd
    pop de
    pop af
ret

AudioPlay_Prelude:
    call AudioPlay_BWV846Compact_Bass
    call AudioPlay_BWV846Compact_Treble
ret

AudioPlay_DiatonicC:
    ;; call the subroutines for bass and treble
    call AudioPlay_DiatonicC_Bass
    call AudioPlay_DiatonicC_Treble
ret

AudioPlay_MyMotif:
    call AudioPlay_MyMotif_Bass
    call AudioPlay_MyMotif_Treble
ret
ENDC ; include guard