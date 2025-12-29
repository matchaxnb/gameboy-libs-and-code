IF !DEF(LIBS_INPUT_ASM)
DEF LIBS_INPUT_ASM = 0
;; format:

PUSHS FRAGMENT "Variables", WRAM0
    wLastUpdatedInput:: db
POPS

PUSHS FRAGMENT "HighVars", HRAM
wCurKeys:: db   ; current pressed keys
wPrevKeys:: db  ; previously pressed keys
wNewlyPressed:: db ; keys that 
wNewlyReleased:: db
POPS

SECTION FRAGMENT "PROGRAM", ROM0

; poll input
; @returns input state in register a
PollInput::
    ;; poll buttons
    ld a, P1F_GET_BTN
    ld [rP1], a
    REPT 8
        ld a, [rP1]
        nop
    ENDR
    xor a, 0x0f ; xor because 0 -> on, 1 -> off
    and a, 0x0f ; clean top bits
    ld b, a ; copy to b
    ;; now B contains 0000STBA
    ;; poll DPAD
    ld a, P1F_GET_DPAD
    ld [rP1], a
    REPT 8
        ld a, [rP1]
        nop
    ENDR
    xor a, 0x0f 
    and a, 0x0f ; clean top nibs
    swap a ; exchange nibs, a is DULR0000
    or a, b   ; merge the 2 halves, a is DULRSTBA
ret

; based on the polled input, update the various objects
; @input register A, containing the input state
; modifies registers B, C as work registers
; B: previously polled keys [stored in wPrevKeys]
; C: newly polled keys [stored in wCurKeys]
SetInputState::
    ;; store current and previous input status
    ld c, a ; C <- A (current input status as polled)
    ldh a, [wCurKeys] ; A <- (previous input status)
    ld b, a ; B <- previous input status
    ldh [wPrevKeys], a ; prevKeys stored
    ld a, c ; A <- current input status
    ldh [wCurKeys], a ; wCurKeys <- current input status
    xor a, b ; a <- cur ^ old what keys changed between wCurKeys and wPrevKeys
    and a, c ; a <- a & pressed i.e. newly pressed
    ldh [wNewlyPressed], a
    ld a, c  ; a <- wCurKeys
    cpl      ; a <- ~wCurKeys
    and a, b ; a <- ~wCurKeys & wPrevKeys    
    ldh [wNewlyReleased], a
ret

ENDC