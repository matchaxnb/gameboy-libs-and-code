IF !DEF(AUDIO_ENGINE_ASM)
DEF AUDIO_ENGINE_ASM EQU 0
INCLUDE "macros/macros.inc"

;; define the normal variables
PUSHS FRAGMENT "Variables", WRAM0
    wAudioFunPointer:: dw
    ; this is for storing less-critical audio state, like the current track title, and the audio play function pointer
    AudioState::
        AudioState.trackName:: ds TRACKTITLES_MAX_LENGTH + 1
POPS
DEF _FOO = 1
;; define the critical audio variables

PUSHS FRAGMENT "HighVars", HRAM
    AudioChannelFlags::
        wMusicFlagsCH1:: db
        wMusicOffsetCH1:: db
        wMusicTimerCH1:: db
        
        wMusicFlagsCH2:: db
        wMusicOffsetCH2:: db
        wMusicTimerCH2:: db
        
        
        wMusicFlagsCH3:: db
        wMusicOffsetCH3:: db
        wMusicTimerCH3:: db
        
        
        wMusicFlagsCH4:: db
        wMusicOffsetCH4:: db
        wMusicTimerCH4:: db
        
    AudioChannelFlagsEnd::
    wAudioMasterClock:: db ; top bit: pause audio if set. the rest is the game tick divider for handling audio
    wOverallOffsetPitch:: db
    wMusicTrack:: db ; top bit is the "changed" flag, the rest is the actual track num ($0-$7f)
POPS
SECTION FRAGMENT "PROGRAM", ROM0
/*
The audio engine expects a function called AudioPlay that it can call to decide what audio to play.

An easy facility to declare it is using the DeclareTracks macro

*/
;DEF DUR_DIATONIC_C_BASS = (DiatonicC_BassEnd - DiatonicC_Bass) / DETAILED_AUDIO_PKTSIZE
;DEF DUR_DIATONIC_C_TREBLE = (DiatonicC_TrebleEnd - DiatonicC_Treble) / DETAILED_AUDIO_PKTSIZE


;; reset flags and set new song bit when we change the audio track
; @param register a: track number to play ($00-$7f)
Change_AudioTrack::
    push hl
    push bc
    push de
    push af
    or a, $80; set "track changed" bit
    ldh [wMusicTrack], a ; store track ID to play
    ;; reset audio flags for all tracks
    .resetFlags
        ld hl, AudioChannelFlags
        ld bc, AudioChannelFlagsEnd - AudioChannelFlags
        ld d, 0
        call InitMemChunk
    .cleanAudioMasterClock
        ldh a, [wAudioMasterClock]
        and a, $7f ; clear top bit, so that audio master is clock at most 0x7f
        ldh [wAudioMasterClock], a
    ; load track title from ROM to app state
    .loadTrackName
        ldh a, [wMusicTrack]
        and $7f
        ld hl, TrackNamesTable
        call GetNthEntryFromTextTable ; de <- address of the string to copy
        ld hl, AudioState.trackName
        ld c, TRACKTITLES_MAX_LENGTH
        call StrCpyWithCleanup ; hl: Target, de: Source, c: Lengthexpected
    pop af
    pop de
    pop bc
    pop hl
ret

SECTION "MIDI_TABLES", ROM0[_last_section_stop]
;; REMEMBER dw are stored in little-endian. the MS byte is lower in address space
PitchesTable::
PitchesC2::	    dw  PERIOD_C2
PitchesDb2::	dw  PERIOD_Db2 
PitchesD2::	    dw  PERIOD_D2 
PitchesEb2::	dw  PERIOD_Eb2 
PitchesE2::	    dw  PERIOD_E2 
PitchesF2::	    dw  PERIOD_F2 
PitchesGb2::	dw  PERIOD_Gb2 
PitchesG2::	    dw  PERIOD_G2 
PitchesAb2::	dw  PERIOD_Ab2 
PitchesA2::	    dw  PERIOD_A2 
PitchesBb2::	dw  PERIOD_Bb2 
PitchesB2::	    dw  PERIOD_B2 
PitchesC3::	    dw  PERIOD_C3 
PitchesDb3::	dw  PERIOD_Db3 
PitchesD3::	    dw  PERIOD_D3 
PitchesEb3::	dw  PERIOD_Eb3 
PitchesE3::	    dw  PERIOD_E3 
PitchesF3::	    dw  PERIOD_F3 
PitchesGb3::	dw  PERIOD_Gb3 
PitchesG3::	    dw  PERIOD_G3 
PitchesAb3::	dw  PERIOD_Ab3 
PitchesA3::	    dw  PERIOD_A3 
PitchesBb3::	dw  PERIOD_Bb3 
PitchesB3::	    dw  PERIOD_B3 
PitchesC4::	    dw  PERIOD_C4 
PitchesDb4::	dw  PERIOD_Db4 
PitchesD4::	    dw  PERIOD_D4 
PitchesEb4::	dw  PERIOD_Eb4 
PitchesE4::	    dw  PERIOD_E4 
PitchesF4::	    dw  PERIOD_F4 
PitchesGb4::	dw  PERIOD_Gb4 
PitchesG4::	    dw  PERIOD_G4 
PitchesAb4::	dw  PERIOD_Ab4 
PitchesA4::	    dw  PERIOD_A4 
PitchesBb4::	dw  PERIOD_Bb4 
PitchesB4::	    dw  PERIOD_B4 
PitchesC5::	    dw  PERIOD_C5 
PitchesDb5::	dw  PERIOD_Db5 
PitchesD5::	    dw  PERIOD_D5 
PitchesEb5::	dw  PERIOD_Eb5 
PitchesE5::	    dw  PERIOD_E5 
PitchesF5::	    dw  PERIOD_F5 
PitchesGb5::	dw  PERIOD_Gb5
PitchesSil::    dw  0
PitchesTableEnd::

ENDSECTION
REDEF _last_section_stop = STARTOF("MIDI_TABLES") + SIZEOF("MIDI_TABLES")
ENDC ; include guard