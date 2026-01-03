INCLUDE "macros/macros.inc"

SECTION "MusicAssets", ROM0[_last_section_stop]
INCLUDE "assets/audio_annoying.inc"

ENDSECTION
REDEF _last_section_stop = STARTOF("MusicAssets") + SIZEOF("MusicAssets")

INCLUDE "sanity.inc"
SECTION FRAGMENT "PROGRAM", ROM0


;; this computes the size (in "audio packets" of the bass and treble section of the track)
CompactAudioTrackSize AnnoyingE_Bass, DurationAnnoyingEBass
CompactAudioTrackSize AnnoyingE_Treble, DurationAnnoyingETreble

CompactAudioTrackSize AnnoyingC_Bass, DurationAnnoyingCBass
CompactAudioTrackSize AnnoyingC_Treble, DurationAnnoyingCTreble

PRINTLN "Duration of bass/treble section for Annoying E (including engine adjustments): {DurationAnnoyingEBass}/{DurationAnnoyingETreble}"
;; this produces a function PlayChannel_AnnoyingE_Bass that will play on CH1 and loop from the beginning (0)
CompactPlayAudio_CH1orCH2 CH1, AnnoyingE_Bass, DurationAnnoyingEBass, 0
;; this produces a function PlayChannel_AnnoyingE_Treble that will play on CH2 and loop from the beginning (0)
CompactPlayAudio_CH1orCH2 CH2, AnnoyingE_Treble, DurationAnnoyingETreble, 0

; nothing prevents you from swapping channels

; we may set 1 as looping point because the 1st packet is just the initial synth setting
CompactPlayAudio_CH1orCH2 CH1, AnnoyingC_Treble, DurationAnnoyingCTreble, 0
CompactPlayAudio_CH1orCH2 CH2, AnnoyingC_Bass, DurationAnnoyingCTreble, 0

; this calls the bass and treble channel functions
TrkAnnoyingC:
    call PlayChannel_AnnoyingC_Bass
    call PlayChannel_AnnoyingC_Treble
ret


TrkAnnoyingE:
    call PlayChannel_AnnoyingE_Bass
    call PlayChannel_AnnoyingE_Treble
ret 

DeclareTracks \
    0, TrkAnnoyingC, \
    1, TrkAnnoyingE

SetupTiles::
jp PostSetupTiles

SetupTilemaps::
jp PostSetupTilemaps

; this hook is for setting up things just before starting the main loop
LateGameSetup::
jp PostLateGameSetup
; this is an example function showing how to load a tileset safely while in game


LastInputsHandle:
ret

; importantly this doesn't mutate a
UpDownHandle:
ret

; importantly this doesn't mutate a
LeftRightHandle:
ret


AHandle:
ret 

BHandle:
ret 

StartHandle:
ret 

SelectHandle:
ret 


MutateNonVisualGameStateHandler::
    call MutateNonVisualGameState
    jp PostMutateNonVisualGameState

MutateVisualGameStateHandler::
  call MutateVisualGameState
jp PostMutateVisualGameState

MutateNonVisualGameState::
    ;; reminder: input bits: [Down Up Left Right Start Select B A]
    push af
    push bc
    push de
    ld a, [wNewlyPressed]
    ld e, a ; E <- newly pressed keys
    ldh a, [wCurKeys]
    ld c, a ; C <- current keys
    ldh a, [wFrameCounter60]
    ld b, a ; B <- frame counter

    pop de
    pop bc
    pop af

; based on current inputs, mutate visual things
MutateVisualGameState::
    push af
    push bc
    push de
    
    ldh a, [wCurKeys]
    ld c, a ; C <- current keys
    ldh a, [wSecCounter]
    ld b, a
    
    pop de
    pop bc
    pop af
ret

; Mutate state 
_HandleTrackerInput:
ret ; for now, useless dead code

