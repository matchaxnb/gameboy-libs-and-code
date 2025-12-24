; @param de: Source address
; @param hl: Destination address
; @param bc: Length to copy
; this is a register-only memcopy, useful
; hl is mutated, so successive calls will write to
; adjacent destinations
Memcopy:
.lpm
  ld a, [de] ; get a chunk
  ld [hli], a ; A<-[HL], HL++
  inc de ; next target
  dec bc ; one less to go 
  ld a, b ; A<-(top of BC)
  or a, c ; A <- A|C
  jr nz, .lpm
ret
; @param de: Source address
; @param hl: Destination address
; @param bc: Length to copy
; this is a register-only memcopy, useful
; hl is mutated, so successive calls will write to
; adjacent destinations
MemcopyVBlankSafe:
.lpm
  ld a, [de] ; get a chunk
  ld [hli], a ; A<-[HL], HL++
  inc de ; next target
  dec bc ; one less to go 
  ld a, b ; A<-(top of BC)
  or a, c ; A <- A|C
  jr nz, .lpm
ret

; @param de: Source address
; @param hl: Destination address
; @param bc: Length to copy
; This is a non-mutating Memcopy
MemcopySafe:
  push de
  push hl
  push bc
.lpm
  ld a, [de] ; get a chunk
  ld [hli], a ; A<-[HL], HL++
  inc de ; next target
  dec bc ; one less to go 
  ld a, b ; A<-(top of BC)
  or a, c ; A <- A|C
  jr nz, .lpm
  pop bc
  pop hl
  pop de
ret

; @param hl: Start address
; @param bc: Length to init
; @param d: Value to set
InitMemChunk:
.lp
  ld a, d
  ld [hli], a
  dec bc
  ld a, b
  or a, c
  jr nz, .lp
ret

; @param hl: Start address
; @param bc: Length to init
; @param d: Value to set
InitMemChunkVBlankSafe:
.lp
  ld a, d
  ld [hli], a
  dec bc
  ld a, b
  or a, c
  jr nz, .lp
ret