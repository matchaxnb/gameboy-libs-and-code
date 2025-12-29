IF !DEF(CHARMAP_GBASM)
DEF CHARMAP_GBASM EQU 0
NEWCHARMAP ascii

EXPORT DEF STRING_TERMINATOR = $ff
EXPORT DEF ASCII_TILES_OFFSET = 128 ; expected id of the first text tile
DEF offset_to_ascii = ASCII_TILES_OFFSET - $21
; Space
; CHARMAP " ", $20 + offset_to_ascii
CHARMAP " ", 0 ; $20 + offset_to_ascii
; Punctuation (0x21–0x2F)
CHARMAP "!", $21 + offset_to_ascii
CHARMAP "\"", $22 + offset_to_ascii ; double quote 
CHARMAP "#", $23 + offset_to_ascii
CHARMAP "$", $24 + offset_to_ascii
CHARMAP "%", $25 + offset_to_ascii
CHARMAP "&", $26 + offset_to_ascii
CHARMAP "'", $27 + offset_to_ascii
CHARMAP "(", $28 + offset_to_ascii
CHARMAP ")", $29 + offset_to_ascii
CHARMAP "*", $2A + offset_to_ascii
CHARMAP "+", $2B + offset_to_ascii
CHARMAP ",", $2C + offset_to_ascii
CHARMAP "-", $2D + offset_to_ascii
CHARMAP ".", $2E + offset_to_ascii
CHARMAP "/", $2F + offset_to_ascii
 
; Digits (0x30–0x39)
CHARMAP "0", $30 + offset_to_ascii
CHARMAP "1", $31 + offset_to_ascii
CHARMAP "2", $32 + offset_to_ascii
CHARMAP "3", $33 + offset_to_ascii
CHARMAP "4", $34 + offset_to_ascii
CHARMAP "5", $35 + offset_to_ascii
CHARMAP "6", $36 + offset_to_ascii
CHARMAP "7", $37 + offset_to_ascii
CHARMAP "8", $38 + offset_to_ascii
CHARMAP "9", $39 + offset_to_ascii
 
; Punctuation (0x3A–0x40)
CHARMAP ":", $3A + offset_to_ascii
CHARMAP ";", $3B + offset_to_ascii
CHARMAP "<", $3C + offset_to_ascii
CHARMAP "=", $3D + offset_to_ascii
CHARMAP ">", $3E + offset_to_ascii
CHARMAP "?", $3F + offset_to_ascii
CHARMAP "@", $40 + offset_to_ascii

; Uppercase letters (0x41–0x5A)
CHARMAP "A", $41 + offset_to_ascii
CHARMAP "B", $42 + offset_to_ascii
CHARMAP "C", $43 + offset_to_ascii
CHARMAP "D", $44 + offset_to_ascii
CHARMAP "E", $45 + offset_to_ascii
CHARMAP "F", $46 + offset_to_ascii
CHARMAP "G", $47 + offset_to_ascii
CHARMAP "H", $48 + offset_to_ascii
CHARMAP "I", $49 + offset_to_ascii
CHARMAP "J", $4A + offset_to_ascii
CHARMAP "K", $4B + offset_to_ascii
CHARMAP "L", $4C + offset_to_ascii
CHARMAP "M", $4D + offset_to_ascii
CHARMAP "N", $4E + offset_to_ascii
CHARMAP "O", $4F + offset_to_ascii
CHARMAP "P", $50 + offset_to_ascii
CHARMAP "Q", $51 + offset_to_ascii
CHARMAP "R", $52 + offset_to_ascii
CHARMAP "S", $53 + offset_to_ascii
CHARMAP "T", $54 + offset_to_ascii
CHARMAP "U", $55 + offset_to_ascii
CHARMAP "V", $56 + offset_to_ascii
CHARMAP "W", $57 + offset_to_ascii
CHARMAP "X", $58 + offset_to_ascii
CHARMAP "Y", $59 + offset_to_ascii
CHARMAP "Z", $5A + offset_to_ascii
 
; Punctuation (0x5B–0x60)
CHARMAP "[", $5B + offset_to_ascii
CHARMAP "\\", $5C + offset_to_ascii ; backslash 
CHARMAP "]", $5D + offset_to_ascii
CHARMAP "^", $5E + offset_to_ascii
CHARMAP "_", $5F + offset_to_ascii
CHARMAP "`", $60 + offset_to_ascii
 
; Lowercase letters (0x61–0x7A)
CHARMAP "a", $61 + offset_to_ascii
CHARMAP "b", $62 + offset_to_ascii
CHARMAP "c", $63 + offset_to_ascii
CHARMAP "d", $64 + offset_to_ascii
CHARMAP "e", $65 + offset_to_ascii
CHARMAP "f", $66 + offset_to_ascii
CHARMAP "g", $67 + offset_to_ascii
CHARMAP "h", $68 + offset_to_ascii
CHARMAP "i", $69 + offset_to_ascii
CHARMAP "j", $6A + offset_to_ascii
CHARMAP "k", $6B + offset_to_ascii
CHARMAP "l", $6C + offset_to_ascii
CHARMAP "m", $6D + offset_to_ascii
CHARMAP "n", $6E + offset_to_ascii
CHARMAP "o", $6F + offset_to_ascii
CHARMAP "p", $70 + offset_to_ascii
CHARMAP "q", $71 + offset_to_ascii
CHARMAP "r", $72 + offset_to_ascii
CHARMAP "s", $73 + offset_to_ascii
CHARMAP "t", $74 + offset_to_ascii
CHARMAP "u", $75 + offset_to_ascii
CHARMAP "v", $76 + offset_to_ascii
CHARMAP "w", $77 + offset_to_ascii
CHARMAP "x", $78 + offset_to_ascii
CHARMAP "y", $79 + offset_to_ascii
CHARMAP "z", $7A + offset_to_ascii

; Punctuation (0x7B–0x7E)
CHARMAP "\{", $7B + offset_to_ascii
CHARMAP "|", $7C + offset_to_ascii
CHARMAP "\}", $7D + offset_to_ascii
CHARMAP "~", $7E + offset_to_ascii

SETCHARMAP ascii
ENDC