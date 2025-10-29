extends Area2D

# Esta función se conectará a la señal 'body_entered'
func _on_body_entered(body):
	# Esta línea recarga la escena actual (reinicia el nivel)
	get_tree().reload_current_scene()
