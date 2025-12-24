IF !DEF(TABLES_AUDIO_GBASM)
DEF TABLES_AUDIO_GBASM = 0
SECTION "MIDI_TABLES", ROM0[$250]
;; REMEMBER dw are stored in little-endian. the MS byte is lower in address space
PitchesTable:
Pitches.C2:	    dw  PERIOD_C2
Pitches.Db2:	dw  PERIOD_Db2 
Pitches.D2:	    dw  PERIOD_D2 
Pitches.Eb2:	dw  PERIOD_Eb2 
Pitches.E2:	    dw  PERIOD_E2 
Pitches.F2:	    dw  PERIOD_F2 
Pitches.Gb2:	dw  PERIOD_Gb2 
Pitches.G2:	    dw  PERIOD_G2 
Pitches.Ab2:	dw  PERIOD_Ab2 
Pitches.A2:	    dw  PERIOD_A2 
Pitches.Bb2:	dw  PERIOD_Bb2 
Pitches.B2:	    dw  PERIOD_B2 
Pitches.C3:	    dw  PERIOD_C3 
Pitches.Db3:	dw  PERIOD_Db3 
Pitches.D3:	    dw  PERIOD_D3 
Pitches.Eb3:	dw  PERIOD_Eb3 
Pitches.E3:	    dw  PERIOD_E3 
Pitches.F3:	    dw  PERIOD_F3 
Pitches.Gb3:	dw  PERIOD_Gb3 
Pitches.G3:	    dw  PERIOD_G3 
Pitches.Ab3:	dw  PERIOD_Ab3 
Pitches.A3:	    dw  PERIOD_A3 
Pitches.Bb3:	dw  PERIOD_Bb3 
Pitches.B3:	    dw  PERIOD_B3 
Pitches.C4:	    dw  PERIOD_C4 
Pitches.Db4:	dw  PERIOD_Db4 
Pitches.D4:	    dw  PERIOD_D4 
Pitches.Eb4:	dw  PERIOD_Eb4 
Pitches.E4:	    dw  PERIOD_E4 
Pitches.F4:	    dw  PERIOD_F4 
Pitches.Gb4:	dw  PERIOD_Gb4 
Pitches.G4:	    dw  PERIOD_G4 
Pitches.Ab4:	dw  PERIOD_Ab4 
Pitches.A4:	    dw  PERIOD_A4 
Pitches.Bb4:	dw  PERIOD_Bb4 
Pitches.B4:	    dw  PERIOD_B4 
Pitches.C5:	    dw  PERIOD_C5 
Pitches.Db5:	dw  PERIOD_Db5 
Pitches.D5:	    dw  PERIOD_D5 
Pitches.Eb5:	dw  PERIOD_Eb5 
Pitches.E5:	    dw  PERIOD_E5 
Pitches.F5:	    dw  PERIOD_F5 
Pitches.Gb5:	dw  PERIOD_Gb5
Pitches.Sil:    dw  0

PitchesTableEnd:
PRINTLN "Pitches table loaded from {PitchesTable} to {PitchesTableEnd}"

ENDC