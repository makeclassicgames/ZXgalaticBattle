org     $7e5c

Isr:
push    hl
push    de
push    bc
push    af

ld      hl, $5dad
set     $00, (hl)

ld      a, (countEnemy)
inc     a
ld      (countEnemy), a
sub     $03
jr      nz, Isr_end
ld      (countEnemy), a
set     $02, (hl)

Isr_end:
pop     af
pop     bc
pop     de
pop     hl
ei
reti

countEnemy: db $00