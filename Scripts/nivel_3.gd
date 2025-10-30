extends Node2D

# Esta variable quedará vacía en el script para que la llenes desde el editor.
@export var player_scene: PackedScene

func _ready():
	# Instanciamos la escena que asignaste en el Inspector.
	var player = player_scene.instantiate()
	
	# Buscamos la posición del marcador.
	var start_position = $PlayerStart.position
	
	# Colocamos al jugador en su sitio.
	player.position = start_position
	
	# Y lo añadimos a la escena.
	add_child(player)
