extends Node2D

#CONSTANTES Y CONFIGURACIÓN
@export var level_data: Dictionary = {}
@export var level_name_for_supabase: String = "Nivel_Evaluativo"
@export var next_scene: PackedScene

const CHARACTER_SCENE = preload("res://Scenes/character.tscn")

#Datos de SUPABASE
var SUPABASE_URL = "https://weucutfquntzkerlmwnv.supabase.co"
var SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndldWN1dGZxdW50emtlcmxtd252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0ODU4NTksImV4cCI6MjA3NzA2MTg1OX0.3jyE5VX1wZb480teqkcnea6GLcyUl8-x1DNscx81YVU"
var API_URL = SUPABASE_URL + "/rest/v1/puntajes"


#  VARIABLES DEL JUEGO
var total_rounds = 8
var total_opportunities = 2
const MAX_SCORE = 50.0 # Nota máxima
var score_per_round = MAX_SCORE / total_rounds # 6.25 puntos por ronda

# Variables para rastrear el estado
var current_round = 1
var current_opportunities_left = 0
var current_score = 0.0
var correct_answer_name = ""


# REFERENCIAS A NODOS
@onready var word_label = $CanvasLayer/WordLabel
@onready var character_positions_container = $CharacterPositions
@onready var winner_label = $FeedbackUI/WinnerLabel
@onready var loser_label = $FeedbackUI/LoserLabel
@onready var incorrect_sign = $FeedbackUI/IncorrectoSign
@onready var play_again_button = $FeedbackUI/PlayAgainButton
@onready var http_request = $GuardarPuntajeRequest # Asegúrate que tu nodo se llame así


# FUNCIONES DE GODOT
func _ready():
	play_again_button.pressed.connect(_on_play_again_button_pressed)
	start_game()

# FUNCIONES PRINCIPALES DEL JUEGO

func start_game():
	print("Iniciando nuevo juego...")
	
	# Resetea todas las variables de la partida
	current_round = 1
	current_score = 0.0
	current_opportunities_left = total_opportunities # Vidas globales
	
	# Oculta toda la UI de fin de juego
	play_again_button.hide()
	winner_label.hide()
	loser_label.hide()
	incorrect_sign.hide()
	
	# Prepara la primera ronda
	setup_round()

func setup_round():
	# Limpia la UI de feedback
	winner_label.hide()
	loser_label.hide()
	incorrect_sign.hide()
	
	# Limpia los personajes de la ronda anterior
	for pos_marker in character_positions_container.get_children():
		if pos_marker.get_child_count() > 0:
			pos_marker.get_child(0).queue_free()

	var all_names = level_data.keys()
	all_names.shuffle()
	
	correct_answer_name = all_names[0]
	var options = [all_names[0], all_names[1], all_names[2], all_names[3]]
	options.shuffle()
	
	word_label.text = correct_answer_name
	
	# Crea y posiciona los 4 personajes
	var i = 0
	for pos_marker in character_positions_container.get_children():
		if not pos_marker is Marker2D: continue
		
		var char_name = options[i]
		var char_texture = level_data[char_name]
		
		var character = CHARACTER_SCENE.instantiate()
		character.setup(char_name, char_texture)
		character.character_selected.connect(_on_character_selected)
		
		pos_marker.add_child(character)
		i += 1

# --- FUNCIONES DE RESPUESTA (HANDLERS) ---
func _on_character_selected(selected_name):
	if selected_name == correct_answer_name:
		handle_correct_answer()
	else:
		handle_incorrect_answer()

func handle_correct_answer():
	current_score += score_per_round
	print("¡Correcto! Puntaje actual: %f" % current_score)

	winner_label.show()
	await get_tree().create_timer(1.0).timeout
	
	current_round += 1
	if current_round > total_rounds:
		game_won()
	else:
		setup_round()

func handle_incorrect_answer():
	current_opportunities_left -= 1
	incorrect_sign.show()
	print("Incorrecto. Vidas restantes: %s" % current_opportunities_left)
	
	await get_tree().create_timer(1.0).timeout
	incorrect_sign.hide()
	
	if current_opportunities_left <= 0:
		game_over()

func game_over():
	loser_label.text = "GAME OVER"
	loser_label.show()
	
	print("Juego terminado. Enviando puntaje: %s" % roundi(current_score))
	guardar_puntaje_en_supabase(roundi(current_score), level_name_for_supabase)
	
	play_again_button.show()

func game_won():
	winner_label.text = "WINNER!"
	winner_label.show()

	print("Juego ganado. Enviando puntaje: %s" % roundi(current_score))
	guardar_puntaje_en_supabase(roundi(current_score), level_name_for_supabase)

	play_again_button.show()

func _on_play_again_button_pressed():
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		print("ERROR: No se ha configurado la escena 'Next Scene' en el Inspector.")
		get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")


# FUNCIONES DE SUPABASE

func guardar_puntaje_en_supabase(puntaje: int, escena_nombre: String):
	print("Intentando guardar puntaje en Supabase...")
	
	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY,
		"Content-Type: application/json",
		"Prefer: return=minimal"
	]
	

	var alumno_id_actual = Global1.alumno_actual_id


	if alumno_id_actual == 0:
		print("ERROR: No hay un alumno logueado (ID es 0). No se puede guardar puntaje.")
		return
		
	var data_dictionary = {
		"alumno_id": alumno_id_actual,
		"puntaje_obtenido": puntaje,
		"nombre_escena": escena_nombre
	}
	
	var body_json_string = JSON.stringify(data_dictionary)
	http_request.request(API_URL, headers, HTTPClient.METHOD_POST, body_json_string)


func _on_guardar_puntaje_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Error: No se pudo contactar al servidor de Supabase.")
		return

	if response_code == 201:
		print("¡ÉXITO! Puntaje guardado correctamente en Supabase.")
	else:
		print("Error al guardar. Código de respuesta: ", response_code)
		print("Respuesta del servidor: ", body.get_string_from_utf8())
