extends HSlider

@export var audio_bus_name:String

var audio_bus_id

func _ready():
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	# Sincroniza el slider con el volumen actual al iniciar
	# Convierte el volumen de dB a lineal y lo asigna al slider
	value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))
	
func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
