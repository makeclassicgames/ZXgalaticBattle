ORG $5dad; compatible with 16K

Main:
ld      a, $02 ; Cambio modo activo pantalla
call    OPENCHAN ; llamada a openchan

ld      hl, udgsCommon ; carga de los gráficos
ld      (UDG), hl ; carga en UDG

ld      hl, ATTR_P ; cargar variable sistema para borde
ld      (hl), $07 ; cambio color
call    CLS; borrado pantalla

xor     a ; cambio de color de borde
out     ($fe), a ;llamada a pantalla (puerto)
ld      a, (BORDCR) ; carga del valor del borde a la pantalla
and     $c7
or      $07
ld      (BORDCR), a; cambio color borde

call    PrintFrame ;llamada para imprimir borde
call    printInfoGame ; llamada para imprimir informacion juego
call    printShip ; imprimir nave

Main_loop:
call    checkCtrl ; comprobar controles
call    moveShip ; mover nave
jr      Main_loop ; bucle principal
ret

;Incluir ficheros
include "Const.asm"
include "Var.asm"
include "graph.asm"
include "print.asm"
include "ctrl.asm"
include "game.asm"
end Main