extends CanvasLayer

@onready var contador_zanahorias2: Label = $ContadorZanahoria2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var zanahoria_nivel2 = get_node("%ZanahoriaNivel2")
	zanahoria_nivel2.puntuacion_actualizada.connect(_on_puntuacion_actualizada)

func _on_puntuacion_actualizada(puntuacion_actual:int) -> void:
	contador_zanahorias2.text = str(puntuacion_actual)
