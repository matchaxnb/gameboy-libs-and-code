INCLUDE "macros/macros.inc"
INCLUDE "src/assets/assets.inc"
INCLUDE "src/assets/audio_tracks.inc"
INCLUDE "src/assets/tables.inc"
DEF UpActiveChar = GFX_TILES_OFFSET + 12; CHARVAL("U")
DEF UpInactiveChar = GFX_TILES_OFFSET + 11
DEF DownActiveChar = GFX_TILES_OFFSET + 14
DEF DownInactiveChar = GFX_TILES_OFFSET + 13

INCLUDE "sanity.inc"
SECTION FRAGMENT "PROGRAM", ROM0


SetupTiles::
    ; copy tiles
    ; first, UI items
    ld hl, TILES_LOCATION
    ld de, UITiles
    ld bc, UI_TILES_SIZE
    call Memcopy

    ;; hl is auto-advanced by Memcopy
    ; then, musical elements
    ld bc, MUSICAL_TILES_SIZE
    ld de, MusicalTiles
    call Memcopy

    ; then, sprites
    ld bc, SPRITE_TILES_SIZE
    ld de, SpritesROM
    call Memcopy
    jp PostSetupTiles

SetupTilemaps::
    ; blank the tilemaps
    ld hl, _SCRN1
    ld d, 0
    ld bc, 32*32
    call InitMemChunk

    ; ld c, (TrackerUIEnd - TrackerUI) / 4
    ld b, GFX_TILES_OFFSET ; some tilemaps are built with an offset
    ;; importantly, use LoadTilemapWithOffset to ensure the current offset is stored
    ;; and can be
    call LoadWindowTilemap

    ld hl, _SCRN0
    ld de, TrackerUI
    ld c, (TrackerUIEnd - TrackerUI) / 4
    ld b, GFX_TILES_OFFSET ; some tilemaps are built with an offset
    ;; importantly, use LoadScreenTilemap to keep tilemap state in memory
    ;; and can be
    call LoadScreenTilemap
jp PostSetupTilemaps

; this hook is for setting up things just before starting the main loop
LateGameSetup::
    call LoadAsciiTileset
    jp PostLateGameSetup
; this is an example function showing how to load a tileset safely while in game

LoadAsciiTileset:
  ld bc, ASCII_TILES_SIZE
  ld de, AsciiTiles + ASCII_TILES_SKIPLOAD ; skip the first tile, which is blank
  WaitForVBlank_mutateshl
  DisableLCD
  ld hl, CHARS_LOCATION
  call Memcopy
  EnableLCD
ret

LastInputsHandle:

ret

; importantly this doesn't mutate a
UpDownHandle:

    cp a,  0 ; case: no up, no down
    jr z, .unsetAll ; none of up or down is set
    cp a, %10000000 ; case: up
    jr c, .upIsSet ; up is set, so down is not
    ; case: down
.downIsSet:
    VIEWPORT_TILE_ADDR 6, 3, UpInactiveChar, $9800
    VIEWPORT_TILE_ADDR 6, 7, DownActiveChar, $9800
    jr .out
.upIsSet:
    VIEWPORT_TILE_ADDR 6, 3, UpActiveChar, $9800
    VIEWPORT_TILE_ADDR 6, 7, DownInactiveChar, $9800
    jr .out
.unsetAll:
    VIEWPORT_TILE_ADDR 6, 3, UpInactiveChar, $9800
    VIEWPORT_TILE_ADDR 6, 7, DownInactiveChar, $9800
.out:
ret

; importantly this doesn't mutate a
LeftRightHandle:
DEF LeftActiveChar = GFX_TILES_OFFSET + 16; CHARVAL("U")
DEF LeftInactiveChar = GFX_TILES_OFFSET + 15; CHARVAL("_")
DEF RightActiveChar = GFX_TILES_OFFSET + 18
DEF RightInactiveChar = GFX_TILES_OFFSET + 17
    cp a,  0 ; case: no left, no right
    jr z, .unsetAll ; none of left or right
    cp a, %00100000 ; case: right
    jr c, .rightIsSet
    ; case: left
.leftIsSet:
    VIEWPORT_TILE_ADDR 4, 5, LeftActiveChar, $9800
    VIEWPORT_TILE_ADDR 8, 5, RightInactiveChar, $9800
    jr .out
.rightIsSet:
    VIEWPORT_TILE_ADDR 4, 5, LeftInactiveChar, $9800
    VIEWPORT_TILE_ADDR 8, 5, RightActiveChar, $9800
    jr .out
.unsetAll:
    VIEWPORT_TILE_ADDR 4, 5, LeftInactiveChar, $9800
    VIEWPORT_TILE_ADDR 8, 5, RightInactiveChar, $9800
.out:
ret


AHandle:
    cp a, 0
    jp nz, .isset
DEF AActiveChar  = GFX_TILES_OFFSET + 21
DEF AInactiveChar = GFX_TILES_OFFSET + 20
    VIEWPORT_TILE_ADDR 7, 9, AInactiveChar, $9800
    jp .out
.isset:  
    VIEWPORT_TILE_ADDR 7, 9, AActiveChar, $9800
.out:
ret 

BHandle:
    cp a, 0
    jp nz, .isset
DEF BActiveChar = GFX_TILES_OFFSET + 21
DEF BInactiveChar = GFX_TILES_OFFSET + 19
    VIEWPORT_TILE_ADDR 5, 9, BInactiveChar, $9800
    jp .out
.isset:  
    VIEWPORT_TILE_ADDR 5, 9, BActiveChar, $9800
.out:
ret 

StartHandle:
    cp a, 0
    jp nz, .isset
DEF StartActiveChar = GFX_TILES_OFFSET + 25
DEF StartInactiveChar = GFX_TILES_OFFSET + 24
    VIEWPORT_TILE_ADDR 7, 10, StartInactiveChar, $9800
    jp .out
.isset:  
    VIEWPORT_TILE_ADDR 7, 10, StartActiveChar, $9800
.out:
ret 

SelectHandle:
    cp a, 0
    jp nz, .isset
DEF SelectActiveChar = GFX_TILES_OFFSET + 23
DEF SelectInactiveChar = GFX_TILES_OFFSET + 22
    VIEWPORT_TILE_ADDR 5, 10, SelectInactiveChar, $9800
    jp .out
.isset:  
    VIEWPORT_TILE_ADDR 5, 10, SelectActiveChar, $9800
.out:
ret 


MutateNonVisualGameStateHandler::
    call MutateNonVisualGameState
    jp PostMutateNonVisualGameState

MutateVisualGameStateHandler::
  CallActiveInputHandlers UD, UpDownHandle
  CallActiveInputHandlers LR, LeftRightHandle
  CallActiveInputHandlers A, AHandle
  CallActiveInputHandlers B, BHandle
  CallActiveInputHandlers S, StartHandle
  CallActiveInputHandlers T, SelectHandle
  call MutateVisualGameState
jp PostMutateVisualGameState

MutateNonVisualGameState::
    ;; reminder: input bits: [Down Up Left Right Start Select B A]
    push af
    push bc
    push de
    ld a, [wNewlyPressed]
    ld e, a ; E <- newly pressed keys
    ldh a, [wCurKeys]
    ld c, a ; C <- current keys
    ldh a, [wFrameCounter60]
    ld b, a ; B <- frame counter

.f60sec
    ;; things that happen every second
    ; some state is refreshed only every 60 frames
    cp 60
    jr c, .f32
.labelRet
    ; some state is refreshed every 32 frames

    
    ; AU_SetCH1Data %01, 1, PERIOD_D4, 1, 1, 12, 1, 0
    
.f32
    ld a, b
    cpl
    and a, %11111
    cp %11111
    jr z, .f16
    call _HandleTrackerInput
.f16
    ; some state is refreshed every 16 frames
    ld a, b
    cpl
    and a, %1111
    cp %1111
    jr z, .f8

.f8
    ; some state is refreshed only every 8 frames
    ld a, b
    cpl
    and a, %111
    cp %111
    jr z, .f4
.f4
    and a, %11 ; %11
    xor %11
    jr nz, .after4Frames
    
.after4Frames
.always
    ldh a, [wNewlyReleased]
    ld c, a
    bit PADB_RIGHT, c
    jr z, .postIncPitch
    .incPitch
        ldh a, [wOverallOffsetPitch]
        cp a, 12
        jr nc, .postIncPitch ; if wOverallOffsetPitch >= 12, no further
        inc a
        ldh [wOverallOffsetPitch], a
    .postIncPitch
    bit PADB_LEFT, c
    jr z, .postDecPitch
    .decPitch
        ldh a, [wOverallOffsetPitch]
        cp a, 0
        jr z, .postDecPitch ; reject overflow
        dec a
        ldh [wOverallOffsetPitch], a
    .postDecPitch
    bit PADB_UP, c
    jr z, .postNextTrack
    .nextTrack
        ldh a, [wMusicTrack]
        cp a, MAX_TRACKNUM
        jr nc, .postNextTrack
        inc a
        call Change_AudioTrack
    .postNextTrack
    bit PADB_DOWN, c
    jr z, .postPrevTrack
    .prevTrack
        ldh a, [wMusicTrack]
        cp a, 0
        jr z, .postPrevTrack
        dec a
        call Change_AudioTrack
    .postPrevTrack
    bit PADB_SELECT, c
    jr z, .postResetTrack
    .resetTrack
        call Change_AudioTrack
    .postResetTrack
    bit PADB_START, c
    jr z, .postPlayPauseTrack
    .playPauseTrack
        ld a, [wAudioMasterClock]
        xor a, %10000000 ; flip top bit
        ld [wAudioMasterClock], a
    .postPlayPauseTrack

    bit PADB_A, c
    jr z, .postIncreaseMasterClockSpeed
    .increaseMasterClockSpeed
        ld a, [wAudioMasterClock]
        cp a, 0
        jr z, .postIncreaseMasterClockSpeed
        srl a
        ld [wAudioMasterClock], a
    .postIncreaseMasterClockSpeed
    bit PADB_B, c
    jr z, .postDecreaseMasterClockSpeed
    .decreaseMasterClockSpeed
        ld a, [wAudioMasterClock]
        cp a, %01111111
        jr z, .postDecreaseMasterClockSpeed
        sla a
        or a, 1
        ld [wAudioMasterClock], a
    .postDecreaseMasterClockSpeed

    pop de
    pop bc
    pop af

; based on current inputs, mutate visual things
MutateVisualGameState::
    push af
    push bc
    push de
    
    ldh a, [wCurKeys]
    ld c, a ; C <- current keys
    ldh a, [wSecCounter]
    ld b, a
    and a, %11111100 ; only every 4 seconds
    cp a, b
    jr nz, .f60sec
    ;; things that happen every 4 seconds
    

    .f60sec:
    ;; things that happen every second
    ;ld de, TILES_LOCATION
    ;call BlankTile
    ;call MergeTilesByID

    ldh a, [wFrameCounter60]
    ld b, a ; B <- frame counter
    ; some state is refreshed only every 60 frames
    cp 60
    jr c, .f32
    ; write current speed on screen
    
    ; some state is refreshed every 32 frames
    .f32:
    ld a, b
    cpl
    and a, %11111
    cp %11111
    jr z, .f16
    .f16:
    ; some state is refreshed every 16 frames
    ld a, b
    cpl
    and a, %1111
    cp %1111
    jr z, .f8

    .f8:
    ; some state is refreshed only every 8 frames
    ld a, b
    cpl
    and a, %111
    cp %111
    jr z, .f4
    .f4:
    and a, %11 ; %11
    xor %11
    jr nz, .after4Frames
    call __WriteTextOnWindow

    .after4Frames:
    
    pop de
    pop bc
    pop af
ret

; Mutate state 
_HandleTrackerInput:
    ret ; for now, useless dead code
    ;; accelerate
    bit PADB_UP, c
    jr z, .postMoveUp
.moveUp
.postMoveUp
    bit PADB_DOWN, c
    jr z, .postMoveDown

.moveDown
.postMoveDown
ret

; could be used as a state machine that moves based on wCurKeys and wPrevKeys 
DEF BaseTileAddrForText = 0 ; 16th line, 4th col
DEF GameTileMapOffset = TrackerUITM + BaseTileAddrForText
DEF GameTileLastOffset = GameTileMapOffset + TRACKTITLES_MAX_LENGTH

; uses no input parameters, purely based on game state
; write the text and then write the original blocks
__WriteTextOnBG:
    push hl
    push de
    push bc
    ; ld bc, GameTileMapOffset
    ld hl, AudioState.trackName
    ld de, TILEMAP_LOCATION + BaseTileAddrForText
    ld b, GameTileLastOffset - GameTileMapOffset
    
    .loopWTOS
        ld a, [hl]
        cp a, 0
        ; do we have a text terminator?
        ; if we do, get to redraw the tiles
        jr z, .redrawTiles
        ; if we're here, we should draw text
        ld [de], a ; write tile ID to tilemap at right loc
        inc de ; prepare for next tile
        inc hl ; prepare to read next char
        dec b ; one less tile to go
        jr nz, .loopWTOS ; if we're not done yet, loop
    .redrawTiles
        ; ensure b is not 0 (i.e. we have no tile to redraw)
        ld a, b
        cp a, 0
        jr z, .afterRedraw
        ; setup for reloading tile
        ld a, [wCurrentTilemap]
        ld h, a
        ld a, [wCurrentTilemap +1]
        ld l, a
        ; now hl is set to tilemap
        ; get to right offset
        ld a, b ; save current offset to a temporarily
        ld b, 0 ;
        ld c, a ; 
        add hl, bc ; now hl is set to just the right position in the tilemap
        ld b, a    ; restore redraw counter to b
        ; load offset to apply (in offset-127) and store to c
        ld a, [wCurrentTilemapOffset]
        ;; two options: it's >127, and the offset is positive, or <= 127, and it's negative
        cp 127
        jr c, .loopNeg ; if <127, we handle the negative loop
        sub a, 127 ; remove 127 to get the real offset we want
        ld c, a
        .loopPos
            ld a, [hl]
            add a, c
            ld [de], a
            inc de
            inc hl
            dec b
            jr nz, .loopPos
            jr .afterRedraw
        .loopNeg
            ld a, [hl]
            sub a, c
            ld [de], a
            inc de
            inc hl
            dec b
            jr nz, .loopNeg
            ; jr .afterRedraw
    .afterRedraw
    pop bc
    pop de
    pop hl
ret

__WriteTextOnWindow:
    push hl
    push de
    push bc
    ; ld bc, GameTileMapOffset
    ld hl, AudioState.trackName
    ld de, _SCRN1 + BaseTileAddrForText
    ld b, GameTileLastOffset - GameTileMapOffset
    
    .loopWTOS
        ld a, [hl]
        cp a, STRING_TERMINATOR
        ; do we have a text terminator?
        ; if we do, get to redraw the tiles
        jr z, .redrawTiles
        ; if we're here, we should draw text
        ld [de], a ; write tile ID to tilemap at right loc
        inc de ; prepare for next tile
        inc hl ; prepare to read next char
        dec b ; one less tile to go
        jr nz, .loopWTOS ; if we're not done yet, loop
    .redrawTiles
        ; ensure b is not 0 (i.e. we have no tile to redraw)
        ld a, b
        cp a, 0
        jr z, .afterRedraw
        ld a, [wCurrentWindowTilemapOffset]
        cp a, 0
        jr nz, .withTilemapSetup
        ld a, [wCurrentWindowTilemapOffset+1]
        cp a, 0
        jr nz, .withTilemapSetup
        jr .noTilemap
    .withTilemapSetup
        ; setup for reloading tile
        ld a, [wCurrentTilemap]
        ld h, a
        ld a, [wCurrentTilemap +1]
        ld l, a
        ; now hl is set to tilemap
        ; get to right offset
        ld a, b ; save current offset to a temporarily
        ld b, 0 ;
        ld c, a ; 
        add hl, bc ; now hl is set to just the right position in the tilemap
        ld b, a    ; restore redraw counter to b
        jr .withTilemap
        ; load offset to apply (in offset-127) and store to c
    .noTilemap
    xor a
    .loopNT
        ld [de], a
        inc de
        dec b
        jr nz, .loopNT
    jr .afterRedraw
    ;; untested below
    .withTilemap
        ;; two options: it's >127, and the offset is positive, or <= 127, and it's negative
        ld a, [wCurrentTilemapOffset]
        cp 127
        jr c, .loopNeg ; if <127, we handle the negative loop
        sub a, 127 ; remove 127 to get the real offset we want
        ld c, a
        .loopPos
            ld a, [hl]
            add a, c
            ld [de], a
            inc de
            inc hl
            dec b
            jr nz, .loopPos
            jr .afterRedraw
        .loopNeg
            ld a, [hl]
            sub a, c
            ld [de], a
            inc de
            inc hl
            dec b
            jr nz, .loopNeg
            ; jr .afterRedraw
    .afterRedraw
    pop bc
    pop de
    pop hl
ret
