#Script para el nivel 2 de plataforma
extends Node2D

# Se habilita para que desde la interfaz se pueda la escena de conexión
@export var player_scene: PackedScene

func _ready():
	#Configuración de posición del jugador en la escena
	var player = player_scene.instantiate()
	
	var start_position = $PlayerStart.position
	
	player.position = start_position
	
	add_child(player)
