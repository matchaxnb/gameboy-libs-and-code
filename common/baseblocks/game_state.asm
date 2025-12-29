IF !DEF(GAME_STATE_GBASM)
DEF GAME_STATE_GBASM EQU 0
SECTION FRAGMENT "PROGRAM", ROM0

;; define the variables pertaining to the game state
PUSHS "Variables", WRAM0
    GameState::
    room: db ; dummy
    ;    GameState.room: db ; room ID 1 byte
    ;    GameState.stateMachineState: db ; just an ID
    GameStateEnd::
POPS

;; FIXME: move all this out of the framework and into proper places
; careful, this writes to VRAM
SubstituteTiles::
    ret

; based on GameState items, perform state transitions
_RefreshStateMachine::

ret

; auxiliary to WriteSpeedOnScreen
ENDC