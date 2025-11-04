# Script para dar información de la vida o la salud del jugador
extends CanvasLayer

func _ready():
	if get_parent().has_node("Jugador"):
		$health_ProgressBar. value = get_parent().get_node("Jugador").health

func _process(delta):
	$health_ProgressBar. value = get_parent().get_node("Jugador").health
	
