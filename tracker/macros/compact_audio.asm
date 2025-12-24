DEF COMPACT_AUDIO_PKTSIZE = 2
DEF OVERALL_TRANSPOSE = 0
; @param \1 CH1 or CH2
MACRO AU_DEFAdjustParametersCH1orCH2
    ASSERT  STRCMP("\1", "CH1") * STRCMP("\1", "CH2") == 0
    if (STRCMP("\1", "CH1") == 0)
    DEF _BASE_REG = rNR11
    else
    DEF _BASE_REG = rNR21
    ENDC

    AdjustParms\1:

    ret
ENDM
; define fun to load music chunk into CH1 or CH2
; read from register hl
; @param \1: CH1 or CH2
MACRO AU_DefCompactMusicIntoCH1orCH2
ASSERT  STRCMP("\1", "CH1") * STRCMP("\1", "CH2") == 0
if (STRCMP("\1", "CH1") == 0)
DEF _BASE_REG = rNR11
else
DEF _BASE_REG = rNR21
ENDC
    LoadCompactMusic\1:
        push de
        push bc
        push hl
        ;; this loads a segment of music into the registers
        ;; first load duration into right register
        ld a, [hli]
        ld d, a ; d <- duration
        ;; check for flags
        bit 6, a
        jr z, .postAdjustmentFlagSet\1
        .adjustmentFlagSet\1
            ld a, [hli]
            ld e, a ; e <- E S S S _ _ _ _
            ld a, d
            swap a ; a <- V V V V _ _ D D
            and a, %11
            sla a
            sla a  ; a <- D D 0 0 0 0 0 0
            ldh [_BASE_REG], a ; set NRx1
            ld a, d;
            swap a ; a <- V V V V _ _ D D
            and a, $f0 ; trim low nib V V V V _ _ _ _
            swap e ; e <- _ _ _ _ E S S S
            or a, e ; a <- V V V V E S S S
            ldh [_BASE_REG + 1], a ; set NRx2
            ;; set timer to 0 and increase offset to pickup next packet
            xor a
            ldh [wMusicTimer\1], a
            ;ldh a, [wMusicOffset\1]
            ;inc a
            ;ldh [wMusicOffset\1], a ; FIXME: check for overflow in some rare condition
            jr .exit\@\1
        .postAdjustmentFlagSet\1
        bit 7, a ; check if silent bit is set
        jr z, .postSilence\@ ;; if not set, skip the silence block
        .silence\@
            ;; for silences, the second byte is ignored, it's constant 0x80
            and a, %00111111
            ldh [wMusicTimer\1], a ; load silence duration into timer
            ldh a, [wMusicOffset\1]
            ld e, a
            ldh a, [wMusicFlags\1]
            ld b, a ; b <- raw music flags
            and a, $0f
            ld d, a ; d <- counter part of flags
            ;; now de is good
            ; inc de
            ; ld a, e
            ; ldh [wMusicOffset\1], a ; set low nib of offset to load
            ; ld a, b 
            ; and a, $f0; a <- flags part of wMusicFlags
            ; or a, d   ; concat d to it
            ; ldh [wMusicFlags\1], a ; set top nib of offset
            jr .exit\@\1 ; shortcut to exit
        .postSilence\@
        .happyFlow\@
            ;; now we know we have a normal note
            ldh [wMusicTimer\1], a ; load timer into adequate state
            ldh a, [wOverallOffsetPitch]
            ld e, a ; e <- overall offset pitch
            ld a, [hl] ; a <- pitch offset in table
            add a, e ; a += overall offset pitch
            ldaTo bc ; bc <- a
            ld hl, PitchesTable
            add hl, bc
            add hl, bc ; pitch table is 16-bit words, so we need to double the offset
            ld a, [hli] ; a <- [hl], hl++
            ldh [_BASE_REG + 2], a ; <- bottom period bits (NR13/NR23)
            ld a, [hl] ; a <- top period bits
            or a, $80 ; set trigger, no length enable
            ldh [_BASE_REG + 3], a ; <- top bits (NR14/NR24) and trigger
        .exit\@\1
        pop hl
        pop bc
        pop de
    ret
ENDM


; macro to play a compact track on a channel
; @param \1 CH1 or CH2
; @param \2 starting location (resolve to a label)
; @param \3 duration in packets (offsetEnd - offsetStart) / COMPACT_AUDIO_PKTSIZE
; @param \4 looping point
MACRO CompactPlayAudio_CH1orCH2
    IF (\3 < 256)
        CompactPlayAudio_CH1orCH2_Short \1, \2, \3, \4
    ELSE
        CompactPlayAudio_CH1orCH2_Long \1, \2, \3, \4
    ENDC
ENDM


; macro to play a compact track on a channel (long version)
; @param \1 CH1 or CH2
; @param \2 starting location (resolve to a label)
; @param \3 duration in packets (offsetEnd - offsetStart) / COMPACT_AUDIO_PKTSIZE
; @param \4 looping point
MACRO CompactPlayAudio_CH1orCH2_Long
ASSERT  STRCMP("\1", "CH1") * STRCMP("\1", "CH2") == 0
ASSERT \3 >= 256
if (STRCMP("\1", "CH1") == 0)
DEF _BASE_REG = rNR11
ELSE
DEF _BASE_REG = rNR21
ENDC
PRINT "Generating function AudioPlay_"
PRINT \2
PRINTLN " with register {_BASE_REG} and looping point \4"
    AudioPlay_\2:
        push de
        ldh a, [wMusicTimer\1]
        ;ld d, a ; d <- music timer
        ;and a, %00111111 ; trim flags
        cp a, 0
        jr nz, .endOfWork\@
        ; timer is 0, so it's time we check to move the offset
        .loadPkt
        ldh a, [wMusicOffset\1]
        ld e, a ; e <- music offset
        ldh a, [wMusicFlags\1]
        and a, $0f ; we can go up to 4095 notes!
        ld d, a; now de has the counter
        ;; check if we need to reset the offset
        cp a, HIGH(\3);
        jr nz, .afterReset\@ ; if a (d) != top bits of length, we know we don't reset
        ld a, e
        cp a, LOW(\3)        ; if de != \3, let's not reset
                             ;; note: might need a +1
        jr nz, .afterReset\@
        ;; here we need to reset to the looping point
        .reset:
            ld e, LOW(\4) ; a <- looping point
            ld a, e
            ldh [wMusicOffset\1], a ; store reset offset 
            ld d, HIGH(\4) ; a <- looping point
            ld a, [wMusicFlags\1] ; load flags var
            and a, $f0 ; trim length from flags var
            or a, d ; concat flags and counter
            ldh [wMusicFlags\1], a ; store reset offset 
            ld a, d
            and a, $0f ; keep only the counter
            ld d, a ; reconstitute de without flags
        .afterReset\@
        ;; now it's time to load the next chunk
        ;; if we're here, we need to load a packet        
        
        ;; this applies the offset within the tack
        ld hl, \2
        REPT COMPACT_AUDIO_PKTSIZE
            add hl, de
        ENDR
        ;; now hl has the packet to load
        push de ; keep de safe as a pure counter
        call LoadCompactMusic\1 ;;
        ; retrieve offset from work mem
        pop de ; retrieve pure counter
        inc de ; increment it
        ld a, [wMusicFlags\1]
        and a, $f0 ; keep flags
        or a, d ; concat counter
        ldh [wMusicFlags\1], a
        ld a, e
        ldh [wMusicOffset\1], a ; store new offset to offset flag
        .endOfWork\@
        ; decrease the timer
        ldh a, [wMusicTimer\1]
        cp a, 0
        jr z, .loadPkt ; in case timer is 0, load next packet
        dec a ; decrement timer
        ldh [wMusicTimer\1], a ; store that back to RAM
        .restoreContext\@
        pop de
    ret
ENDM


; macro to play a compact track on a channel (short version)
; @param \1 CH1 or CH2
; @param \2 starting location (resolve to a label)
; @param \3 duration in packets (offsetEnd - offsetStart) / COMPACT_AUDIO_PKTSIZE
; @param \4 looping point
MACRO CompactPlayAudio_CH1orCH2_Short
ASSERT  STRCMP("\1", "CH1") * STRCMP("\1", "CH2") == 0
ASSERT \3 < 256
ASSERT \4 < 256
if (STRCMP("\1", "CH1") == 0)
DEF _BASE_REG = rNR11
ELSE
DEF _BASE_REG = rNR21
ENDC
PRINT "Generating function AudioPlay_"
PRINT \2
PRINTLN " with register {_BASE_REG} and looping point \4"
    AudioPlay_\2:
        push de
        ldh a, [wMusicTimer\1]
        ;ld d, a ; d <- music timer
        ;and a, %00111111 ; trim flags
        cp a, 0
        jr nz, .endOfWork\@
        ; timer is 0, so it's time we check to move the offset
        .loadPkt
        ldh a, [wMusicOffset\1]
        ld e, a ; e <- music offset
        ;; check if we need to reset the offset
        cp a, \3
        jr c, .afterReset\@ ; if curOffset - (duration) is negative, no need to reset
        ;; here we need to reset to the looping point
        .reset:
            ld a, \4 ; a <- looping point
            ldh [wMusicOffset\1], a ; store reset offset 
            ld e, \4 ; e <- looping point (current offset)
        .afterReset\@
        ;; now it's time to load the next chunk
        ;; if we're here, we need to load a packet        
        
        ld a, [wMusicOffset\1] ; get the next offset to load
        ldaTo de
        ;; this applies the offset within the tack
        ld hl, \2
        REPT COMPACT_AUDIO_PKTSIZE
            add hl, de
        ENDR
        ;; now hl has the packet to load
        
        call LoadCompactMusic\1 ;;
        ; retrieve offset from work mem
        ldh a, [wMusicOffset\1]
        inc a
        ldh [wMusicOffset\1], a ; store new offset to offset flag
        .endOfWork\@
        ; decrease the timer
        ldh a, [wMusicTimer\1]
        ld d, a ; copy timer to d
        cp a, 0
        jr z, .loadPkt ; in case timer is 0, load next packet
        ;and a, %11000000 ; keep only flags
        ;ld e, a ; flags in e
        ;ld d, a ; pristine timer
        ;and a, %00111111 ;
        dec a ; decrement timer
        ;or a, e ; combine timer and flags
        ldh [wMusicTimer\1], a ; store that back to RAM
        .restoreContext\@
        pop de
    ret
ENDM

; store an adjustment word for compact sound
; @param \1 duty cycle (%00->%11)
; @param \2 initial volume (0-15)
; @param \3 envelope direction (0: decrease, 1: increase)
; @param \4 envelope speed (0-7)
; format is
; _ _ D D V V V V   E S S S _ _ _ _
; D: duty cycle ()
; V: initial volume (0-15)
; E: envelope direction (0: decrease, 1: increase)
; S: envelope speed (0-7)
; stored in 2 bytes (1 word)
MACRO AU_CompactAdjustment
    ASSERT \1 >= 0 && \1 < %100
    ASSERT \2 >= 0 && \2 < 16
    ASSERT \3 & %1 == \3
    ASSERT \4 >=0 && \4 < 8
    db %11000000 | (\1 << 4) | \2
    db \3 << 7 | (\4 << 4)
ENDM
; macro to define a more compact music format
; assumes that the synth parameters are already set
; @param \1 pitch offset (in words) relative to PitchesTable (starts at C2, ends at Gb5, + Silence)
; @param \2 duration (in music ticks) (max 63)
; @param \3 silence flag (bit 7) (optional)
MACRO AU_CompactMusic
    if (STRLEN("\3") == 0 || STRCMP("\3", "0") == 0) ; silence flag not set
    ASSERT (\1 >= 0 && \1 < ((PitchesTableEnd - PitchesTable) / 2))
    ASSERT (\2 < 64)
        db \2 ; store duration
        db \1 ; then store offset to PitchesTable
    ELSE  
        db \2   ; duration of silence
        db 0x80 ; marker of silence
    ENDC
ENDM



; @param \1 Note (from C1 to Gb5)
; @param \2 Duration (in 32th notes)
MACRO PianoNoteShort
    ASSERT ((Pitches.\1 - PitchesTable) + OVERALL_TRANSPOSE) <= ((PitchesTableEnd - PitchesTable))
    ASSERT \2 < 64

    DEF _REALOFFSET = ((Pitches.\1) - PitchesTable) + (OVERALL_TRANSPOSE * 2)
    ASSERT (_REALOFFSET + PitchesTable) < PitchesTableEnd
    ASSERT _REALOFFSET >= 0
    DEF _N = _REALOFFSET / 2

    ; PRINTLN STRFMT("PianoNoteShort \1 duration \2 offset %d cr: %d", _N, CONVERSION_RATIO)
    AU_CompactMusic \
        _N, \
        \2 * CONVERSION_RATIO, \
        0
    PURGE _REALOFFSET
    PURGE _N
ENDM

; @param \1 Duration (in 16th notes)
MACRO PianoRestShort
ASSERT \1 < 64
DEBUGPLN STRFMT("PianoRest \1 cr: %d", CONVERSION_RATIO)
AU_CompactMusic 0, \1 * CONVERSION_RATIO, 1
ENDM

; @param \1 A label. There should be a corresponding terminator label ending with End
; @param \2 a def name

MACRO CompactAudioTrackSize
    ZoneLength \1, \2, 0
    DEF \2 = \2 / COMPACT_AUDIO_PKTSIZE
ENDM