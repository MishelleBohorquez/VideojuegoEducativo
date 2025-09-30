# res://Scripts/character.gd
extends Area2D

# Una "señal" es un mensaje que este nodo puede enviar.
# Le decimos que el mensaje se llamará "character_selected" y que llevará un dato: el nombre del personaje.
signal character_selected(character_name)

# Variable para guardar el nombre de este personaje (ej. "CAT").
var my_name = ""

# Esta función se activa cuando se hace clic dentro del área de colisión.
func _on_input_event(viewport, event, shape_idx):
	# Si el evento es un clic izquierdo del mouse y se acaba de presionar...
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# ...enviamos la señal con nuestro nombre.
		emit_signal("character_selected", my_name)

# Una función pública para configurar el personaje desde la escena principal.
func setup(char_name, char_texture_path):
	my_name = char_name
	$Sprite2D.texture = load(char_texture_path)
