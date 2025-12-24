IF !DEF(GAMELOOP_GBASM)
DEF GAMELOOP_GBASM EQU 0
DEF TROUBLESHOOT_ENGINE EQU 0
SETCHARMAP ascii
SECTION FRAGMENT "PROGRAM", ROM0
StartGame:

ld a, %11
ld [wAudioMasterClock], a
ld a, 0
call Change_AudioTrack




MainLoop:
  ; these can run outside of VBlank
.nonVbl:
  call AudioPlay
  call PollInput     ; chain these 2 calls
  call SetInputState ; chain these 2 calls
  call MutateNonVisualGameState
  
  
  ;; now all state that can be mutated outside of VBlank is handled
  ;; we go to sleep until it's time to draw
  if (!DEF(TROUBLESHOOT_ENGINE) || TROUBLESHOOT_ENGINE == 0)
  ;; perform changes to tilemap and so on

  
  ; this can only be done during VBlank
  
  WaitForVBlank

  ; now we're in VBlank
  
  IS_BUTTON_STATUS_CALLFUN UD, UpDownHandle
  IS_BUTTON_STATUS_CALLFUN LR, LeftRightHandle
  IS_BUTTON_STATUS_CALLFUN A, AHandle
  IS_BUTTON_STATUS_CALLFUN B, BHandle
  IS_BUTTON_STATUS_CALLFUN S, StartHandle
  IS_BUTTON_STATUS_CALLFUN T, SelectHandle
  ; IS_BUTTON_STATUS_CALLFUN R, RightHandle
  ;; now we handle the sequential input
  
call MutateVisualGameState

; turn on screen
  ELSE ; troubleshoot engine
  REPT 1024
  nop
  ENDR
ENDC ; end IF !DEF(TROUBLESHOOT_ENGINE)
jp MainLoop

ENDC