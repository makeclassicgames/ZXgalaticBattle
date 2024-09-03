org     $7e5c

FLAGS:  EQU $5dfc   ; Indicadores generales
MUSIC:  EQU $5dfd   ; Indicadores para la música
T1:     EQU $c8     ; Interrupciones para activar el cambio de dirección de enemigos

Isr:
push    hl
push    de
push    bc
push    af                  ; Preserva el valor de los registros

ld      hl, FLAGS           ; Apunta HL a los indicadores
set     $00, (hl)           ; Activa el bit 0, mover nave

ld      a, (countEnemy)     ; Carga en A el contador para mover los enemigos
inc     a                   ; Lo incrementa
ld      (countEnemy), a     ; Lo actualiza
sub     $03                 ; Le resta 3
jr      nz, Isr_T1          ; Si el valor no es cero, salta
ld      (countEnemy), a     ; Pone el contador a cero
set     $02, (hl)           ; Activa el bit 2 de los indicadores, mover enemigos 
set     $04, (hl)           ; Activa el bit 4, mover disparo enemigo

; Cambio de dirección de los enemigos
Isr_T1:
ld      a, (countT1)        ; Carga en A el contador para cambiar la dirección
inc     a                   ; Lo incrementa
ld      (countT1), a        ; Lo actualiza en memoria
sub     T1                  ; Le resta las interrupciones que tienen que pasar
jr      nz, Isr_sound       ; Si el valor no es cero, salta
ld      (countT1), a        ; Pone el contador a cero
set     $03, (hl)           ; Activa el bit 3 de los indicadores, cambiar dirección enemigos

; Sonido
Isr_sound:
bit     $05, (hl)           ; Evalúa si el bit 5 (mute) está activo
jr      nz, Isr_end         ; Si lo está, salta
ld      a, (MUSIC)          ; Carga en A el valor de los indicadores para la música
and     $0f                 ; Se queda con el ritmo
ld      hl, tempo           ; Apunta HL al ritmo actual
cp      (hl)                ; Lo compara con los indicadores para la música
jr      z, Isr_soundCont    ; Si son iguales, salta
ld      (hl), a             ; Si son distintos, actualiza el ritmo actual
jr      Isr_soundEnd        ; Salta para hacer sonar la nota

Isr_soundCont:
ld      a, (countTempo)     ; Carga en A el valor del contador del ritmo
inc     a                   ; Lo incrementa              
ld      (countTempo), a     ; Lo actualiza en memoria
cp      (hl)                ; Lo compara con el ritmo actual
jr      nz, Isr_end         ; Si son distintos, salta

Isr_soundEnd:
xor     a                   ; Pone A = 0
ld      (countTempo), a     ; Pone el contador de ritmo a 0
ld      hl, MUSIC           ; Apunta HL a los indicadores para la música
set     $07, (hl)           ; Activa el bit 7, sonar

Isr_end:
pop     af
pop     bc
pop     de
pop     hl                  ; Recupera los valores de los registros
ei                          ; Activa las interrupciones
reti                        ; Sale

; Contador para cambio de dirección de los enemigos
countT1:    db $00
; Contador para movimiento de los enemigos
countEnemy: db $00
; Contador para hacer sonar notas
countTempo: db $00
; Ritmo actual
tempo:      db $00