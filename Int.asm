org     $7e5c
;rutina de interrupcion
Isr:
; almacenamos los registros HL, DE, BC y AF
push    hl
push    de
push    bc
push    af
;cargamos la direccion de flags (no usar la etiqueta debido a que esta definido en otro fichero)
ld      hl, $5dad
set     $00, (hl); establecer el bit 0

ld      a, (countEnemy) ; cargar el contador de enemigos
inc     a   ;incrementar el contador de enemigos
ld      (countEnemy), a ;almacenar el contador de enemigos
sub     $03 ;restar $03 a A
jr      nz, Isr_end ; en caso de no ser 0 ir al final de la rutina
ld      (countEnemy), a ; almacenar de nuevo el valor del contador de enemigos
set     $02, (hl)   ;establecer el bit 02 del valor de hl

Isr_end:
;reestablercer los registos AF, BC,DE y HL
pop     af
pop     bc
pop     de
pop     hl
;activar interrupciones
ei
; fin rutina interrupcion
reti
;variable contador
countEnemy: db $00