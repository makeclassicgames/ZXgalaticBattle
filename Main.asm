org     $5dfc

; -----------------------------------------------------------------------------
; Indicadores
;
; Bit 0 -> se debe mover la nave            0 = No, 1 = Sí
; Bit 1 -> el disparo está activo           0 = No, 1 = Sí
; Bit 2 -> se deben mover los enemigos      0 = No, 1 = Sí
; Bit 3 -> cambia dirección enemigos        0 = No, 1 = Sí
; Bit 4 -> mover disparo enemigo            0 = No, 1 = Sí
; Bit 5 -> mute                             0 = No, 1 = Sí
; -----------------------------------------------------------------------------
flags:
db $00
; -----------------------------------------------------------------------------
; Indicadores de la música
;
; Bit 0 a 3 -> Ritmo
; Bit 7 -> suena canción    0 = No, 1 = Sí
; -----------------------------------------------------------------------------
music:
db $00

Main:
ld      a, $02
call    OPENCHAN                    ; Abre el canal 2, pantalla superior

ld      hl, udgsCommon              ; Apunta HL a la dirección de los UDG
ld      (UDG), hl                   ; Cambia la dirección de los UDG

ld      hl, ATTR_P                  ; Apunta HL a la dirección de los atributos permanentes
ld      (hl), $07                   ; Pone la tinta en blanco y fondo en negro
call    CLS                         ; Limpia la pantalla

xor     a                           ; A = 0
out     ($fe), a                    ; Borde = negro
ld      a, (BORDCR)                 ; Carga el valor de BORDCR en A
and     $c0                         ; Se queda con brillo y flash
or      $05                         ; Pone la tinta a 5 y el fondo a 0
ld      (BORDCR), a                 ; Actualiza BORDCR

di                                  ; Desactiva la interrupciones
ld      a, $28                      ; Carga 40 en A
ld      i, a                        ; Lo carga en el registro I
im      2                           ; Pasa a modo 2 de interrupciones
ei                                  ; Activa las interrupciones

Main_start:
ld      hl, enemiesCounter          ; Apunta HL al contador de enemigos
ld      de, enemiesCounter + $01    ; Apunta DE al contador de niveles
ld      (hl), $00                   ; Pone a cero el contado de enemigos
ld      bc, $08                     ; Carga en BC el número de bytes a limpiar
ldir                                ; Limpia los bytes
ld      a, $05  
ld      (livesCounter), a           ; Pone el contador de vidas a 5

call    ResetEnemiesFire            ; Inicializa los disparos enemigos
call    ChangeLevel                 ; Cambia de nivel
call    PrintFirstScreen            ; Pinta la pantalla de menú y espera
call    SetHardness                 ; Asigna la dificultad
call    PrintFrame                  ; Pinta el marco
call    PrintInfoGame               ; Pinta los títulos de información de la partida
call    PrintShip                   ; Pinta la nave
call    PrintInfoValue              ; Pinta la información de la partida

call    LoadUdgsEnemies             ; Carga los enemigos
call    PrintEnemies                ; Los pinta
; Retardo
call    Sleep                       ; Produce un retardo antes de empezar el nivel

; Bucle principal
Main_loop:
rst     $38                         ; Actualiza las variables de sistema
ld      hl, FLAGS_KEY		        ; Carga en HL la dirección de los indicadores del teclado
set	    $03, (hl)		            ; Pone entrada en modo L
bit     $05, (hl)                   ; Comprueba si se ha pulsado una tecla
jr      z, main_loopCheck           ; Si no se ha pulsado, salta
res     $05, (hl)                   ; Es necesario poner el bit a 0 para futuras inspecciones
ld      a, (LAST_KEY)               ; Carga en A la última tecla pulsada
cp      'M'                         ; Comprueba si ha pulsado la M
jr      z, main_loopMute            ; Si se ha pulsado la M, salta
cp      'm'                         ; Comprueba si ha pulsado la m
jr      nz, main_loopCheck          ; Si no se ha pulsado la m, salta
main_loopMute:
ld      a, (flags)                  ; Carga en A los indicadores
xor     $20                         ; Invierte el bit 5 (mute)
ld      (flags), a                  ; Actualiza el valor en memoria

main_loopCheck:
call    CheckCtrl                   ; Comprueba la pulsación de los controles
call    MoveFire                    ; Muevo el disparo

push    de                          ; Preserva DE
call    CheckCrashFire              ; Evalúa las colisiones entre enemigos y disparo
pop     de                          ; Recupera DE

ld      a, (enemiesCounter)         ; Carga el número de enemigos activos en A
or      a                           ; Comprueba si es 0
jr      z, Main_restart             ; Si es 0 salta

call    MoveShip                    ; Mueve la nave
call    ChangeEnemies               ; Cambia la dirección de los enemigos si procede
call    MoveEnemies                 ; Mueve los enemigos
call    MoveEnemiesFire             ; Mueve los disparos de los enemigos
call    CheckCrashShip              ; Evalúa las colisiones entre la nave
                                    ; y los enemigos y sus disparos
ld      hl, music                   ; Apunta HL a los indicadores para la música
bit     $07, (hl)                   ; Evalúa si debe sonar una nota
jr      z, main_loopCont            ; Si no debe sonar, salta
res     $07, (hl)                   ; Desactiva el bit siete de music
call    Play                        ; Hace sonar la nota

main_loopCont:
ld      a, (livesCounter)           ; Carga las vidas en A
or      a                           ; Comprueba si están a cero
jr      z, GameOver                 ; Si están a cero salta, ¡GAME OVER!

jr      Main_loop                   ; Bucle principal

Main_restart:
ld      a, (levelCounter)           ; Carga el número de nivel en A
cp      $1e                         ; Comprueba si es el 31 (tenemos 30)
jr      z, Win                      ; Si es el 31 salta, ¡VICTORIA!

ld      a, (hardness)               ; Carga la dificultad en A
cp      $04                         ; Comprueba si es 4
jr      nz, main_restartCont        ; Si no es 4, salta
ld      a, $05                      ; Carga 5 en A
ld      (livesCounter), a           ; Pone cinco vidas

main_restartCont:
call    FadeScreen                  ; Hace el fundido de la pantalla
call    ChangeLevel                 ; Cambia de nivel
call    PrintFrame                  ; Pinta el marco
call    PrintInfoGame               ; Pinta los títulos de información
call    PrintShip                   ; Pinta la nave
call    PrintInfoValue              ; Pinta la información
call    PrintEnemies                ; Pinta los enemigos
call    ResetEnemiesFire            ; Reinicia los disparos de los enemigos

; Retardo
call    Sleep                       ; Produce un retardo
jp      Main_loop                   ; Bucle principal

; ¡GAME OVER!
GameOver:
xor     a                           ; Pone A = 0
call    PrintEndScreen              ; Pinta la pantalla de fin y espera
jp      Main_start                  ; Menú principal

; ¡VICTORIA!
Win:
ld      a, $01                      ; Pone A = 1
call    PrintEndScreen              ; Pinta la pantalla de fin y espera
jp      Main_start                  ; Menú principal

include "Const.asm"
include "Var.asm"
include "Graph.asm"
include "Print.asm"
include "Ctrl.asm"
include "Game.asm"

end     Main