;rutinas controles
;comprobacion controles
checkCtrl:
ld d,$00
ld a,$fe
in a,($fe)
checkCtrl_fire: ; comprobar disparo
bit $04,a
jr nz,checkCtrl_left
set $02,d
checkCtrl_left:; comprobar izquierda
bit $01,a
jr nz, checkCtrl_right
set $00,d
checkCtrl_right:; comprobar derecha
bit $02,a
ret nz
set $01,d
checkCtrl_testLR:
ld a,d
and $03
sub $03
ret nz
ld a,d
and $04
ld d,a
checkCtrl_end:
ret