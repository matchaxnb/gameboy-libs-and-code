DEF _PROGRAM_ASM EQU 1

INCLUDE "baseblocks/memory_map.asm"


IF (USE_INTERRUPTS)
    INCLUDE "baseblocks/interrupts.asm"
ENDC

IF (USE_AUDIO_ENGINE)
    INCLUDE "baseblocks/audio_engine.asm"
ENDC

IF (USE_GAME_STATE)
    INCLUDE "baseblocks/game_state.asm"
    
ENDC

IF (USE_GAMELOOP)
    INCLUDE "baseblocks/gameloop.asm"
ENDC

IF (USE_BOOTSTRAP)
    INCLUDE "baseblocks/bootstrap.asm"
ENDC

SECTION FRAGMENT "PROGRAM", ROM0
Libraries::
INCLUDE "libs/all_libs.asm"
EndLibraries::

SECTION FRAGMENT "VARIABLES", WRAM0
lastVariableEntry::
ENDSECTION

SECTION FRAGMENT "HighVars", HRAM
lastHighVariableEntry::
ENDSECTION