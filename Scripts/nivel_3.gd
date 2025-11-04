#Script Nivel 3
extends Node2D

@export var player_scene: PackedScene

func _ready():
	var player = player_scene.instantiate()
	
	
	var start_position = $PlayerStart.position
	
	
	player.position = start_position
	
	
	add_child(player)


func _on_sierra_player_hit() -> void:
	get_tree().reload_current_scene()
