extends Control

@onready var botones_menu: VBoxContainer = $BotonesMenu
@onready var boton_options: Panel = $BotonOptions

	
func _ready() -> void:
	botones_menu.visible = true
	boton_options.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel1.tscn")


func _on_options_pressed() -> void:
	print("Options presionado")
	botones_menu.visible = false
	boton_options.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_options_pressed() -> void:
	_ready()
