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

;programa principal
Main:
;modo pantalla y carga de elementos
ld      a, $02
call    OPENCHAN

ld      hl, udgsCommon
ld      (UDG), hl

;borrado de pantalla y pintado a negro
ld      hl, ATTR_P
ld      (hl), $07
call    CLS
; pintar borde de la pantalla
xor     a
out     ($fe), a
ld      a, (BORDCR)
and     $c0
or      $05
ld      (BORDCR), a


;activar las interrupciones
di
ld      a, $28
ld      i, a
im      2
ei

main_start:
xor a
ld hl,enemiesCounter
ld (hl),$20
inc hl
ld (hl),a
inc hl
ld (hl),$05
inc hl
ld (hl),a
inc hl
ld (hl),a
; pintar frame y nave
call    changeLevel 
call    PrintFirstScreen
call    PrintFrame
call    PrintInfoGame
call    PrintShip
call    printInfoValue

;cargamos los enemigos y los pintamos
call    LoadUdgsEnemies
call    PrintEnemies

;bucle principal
Main_loop:

call    CheckCtrl   ;comprobar teclas
call    MoveFire    ; mover disparo
;almacenar registro de
push de
call    CheckCrashFire  ;comprobar colisiones disparo y enemigos
pop de

ld a, (enemiesCounter) ;carga contador enemigos
or a    ;or a=a si es 0 actualizara F
jr z, Main_restart  ; si es 0 se reinicia la pantalla

;mover la nave y enemigos
call    MoveShip
call    MoveEnemies
;call    checkCrashShip ; comprobar colision nave
ld a,(enemiesCounter)
or a
jr z,GameOver
jr      Main_loop

;reinicio de pantalla
Main_restart:
ld a,(levelCounter)
cp $1e
jr z,win
call FadeScreen
call changeLevel    ;cambiar al siguiente nivel
call    PrintFrame
call    PrintInfoGame
call    PrintShip
call    printInfoValue
jr Main_loop

GameOver:
xor a
call PrintEndScreen
jp main_start

win:
ld a,$01
call PrintEndScreen
jp main_start

include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
include "ctrl.asm"
include "game.asm"

end     Main