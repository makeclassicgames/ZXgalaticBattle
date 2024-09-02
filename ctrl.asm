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
ld      a,(controls)        ; carga en a el valor de controls
dec     a                   ; decrementa a
jr      z, checkCtrl_keys   ; si es 0 (pulsado 1 teclado) ir a control de teclas
dec     a                   ; decrementa a
jr      z, checkCtrl_kempston ; si es 0 (pulsado 3) ir a control
dec     a
jr      z, checkCtrl_sinclair1  ; control sinclari 1
; control sinclair2
checkCtrl_sinclair2:
ld      a, $f7              ; cargar dato
in      a, ($fe)            ;leer puerto
checkCtrl_sinclair2_left:
rra                         ; rotar derecha
jr      c, checkCtrl_sinclair2_right ; si acarreo comprobar derecha
set     $00, d              ; establecer bit izquierda 
checkCtrl_sinclair2_right:
rra                         ; rotar derecha
jr      c, checkCtrl_sinclair2_fire ; acarreo ir a disparo
set     $01,d               ; establecer bit derecha
checkCtrl_sinclair2_fire:
and     $04                 ; comprueba disparo
ret     nz                  ; si no ha pulsado sale
set     $02,d               ; establece bit disparo
ret                         ; salir rutina

; control Kempston
checkCtrl_kempston:
in      a, ($1f)            ; direccion puerto joystick
checkCtrl_kempston_right:
rra                         ; rotamos derecha
jr      nc, checkCtrl_kempston_left ; si no hay acarreo, ir a izquierda
set     $01,d               ; establecer bit derecha
checkCtrl_kempston_left:
rra                         ; rotar derecha
jr      nc,checkCtrl_kempston_fire  ; si no hay acarreo ir a disparo
set     $00,d               ; establecer bit izquierda
checkCtrl_kempston_fire:
and     $04                 ; comprueba disparo
ret     z                   ; si es 0 no ha pulsado; salir
set     $02,d               ;establecer bit disparo
ret                         ; salir
; control sinclair 1

checkCtrl_sinclair1:
ld      a, $ef              ; cargar dato
in      a, ($fe)            ;leer puerto
checkCtrl_sinclair1_fire:
rra                         ; rotar derecha
jr      c, checkCtrl_sinclair1_right ; si acarreo comprobar derecha
set     $02, d              ; establecer bit izquierda 
checkCtrl_sinclair1_right:
rra                         ; rotar derecha
rra                         ; rotar derecha
rra                         ; rotar derecha
jr      c, checkCtrl_sinclair1_left ; acarreo ir a disparo
set     $01,d               ; establecer bit derecha
checkCtrl_sinclair1_left:
rra
ret     c                  ; si no ha pulsado sale
set     $00,d               ; establece bit disparo
ret                         ; salir rutina

checkCtrl_keys:
ld      a, $fe              ; Carga la semifila Cs-V en A
in      a, ($fe)            ; Leee el teclado
checkCtrl_keys_left:
rra
rra
jr      c, checkCtrl_keys_right ; si hay acarreo ir derecha
set     $00, d              ;establecer bit izquierda
checkCtrl_keys_right:
rra                         ; rotar
jr      c, checkCtrl_keys_fire ; si hay acarreo ir a disparo
set     $01,d               ; establecer bit derecha
checkCtrl_keys_fire:
and     $02
ret     nz                  ; si no ha disparado, salir
set     $02,d               ; establece bit disparo
ret                         ;salir
