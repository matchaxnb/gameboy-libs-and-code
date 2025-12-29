IF !DEF(GAME_STATE_GBASM)
DEF GAME_STATE_GBASM EQU 0
SECTION FRAGMENT "PROGRAM", ROM0

;; define the variables pertaining to the game state
PUSHS FRAGMENT "VARIABLES", WRAM0
    GameState::
    room: db ; dummy
    ;    GameState.room: db ; room ID 1 byte
    ;    GameState.stateMachineState: db ; just an ID
    GameStateEnd::
POPS

ENDC