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
ld      b, frameBottomGraph - frameTopGraph ; Carga en B la longutid
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
ld      b, infoGame_end - infoGame  ; Carga la longitud en B
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
rst     $10             ; Pinta el carácter
inc     hl              ; Apunta HL al siguiente carácter
djnz    PrintString     ; Hasta que B valga 0

ret