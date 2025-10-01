extends CanvasLayer

@onready var contador_zanahorias: Label = $ContadorZanahorias

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var zanahoria_manager = get_node("%ZanahoriaManger")
	zanahoria_manager.puntuacion_actualizada.connect(_on_puntuacion_actualizada)

func _on_puntuacion_actualizada(puntuacion_actual:int) -> void:
	contador_zanahorias.text = str(puntuacion_actual)
