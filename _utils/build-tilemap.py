#!python
import sys

infile, outfile = sys.argv[1], sys.argv[2]

out = []
with open(infile, 'r', encoding='utf-8') as fh:
    header = fh.readline()
    offset = 0
    if not header:
        print("No header, exiting. We expect OFFSET=0xNN")
    else:
        assert header.startswith("OFFSET=0x")
        offset = int(header.removeprefix("OFFSET=0x"), 16)
    for lidx, line in enumerate(fh.readlines()):
        if not line:
            continue
        if line[0] == ';':
            continue
        line = line.strip()
        ol = []
        assert len(line) == 64
        for t in range(32):
            v = "{:02x}".format(int(line[t * 2: t * 2 + 2], 16) + offset)
            ol.append(f'${v}')
        out.append(', '.join(ol))
with open(outfile, 'w', encoding='utf-8') as fh:
    fh.write('db ')
    fh.write('\ndb '.join(out))
    fh.write('\n')

print(f"Wrote {outfile}")
