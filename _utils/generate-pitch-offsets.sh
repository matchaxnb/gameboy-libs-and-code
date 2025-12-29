i=0; 
echo "; auto-generated using $0" | tee ../common/macros/audio_offsets.inc
grep -E '^Pitches[A-Gb]{1,2}[0-9]::' ../common/baseblocks/audio_engine.asm | cut -d: -f1 | sed s@Pitches@@g | while read e; do echo "EXPORT DEF Offset${e} EQU ${i}"; i=$(($i + 1)); done | tee -a ../common/macros/audio_offsets.inc
