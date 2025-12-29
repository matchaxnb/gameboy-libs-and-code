IF !DEF(GAMELOOP_GBASM)
DEF GAMELOOP_GBASM EQU 0
INCLUDE "macros/macros.inc"
INCLUDE "data/charmap.inc"
DEF TROUBLESHOOT_ENGINE EQU 0
SETCHARMAP ascii
SECTION FRAGMENT "PROGRAM", ROM0
StartGame::
jp LateGameSetup
PostLateGameSetup::

; when starting the game, play track 0 with master clock = 4
IF (USE_AUDIO_ENGINE)
  ld a, %11
  ld [wAudioMasterClock], a
  ld a, 0
  call Change_AudioTrack
ENDC

MainLoop:
  ; these can run outside of VBlank
  .nonVbl:
  IF (USE_AUDIO_ENGINE)
    call AudioPlay
  ENDC
  IF (USE_INPUT_LIB)
    call PollInput     ; chain these 2 calls
    call SetInputState ; chain these 2 calls
  ENDC

  jp MutateNonVisualGameStateHandler ; this must jump back to PostMutateNonVisualGameState
  PostMutateNonVisualGameState::
  
  ;; now all state that can be mutated outside of VBlank is handled
  ;; we go to sleep until it's time to draw

  ;; perform changes to tilemap and so on
  ; this can only be done during VBlank
  WaitForVBlank
  
  jp MutateVisualGameStateHandler ; this must jump back to PostMutateVisualGameState
  PostMutateVisualGameState::

  
jp MainLoop

ENDC