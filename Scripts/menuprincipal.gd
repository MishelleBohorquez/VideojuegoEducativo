extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel1.tscn")


func _on_options_pressed() -> void:
	print("Options presionado")


func _on_exit_pressed() -> void:
	get_tree().quit()
