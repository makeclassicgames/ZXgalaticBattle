org     $7e5c

Isr:
push    hl
push    de
push    bc
push    af

ld      hl, $5dad
set     $00, (hl)

Isr_end:
pop     af
pop     bc
pop     de
pop     hl
ei
reti