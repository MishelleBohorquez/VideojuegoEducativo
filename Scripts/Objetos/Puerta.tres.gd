extends Area2D

func _ready():
	# Desactivamos el procesamiento por defecto.
	set_process(false)

func _on_body_entered(_body: Node2D):
	# Activamos el procesamiento solo cuando el jugador entra.
	set_process(true)

func _on_body_exited(_body):
	# Lo desactivamos de nuevo cuando el jugador se va.
	set_process(false)

func _process(_delta):
	# Ya no es necesario preguntar "if entered == true"
	# porque esta función solo se ejecutará cuando el jugador esté dentro.
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene_to_file("res://Scenes/Nivel2.tscn")
