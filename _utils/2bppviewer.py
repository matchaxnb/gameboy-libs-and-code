#!python
import sys
data = b''
with open(sys.argv[1], 'rb') as fh:
    data = fh.read()

total_len = len(data)
cs = {
        0b00: '  ',
        0b01: '**',
        0b10: '%%',
        0b11: '&&',
        }
print("Total len", total_len)
entry = 0
for byte in range(0, total_len + 1, 16):
    print(f"Entry {entry:02x} (offset 0x{byte:04x})")
    print("----------------------------")
    ccol = data[byte:byte+16]
    if not ccol:
        continue
    for row in range(0, 16, 2):
      rb1, rb2 = ccol[row:row+2]
      render = ''
      for el in range(8):
        assert rb1 < 256
        assert rb2 < 256
        px = cs[(rb1 & 0x80) >> 6 | (rb2 & 0x80) >> 7]
        rb1 <<= 1
        rb1 &= 0xff
        rb2 <<= 1
        rb2 &= 0xff
        render += px
      print((row //2) + 1, ">", f'|{render}|   {len(render) // 2}')
    print("----------------------------")
    entry += 1
