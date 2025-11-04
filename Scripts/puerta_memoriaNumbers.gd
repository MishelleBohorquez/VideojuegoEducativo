#Script de puerta hacia el GameNumbers
extends Area2D

func _ready():
	set_process(false)

func _on_body_entered(_body: Node2D):
	set_process(true)

func _on_body_exited(_body):
	set_process(false)

func _process(_delta):
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene_to_file("res://Scenes/GameNumbers.tscn")
