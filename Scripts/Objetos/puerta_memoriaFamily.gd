# Script de conexión a la escena de GameColors
extends Area2D
@export var escena_objetivo: String = "res://Scenes/GameColors.tscn"

func _ready():
		set_process(false)

func _on_body_entered(body: Node2D):
	
	if body.is_in_group("Player"):
		set_process(true)
		

func _on_body_exited(body: Node2D):
	
	if body.is_in_group("Player"):
		set_process(false)
		

func _process(_delta):
	
	if Input.is_action_just_pressed("accept"):
		# Cambiamos a la escena de colores
		get_tree().change_scene_to_file("res://Scenes/GameColors.tscn")
