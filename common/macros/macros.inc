IF !DEF(MACROS_MACROS_ASM)
DEF MACROS_MACROS_ASM EQU 0

IF (USE_AUDIO_ENGINE)
    INCLUDE "macros/audio_base.inc"
    INCLUDE "macros/compact_audio.inc"
ENDC

IF (USE_DETAILED_AUDIO)
    INCLUDE "macros/audio_detailed.inc"
ENDC

INCLUDE "macros/general_macros.inc"

ENDC