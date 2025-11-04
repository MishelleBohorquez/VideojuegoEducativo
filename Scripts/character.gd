# Script para la selección de pesonaje en el test
extends Area2D


signal character_selected(character_name)

var my_name = ""


func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		
		emit_signal("character_selected", my_name)


func setup(char_name, char_texture_path):
	my_name = char_name
	$Sprite2D.texture = load(char_texture_path)
