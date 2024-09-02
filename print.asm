; -----------------------------------------------------------------------------
; Borra un carácter de la pantalla
;
; Entrada:  BC -> Coordenadas Y/X del carácter
; Altera el valor de los resgistros AF
; -----------------------------------------------------------------------------
DeleteChar:
call    At              ; Llama a posicionar el cursor

ld      a, WHITE_GRAPH  ; Carga en A el carácter de blanco
rst     $10             ; Lo pinta y borra la nave

ret

; -----------------------------------------------------------------------------
; Pinta los enemigos
;
; Altera el valor de los registros AF, BC, D y HL.
; -----------------------------------------------------------------------------
PrintEnemies:
ld      a, $06                      ; Carga en A la tinta amarilla        
call    Ink                         ; Cambia la tinta

ld      hl, enemiesConfig           ; Carga la dirección de la configuración 
                                    ; del enemigo en HL
ld      d, $14                      ; Carga en D 20 enemigos

printEnemies_loop:
bit     $07, (hl)                   ; Evalúa si el enemigo está activo
jr      z, printEnemies_endLoop     ; Si no lo está, salta

push    hl                          ; Preserva el valor de HL

ld      a, (hl)                     ; Carga el primer byte de configuración en A
and     $1f                         ; Se queda con la coordenda Y
ld      b, a                        ; La carga en B

inc     hl                          ; Apunta HL al segundo byte
ld      a, (hl)                     ; Carga el valor en A
and     $1f                         ; Se queda con la coordenada X
ld      c, a                        ; La carga en C
call    At                          ; Posiciona el cursor

ld      a, (hl)                     ; Vuelve a cargar el segudo byte en A
and     $c0                         ; Se queda con la dirección (izquierda ...)
rlca                                ; Pone el valor en los bits 0 y 1
rlca
ld      c, a                        ; Carga el valor en C
ld      b, $00                      ; Pone B a cero

ld      hl, enemiesGraph            ; Carga en HL el carácter del gráfico del enemigo
add     hl, bc                      ; Le suma la dirección de enemigo (izquierda ...)
ld      a, (hl)                     ; Carga en A el gráfico del enemigo
rst     $10                         ; Lo pinta

pop      hl                         ; Recupera el valor de HL

printEnemies_endLoop:
inc     hl                          ; Apunta HL al primer byte de la configuración
inc     hl                          ; del enemigo siguientes

dec     d                           ; Decrementa D
jr      nz, printEnemies_loop       ; hasta que D sea 0

ret

; -----------------------------------------------------------------------------
; Pinta el disparo en la posición actual.
;
; Altera el valor de los registros AF y BC.
; -----------------------------------------------------------------------------
PrintFire:
ld      a, $02          ; Carga en A la tinta roja
call    Ink             ; Llama al cambio de tinta

ld      bc, (firePos)   ; Carga en BC la posición actual del disparo
call    At              ; Llama a posicionar el cursor

ld      a, FIRE_GRAPH   ; Carga en A el carácter del fuego
rst     $10             ; Lo pinta

ret

; -----------------------------------------------------------------------------
; Pinta el marco de la pantalla.
;
; Altera el valor de los registros HL, B y AF.
; -----------------------------------------------------------------------------
PrintFrame:
ld      hl, frameTopGraph       ; Carga en HL la dirección de la parte superior
call    PrintString             ; Pinta la cadena

ld      hl, frameBottomGraph    ; Carga en HL la dirección de la parte inferior
ld      b, frameEnd - frameBottomGraph  ; Carga en B la longitud
call    PrintString             ; Pinta la cadena

ld      b, COR_Y - $01          ; Apunta B a la línea 1
printFrame_loop:
ld      c, COR_X - MIN_X        ; Apunta C a la columna 0
call    At                      ; Posiciona el cursor
ld      a, $99                  ; Carga en A el carácter lateral izquierdo
rst     $10                     ; Lo pinta

ld      c, COR_X - MAX_X        ; Apunta C a la columna 31
call    At                      ; Posiciona el cursor
ld      a, $9a                  ; Carga en A el carácter lateral derecho
rst     $10                     ; Lo pinta

dec     b                       ; Decrementa B
ld      a, COR_Y - MAX_Y + $01  ; Apunta A a la línea 20
sub     b                       ; Resta la siguiente línea
jr      nz, printFrame_loop     ; Si el resultado no es cero, sigue con el bucle

ret

; -----------------------------------------------------------------------------
; Pinta los títulos de información de la partida.
; Altera el valor de los registros A, C y HL.
; -----------------------------------------------------------------------------
PrintInfoGame:
ld      a, $01          ; Carga 1 en A
call    OPENCHAN        ; Activa el canal 1, línea de comando
ld      hl, infoGame    ; Carga la dirección de la cadena de títulos en HL
call    PrintString     ; Pinta la cadena de títulos
ld      a, $02          ; Carga 2 en A
call    OPENCHAN        ; Activa el canal 2, pantalla superior

ret

; -----------------------------------------------------------------------------
; Pinta la nave en la posición actual.
; Altera el valor de los registros A y BC.
; -----------------------------------------------------------------------------
PrintShip:
ld      a, $07          ; Carga en A la tinta blanca
call    Ink             ; Llama al cambio de tinta

ld      bc, (shipPos)   ; Carga en BC la posición actual de la nave
call    At              ; Llama a posicionar el cursor

ld      a, SHIP_GRAPH   ; Carga en A el carácter de la nave
rst     $10             ; La pinta

ret

; -----------------------------------------------------------------------------
; Pinta cadenas.
;
; Entrada:  HL = primera posición de memoria de la cadena
;           B  = longitud de la cadena.
; Altera el valor de los registros AF, B y HL
; -----------------------------------------------------------------------------
PrintString:
ld      a, (hl)         ; Carga en A el carácter a pintar
cp     $ff              ; compara si es $ff
ret z                   ; en caso de 0, salir
rst $10                 ; imprimir caracter
inc hl                  ; siguiente caracter
jr    PrintString     ; vuelve a llamar a la rutina (recursividad)

ret
;mostrar explosion
PrintExplosion:
ld a,$02    ;cargar color 02 (rojo)
call Ink    ; cambiar tinta

ld bc,(shipPos) ;cargar posicion nave
ld d,$04        ; cargar valor 04 en d (contador)
ld e,$92        ; cargar valor 92 en e
PrintExplosion_loop:
call At         ; posicionar cursor
ld a,e          ; copiar e en a
rst $10         ; imprimir caracter
;esperar 4 operaciones
halt
halt
halt
halt
inc e           ; incrementar e (siguiente animacion)
dec d           ; decrementar d
jr nz, PrintExplosion_loop  ; si no es 0, continuar bucle
jp PrintShip    ; volver a imprimir nave

printBCD:
ld  a,(hl)
and $f0
rra
rra
rra
rra
add a,'0'
rst $10
ld a,(hl)
and $0f
add a,'0'
rst $10
ret
;pintar valores con informacion
printInfoValue:
ld a,$01
call OPENCHAN
ld bc, COR_LIVE
call At
ld hl, livesCounter
call printBCD

ld bc, COR_POINT
call At
ld hl, pointsCounter+1
call printBCD
ld hl, pointsCounter
call printBCD


ld bc, COR_LEVEL
call At
ld hl, levelCounter+1
call printBCD

ld bc, COR_ENEMY
call At
ld hl, enemiesCounter
call printBCD

ld a,$02
call OPENCHAN

ret
; -----------------------------------------------------------------------------
; Pantalla de presentación y selección de controles.
;
; Altera el valor de los registros AF y HL.
; -----------------------------------------------------------------------------
PrintFirstScreen:
call    CLS                 ; Limpia la pantalla
ld      hl, title           ; Carga en HL la definición del título
call    PrintString         ; Pinta el título
ld      hl, firstScreen     ; Carga en HL la definición de la pantalla
call    PrintString         ; Pinta la pantalla

printFirstScreen_op:
ld      a, $f7              ; Cara en A la semifila 1-5
in      a, ($fe)            ; Lee el teclado
ld      b,$01               ; opcion teclado
rra
jr nc, printFirstScreen_end ; si no hay acarreo ir a final
inc b                       ; incrementar b
rra
jr nc, printFirstScreen_end ; acarreo? ir al final
inc b                       ; incrementar b
rra                         ; rotar
jr nc, printFirstScreen_end ; si acarreo ir al final (sinclair 2)
inc b                       ; incrementar B 
rra                         ; rotar
jr c, printFirstScreen_op   ; si no se ha pulsado salir en caso contrario 4

printFirstScreen_end:
ld a,b                      ; copiar b en a
ld (controls),a             ; almacenar opcion teclado
call    FadeScreen          ; Fundido de pantalla

ret

; -----------------------------------------------------------------------------
; Pantalla de fin de partida.
;
; Entrada:  A -> Tipo de fin, 0 = Game Over, !0 = Win.
;
; Altera e vakir de los registros AF y HL.
; -----------------------------------------------------------------------------
PrintEndScreen:
push    af                      ; Preserva el valo de AF
call    FadeScreen              ; Fundido de pantalla
ld      hl, title               ; Apunta HL al título
call    PrintString             ; Pinta el título
pop     af                      ; Recupera el valor de AF
or      a                       ; Evalúa si A vale 0
jr      nz, printEndScreen_Win  ; Si no vale 0, salta

printEndScreen_GameOver:
ld      hl, gameOverScreen      ; Apunta HL a la pantalla de Game Over
call    PrintString             ; La pinta
jr      printEndScreen_WaitKey  ; Salta a esperar pulsación de Enter

printEndScreen_Win:
ld      hl, winScreen           ; Apunta HL a la pantalla de Win
call    PrintString             ; La pinta

printEndScreen_WaitKey:
ld      hl, pressEnter          ; Apunta HL a la cadena 'Pulse Enter'
call    PrintString             ; La pinta
call    PrintInfoGame           ; Pinta los títulos de información de la partida
call    printInfoValue          ; Pinta los datos de la partida

printEndScreen_WaitKeyLoop:
ld      a, $bf                  ; Carga a semifila 1-5 en A
in      a, ($fe)                ; Lee el teclado
rra                             ; Rota A a la derecha para ver estado del uno
jr      c, printEndScreen_WaitKeyLoop   ; Si hay acarreo no se ha pulsado, bucle
call    FadeScreen              ; Fundido de pantalla

ret 