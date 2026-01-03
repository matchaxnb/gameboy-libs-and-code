INCLUDE "macros/macros.inc"

SECTION "MusicAssets", ROM0[_last_section_stop]
INCLUDE "assets/audio_mymotif.inc"
ENDSECTION
REDEF _last_section_stop = STARTOF("MusicAssets") + SIZEOF("MusicAssets")

INCLUDE "sanity.inc"
SECTION FRAGMENT "PROGRAM", ROM0

DEF DUR_MYMOTIF_BASS EQU (MyMotif_BassEnd - MyMotif_Bass) / COMPACT_AUDIO_PKTSIZE
DEF DUR_MYMOTIF_TREB EQU (MyMotif_TrebleEnd - MyMotif_Treble) / COMPACT_AUDIO_PKTSIZE

CompactPlayAudio_CH1orCH2 CH1, MyMotif_Bass, DUR_MYMOTIF_BASS, 0
CompactPlayAudio_CH1orCH2 CH2, MyMotif_Treble, DUR_MYMOTIF_TREB, 0

TrkMyMotif:
    call PlayChannel_MyMotif_Bass
    call PlayChannel_MyMotif_Treble
ret 

DeclareTracks \
    0, TrkMyMotif

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

