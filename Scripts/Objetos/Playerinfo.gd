extends CanvasLayer

func _ready():
	if get_parent().has_node("Jugador"):
		$health_ProgressBar. value = get_parent().get_node("Jugador").health

#En cada frame actualiza el valor		
func _process(delta):
	$health_ProgressBar. value = get_parent().get_node("Jugador").health
	
