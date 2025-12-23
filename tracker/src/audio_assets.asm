IF !DEF(AUDIO_ASSETS_GBASM)
DEF AUDIO_ASSETS_GBASM EQU 0

DEF AUDIO_PKTSIZE = 6
DEF TRK_MYMOTIF = 0
DEF TRK_PRELUDE = 1
DEF TRK_DIATONIC_C = 2
DEF MAX_TRACKNUM = 2
DEF LP_DIATONIC_C_BASS = 2
DEF LP_DIATONIC_C_TREBLE = 2
SECTION "MUSIC", ROM0[$800]

INCLUDE "assets/audio/prelude.asm"
INCLUDE "assets/audio/diatonic_c.asm"
INCLUDE "assets/audio/prelude_full.asm"
INCLUDE "assets/audio/prelude_compact.asm"
INCLUDE "assets/audio/mymotif.asm"
ENDC