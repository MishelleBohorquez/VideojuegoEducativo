#Script en donde si el jugador toca la zona de daño lo retorna a el inicio de la escena donde se encuentres
extends Area2D

func _on_body_entered(body):
	get_tree().reload_current_scene()
