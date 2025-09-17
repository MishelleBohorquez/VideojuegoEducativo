extends Area2D

var entered = false

func _on_body_entered(body: Node2D):
	entered = true

func _on_body_exited(body) :
	entered = false

func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("accept"):
			get_tree().change_scene_to_file("res://Scenes/Nivel2.tscn")
