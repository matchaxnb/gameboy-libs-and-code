IF !DEF(AUDIO_TRACKS_ASM)
DEF AUDIO_TRACKS_ASM EQU 0

INCLUDE "macros/macros.inc"

SECTION "MusicAssets", ROM0[_last_section_stop]

; INCLUDE "assets/audio/prelude.asm" ; uses long-form audio, disabled
; INCLUDE "assets/audio/prelude_full.asm"  ; uses long-form audio, disabled
MusicTracks::
INCLUDE "assets/audio/diatonic_c.inc"
INCLUDE "assets/audio/prelude_compact.inc"
INCLUDE "assets/audio/mymotif.inc"
MusicTracksEnd::

ENDSECTION
REDEF _last_section_stop = STARTOF("MusicAssets") + SIZEOF("MusicAssets")

SECTION FRAGMENT "PROGRAM", ROM0

;DEF DUR_PRELUDE_C_BASS = (BWV846_BassEnd - BWV846_Bass) / DETAILED_AUDIO_PKTSIZE
;DEF DUR_PRELUDE_C_TREBLE = (BWV846_TrebleEnd - BWV846_Treble) / DETAILED_AUDIO_PKTSIZE

; DEF DUR_FULLPRELUDE_C_BASS = (BWV846Full_BassEnd - BWV846Full_Bass) / DETAILED_AUDIO_PKTSIZE
; DEF DUR_FULLPRELUDE_C_TREBLE = (BWV846Full_TrebleEnd - BWV846Full_Treble) / DETAILED_AUDIO_PKTSIZE


DEF DUR_CPTPRELUDE_BASS EQU (BWV846Compact_BassEnd - BWV846Compact_Bass) / COMPACT_AUDIO_PKTSIZE
DEF DUR_CPTPRELUDE_TREB EQU (BWV846Compact_TrebleEnd - BWV846Compact_Treble) / COMPACT_AUDIO_PKTSIZE
DEF DUR_MYMOTIF_BASS EQU (MyMotif_BassEnd - MyMotif_Bass) / COMPACT_AUDIO_PKTSIZE
DEF DUR_MYMOTIF_TREB EQU (MyMotif_TrebleEnd - MyMotif_Treble) / COMPACT_AUDIO_PKTSIZE

CompactAudioTrackSize DiatonicC_Bass, DUR_DIATONIC_C_BASS
CompactAudioTrackSize DiatonicC_Treble, DUR_DIATONIC_C_TREBLE

; if you want to use Detailed audio (more expensive but gives finer control, at the cost of ROM size and cycles)
; DetailedAudioC1C2PlayTrack CH2, BWV846_Treble, DUR_PRELUDE_C_TREBLE, 0
; DetailedAudioC1C2PlayTrack CH1, BWV846_Bass, DUR_PRELUDE_C_BASS, 0

CompactPlayAudio_CH1orCH2 CH1, MyMotif_Bass, DUR_MYMOTIF_BASS, 0
CompactPlayAudio_CH1orCH2 CH2, MyMotif_Treble, DUR_MYMOTIF_TREB, 0

CompactPlayAudio_CH1orCH2 CH1, BWV846Compact_Bass, DUR_CPTPRELUDE_BASS, 0
CompactPlayAudio_CH1orCH2 CH2, BWV846Compact_Treble, DUR_CPTPRELUDE_TREB, 0

CompactPlayAudio_CH1orCH2 CH1, DiatonicC_Bass, DUR_DIATONIC_C_BASS, 0
CompactPlayAudio_CH1orCH2 CH2, DiatonicC_Treble, DUR_DIATONIC_C_TREBLE, 0

TrkPrelude:
    call PlayChannel_BWV846Compact_Bass
    call PlayChannel_BWV846Compact_Treble
ret
;
TrkDiatonicC:
    ;; call the subroutines for bass and treble
    call PlayChannel_DiatonicC_Bass
    call PlayChannel_DiatonicC_Treble
ret

TrkMyMotif:
    call PlayChannel_MyMotif_Bass
    call PlayChannel_MyMotif_Treble
ret

; this will create the AudioPlay function
DeclareTracks \
    0, TrkMyMotif, \
    1, TrkPrelude, \
    2, TrkDiatonicC
;DeclareTracks 0, TrkDiatonicC

ENDC