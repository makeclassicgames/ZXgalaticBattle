;direccion graficos definidos por usuario
UDG: EQU $5c7b ; Espacio de los graficos
;direccion llamada OPENCHAN
OPENCHAN: EQU $1601 ;Rutina cambio color

ATTR_P: EQU $5c8d ;atributos de color de fondo
ATTR_T: EQU $5c8f ;Variable de sistema color de tinta

CLS: EQU $0daf; Rutina de borrado
BORDCR: EQU $5c48; Color de borde

;Constantes de posicionamiento
COR_X: EQU $20; Coordenada x esquina superior izquierda
COR_Y: EQU $18; Coordenada y esquina superior izquierda
MIN_X: EQU $00; A restar de COR_X para x esquina superior izquierda
MIN_Y: EQU $00; A restar de COR_Y para y esquina superior izquierda
MAX_X: EQU $1f; A restar de COR_X para x esquina inferior derecha
MAX_Y: EQU $15; A restar de COR_Y para y esquina inferior derecha

WHITE_GRAPH: EQU $9e ; caracter en blanco
;Constante nave
SHIP_GRAPH: EQU $90 ; Gráfico nave
SHIP_INI: EQU $0511 ; Posicion inicial nave (x,y)
SHIP_TOP_L: EQU $1e ;
SHIP_TOP_R: EQU $01