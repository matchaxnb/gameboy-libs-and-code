IF !DEF(AUDIO_ENGINE_ASM)
DEF AUDIO_ENGINE_ASM EQU 0
INCLUDE "macros/macros.inc"

;; define the normal variables
SECTION FRAGMENT "VARIABLES", WRAM0
    wAudioFunPointer:: dw
    ; this is for storing less-critical audio state, like the current track title, and the audio play function pointer
    AudioState::
        AudioState.trackName:: ds TRACKTITLES_MAX_LENGTH + 1
ENDSECTION

;; define the critical audio variables

SECTION FRAGMENT "HighVars", HRAM
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
ENDSECTION

SECTION FRAGMENT "PROGRAM", ROM0
/*
The audio engine expects a function called AudioPlay that it can call to decide what audio to play.

An easy facility to declare it is using the DeclareTracks macro

*/
;DEF DUR_DIATONIC_C_BASS = (DiatonicC_BassEnd - DiatonicC_Bass) / DETAILED_AUDIO_PKTSIZE
;DEF DUR_DIATONIC_C_TREBLE = (DiatonicC_TrebleEnd - DiatonicC_Treble) / DETAILED_AUDIO_PKTSIZE


;; reset flags and set new song bit when we change the audio track
; @param register a: track number to play ($00-$7f)
AU_DefLoadCompactMusic

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
        and a, $7f ; clear top bit, so that we play audio
        ldh [wAudioMasterClock], a
    ; load track title from ROM to app state
    .loadTrackName
        ldh a, [wMusicTrack]
        and $7f ; clear new track bit
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
Pitches.C2::	    dw  PERIOD_C2
Pitches.Db2::	dw  PERIOD_Db2 
Pitches.D2::	    dw  PERIOD_D2 
Pitches.Eb2::	dw  PERIOD_Eb2 
Pitches.E2::	    dw  PERIOD_E2 
Pitches.F2::	    dw  PERIOD_F2 
Pitches.Gb2::	dw  PERIOD_Gb2 
Pitches.G2::	    dw  PERIOD_G2 
Pitches.Ab2::	dw  PERIOD_Ab2 
Pitches.A2::	    dw  PERIOD_A2 
Pitches.Bb2::	dw  PERIOD_Bb2 
Pitches.B2::	    dw  PERIOD_B2 
Pitches.C3::	    dw  PERIOD_C3 
Pitches.Db3::	dw  PERIOD_Db3 
Pitches.D3::	    dw  PERIOD_D3 
Pitches.Eb3::	dw  PERIOD_Eb3 
Pitches.E3::	    dw  PERIOD_E3 
Pitches.F3::	    dw  PERIOD_F3 
Pitches.Gb3::	dw  PERIOD_Gb3 
Pitches.G3::	    dw  PERIOD_G3 
Pitches.Ab3::	dw  PERIOD_Ab3 
Pitches.A3::	    dw  PERIOD_A3 
Pitches.Bb3::	dw  PERIOD_Bb3 
Pitches.B3::	    dw  PERIOD_B3 
Pitches.C4::	    dw  PERIOD_C4 
Pitches.Db4::	dw  PERIOD_Db4 
Pitches.D4::	    dw  PERIOD_D4 
Pitches.Eb4::	dw  PERIOD_Eb4 
Pitches.E4::	    dw  PERIOD_E4 
Pitches.F4::	    dw  PERIOD_F4 
Pitches.Gb4::	dw  PERIOD_Gb4 
Pitches.G4::	    dw  PERIOD_G4 
Pitches.Ab4::	dw  PERIOD_Ab4 
Pitches.A4::	    dw  PERIOD_A4 
Pitches.Bb4::	dw  PERIOD_Bb4 
Pitches.B4::	    dw  PERIOD_B4 
Pitches.C5::	    dw  PERIOD_C5 
Pitches.Db5::	dw  PERIOD_Db5 
Pitches.D5::	    dw  PERIOD_D5 
Pitches.Eb5::	dw  PERIOD_Eb5 
Pitches.E5::	    dw  PERIOD_E5 
Pitches.F5::	    dw  PERIOD_F5 
Pitches.Gb5::	dw  PERIOD_Gb5
Pitches.Sil::    dw  0
PitchesTableEnd::

ENDSECTION
REDEF _last_section_stop = STARTOF("MIDI_TABLES") + SIZEOF("MIDI_TABLES")
ENDC ; include guard