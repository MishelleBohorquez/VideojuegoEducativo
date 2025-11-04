#Script Nivel 4
extends Node2D

@export var player_scene: PackedScene

func _ready():
	var player = player_scene.instantiate()
	
	var start_position = $PlayerStart.position
	
	player.position = start_position
	
	add_child(player)
