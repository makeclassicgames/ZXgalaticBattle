org     $5dad

; -----------------------------------------------------------------------------
; Indicadores
;
; Bit 0 -> se debe mover la nave            0 = No, 1 = Sí
; Bit 1 -> el disparo está activo           0 = No, 1 = Sí
; Bit 2 -> se deben mover los enemigos      0 = No, 1 = Sí
; -----------------------------------------------------------------------------
flags:
db $00

Main:
ld      a, $02
call    OPENCHAN

ld      hl, udgsCommon
ld      (UDG), hl

ld      hl, ATTR_P
ld      (hl), $07
call    CLS

xor     a
out     ($fe), a
ld      a, (BORDCR)
and     $c7
or      $07
ld      (BORDCR), a

call    PrintFrame
call    PrintInfoGame
call    PrintShip

di
ld      a, $28
ld      i, a
im      2
ei

call    LoadUdgsEnemies
call    PrintEnemies

Main_loop:
call    CheckCtrl
call    MoveFire
push de
call    CheckCrashFire
pop de
ld a, (enemiesCounter)
or a
jr z, Main_restart

call    MoveShip
call    MoveEnemies
jr      Main_loop

Main_restart:
call changeLevel
call checkCrashShip
jr Main_loop

include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
include "ctrl.asm"
include "game.asm"

end     Main