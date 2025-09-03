extends Node2D


func _on_area_2d_body_entered(body):
	# Verifica si el objeto que entra es el jugador
	if body.name == "Player":
		# Cambia a la siguiente escena
		get_tree().change_scene_to_file(""res://MundoTierra/background.png"")
