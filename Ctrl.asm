; -----------------------------------------------------------------------------
; Evalúa si se ha pulsado alguna de la teclas de dirección.
; Las teclas de dirección son:
;	Z 	->	Izquierda
;	X 	->	Derecha
;	V	->	Disparo
;
; Kempston, Sinclair 1 y Sinclair 2
;
; Retorna:	D	->	Teclas pulsadas.
;			Bit 0	->	Izquierda
;			Bit 1	->	Derecha
;			Bit 2	->	Disparo
;
; Altera el valor de los registros A y D
; -----------------------------------------------------------------------------
CheckCtrl:
;;;;;;;; I-NEW-03
;;;;;;;ld      a, $7f                  ; Carga la semifila Space-N en A
;;;;;;;in      a, ($fe)                ; Lee el teclado
;;;;;;;bit     $03, a                  ; Evalúa si se ha pulsado la M
;;;;;;;jr      nz, checkCtrl_cont      ; Salta si no se ha pulsado
;;;;;;;ld      a, (music)              ; Carga en A los indicadores para la música
;;;;;;;xor     $40                     ; Invierte el bit 6 (mute)
;;;;;;;ld      (music), a              ; Actualiza el valor en memoria
;;;;;;;checkCtrl_cont:
;;;;;;;; F-NEW-03
ld      d, $00                  ; Pone D a 0
ld      a, (controls)           ; Carga en A la selección de controles
dec     a                       ; Decrementa A
jr      z, checkCtrl_Keys       ; Si es 0 salta a control teclado
dec     a                       ; Decrementa A
jr      z, checkCtrl_Kempston   ; Si es 0 salta a control Kempston
dec     a                       ; Decrementa A
jr      z, checkCtrl_Sinclair1  ; Si es 0 salta a control Sinclair 1

; Control Sinclair 2
checkCtrl_Sinclair2:
ld      a, $f7                  ; Carga la semifila 1-5 en A
in      a, ($fe)                ; Lee el teclado
checkCtrl_Sinclair2_left:
rra                             ; Rota A para comprobar izquierda
jr      c, checkCtrl_Sinclair2_right ; Si hay acarreo, no pulsado, salta
set     $00, d                  ; Si no hay acarreo, activa bit izquierda
checkCtrl_Sinclair2_right:
rra                             ; Rota A para comprobar derecha
jr      c, checkCtrl_Sinclair2_fire ; Si hay acarreo, no pulsado, salta
set     $01, d                  ; Si no hay acarreo, activa bit derecha
checkCtrl_Sinclair2_fire:
and     $04                     ; Comprueba si el disparo está activo
ret     nz                      ; Si no es cero, no pulsado, sale
set     $02, d                  ; Si es cero, activa bit disparo
ret                             ; Sale

; Control Kempston
checkCtrl_Kempston:
in      a, ($1f)                ; Lee el puerto 31
checkCtrl_Kempston_right:
rra                             ; Rota A para comprobar derecha   
jr      nc, checkCtrl_Kempston_left ; Si no hay acarreo, no pulsado, salta
set     $01, d                  ; Si hay acarreo, activa bit derecha
checkCtrl_Kempston_left:
rra                             ; Rota A para comprobar izquierda
jr      nc, checkCtrl_Kempston_fire ; Si no hay acarreo, no pulsado, salta
set     $00, d                  ; Si hay acarreo, activa bit izquierda
checkCtrl_Kempston_fire:
and     $04                     ; Comprueba si el disparo está activo
ret     z                       ; Si es cero, no pulsado, sale
set     $02, d                  ; Si no es cero, activa bit disparo
ret                             ; Sale

; Control Sinclair 1
checkCtrl_Sinclair1:
ld      a, $ef                  ; Carga la semifila 0-6 en A
in      a, ($fe)                ; Lee el teclado
checkCtrl_Sinclair1_fire:
rra                             ; Rota A para comprobar disparo
jr      c, checkCtrl_Sinclair1_right    ; Si hay acarreo, no pulsado, salta
set     $02, d                  ; Si no hay acarreo, activa bit disparo
checkCtrl_Sinclair1_right:
rra
rra
rra                             ; Rota A para comprobar derecha
jr      c, checkCtrl_Sinclair1_left ; Si hay acarreo, no pulsado, salta
set     $01, d                  ; Si no hay acarreo, activa bit derecha
checkCtrl_Sinclair1_left:
rra                             ; Rota A para comprobar izquierda
ret     c                       ; Si hay acarreo, no pulsado, sale
set     $00, d                  ; Si no hay acarreo, activa bit izquierda
ret                             ; Sale

checkCtrl_Keys:
ld      a, $fe                  ; Carga la semifila Cs-V en A
in      a, ($fe)                ; Lee el teclado
checkCtrl_Key_left:
rra
rra                             ; Rota A para comprobar izquierda            
jr      c, checkCtrl_right      ; Si hay acarreo, no pulsado, salta
set     $00, d                  ; Si no hay acarreo, activa bit izquierda
checkCtrl_right:
rra                             ; Rota A para comprobar derecha
jr      c, checkCtrl_fire       ; Si hay acarreo, no pulsado, salta 
set     $01, d                  ; Si no hay acarreo, activa bit derecha
checkCtrl_fire:
and     $02                     ; Comprueba si el disparo está activo
ret     nz                      ; Si no es cero, no pulsado, sale
set     $02, d                  ; Si es cero, activa bit disparo
ret                             ; Sale