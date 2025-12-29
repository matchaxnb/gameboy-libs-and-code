#!python
import sys
data = []
with open(sys.argv[1], 'r', encoding='utf-8') as fh:
    data = fh.readlines()

def sharptobemol(notename: str):
    if '#' not in notename:
        return notename
    nextnote = noteseq[noteseq.index(notename[0]) + 1]
    notetail = notename.split('#', 1)[-1]
    return f'{nextnote}b{notetail}'


print(';; List of MIDI notes in RGBDS macro format')

noteseq = [a for a in 'CDEFGABC']
for line in data:
    midin, notename, freq = line.strip().split('\t', 2)
    notename = sharptobemol(notename)
    notename = notename.replace('-', '_MINUS_')
    print(f'DEF MIDI_{midin} = {freq}')
    print(f'DEF NOTE_{notename} = MIDI_{midin}')
print(';; End of generated list of MIDI notes')
    
