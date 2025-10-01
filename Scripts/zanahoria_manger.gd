extends Node

var puntuacion = 0

@onready var etiqueta_puntuacion: Label = $EtiquetaPuntuacion

signal puntuacion_actualizada(puntuacion_actual:int)

func incrementa_un_punto():
	puntuacion +=1
	puntuacion_actualizada.emit(puntuacion)
	etiqueta_puntuacion.text = str(puntuacion)
