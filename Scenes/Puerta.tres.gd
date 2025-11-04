#Script para la puerta del nivel 1, el personaje al colisionar con ella ingresa a la escena de juego de memoria animales
extends Area2D

func _ready():
	set_process(false)

func _on_body_entered(_body: Node2D):
	set_process(true)

func _on_body_exited(_body):
	set_process(false)

func _process(_delta):
	# Se genera un condicional para cuando el juego dectecte el enter o el botón de accept y se dirija al personaje a la siguiente escena
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
