extends Node

var puntuacion = 0

@onready var zanahoria_nivel2: Label = $PuntuaciónZanahoria2

signal puntuacion_actualizada(puntuacion_actual:int)

func incrementa_un_punto():
	puntuacion +=1
	puntuacion_actualizada.emit(puntuacion)
	zanahoria_nivel2.text = str(puntuacion)
