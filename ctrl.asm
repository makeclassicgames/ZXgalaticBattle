; -----------------------------------------------------------------------------
; Evalúa si se ha pulsado alguna de la teclas de dirección.
; Las teclas de dirección son:
;	Z 	->	Izquierda
;	X 	->	Derecha
;	V	->	Disparo
;
; Retorna:	D	->	Teclas pulsadas.
;			Bit 0	->	Izquierda
;			Bit 1	->	Derecha
;			Bit 2	->	Disparo
;
; Altera el valor de los registros A y D
; -----------------------------------------------------------------------------
CheckCtrl:
ld      d, $00              ; Pone D a 0
ld      a, $fe              ; Carga la semifila Cs-V en A
in      a, ($fe)            ; Leee el teclado

checkCtrl_fire:
bit     $04, a              ; Evalúa si se ha pulsado la V
jr      nz, checkCtrl_left  ; Si no se ha pulsado, salta
set     $02, d              ; Activa el bit 2 de D

checkCtrl_left:
bit     $01, a              ; Evalúa si se ha pulsado la Z
jr      nz, checkCtrl_right ; Si no se ha pulsado, salta
set     $00, d              ; Activa el bit 0 de D

checkCtrl_right:
bit     $02, a              ; Evalúa si se ha pulsado la X
ret     nz                  ; Si no se ha pulsado, sale
set     $01, d              ; Activa el bit 1 de D

checkCtrl_testLR:
ld      a, d                ; Carga el valor de D en A
and     $03                 ; Se queda con el valor de los bits 0 y 1
sub     $03                 ; Comprueba si están activos los dos bits
ret     nz                  ; Si el resultad no es cero, no están
                            ; activos los dos bits y sale
ld      a, d                ; Carga el valor de D en A
and     $04                 ; Desactiva los bits 0 y 1
ld      d, a                ; Carga el valor de A en D

checkCtrl_end:
ret