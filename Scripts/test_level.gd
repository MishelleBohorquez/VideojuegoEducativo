extends Node2D

# --- 1. CONSTANTES Y CONFIGURACIÓN ---
# Rutas de las imágenes corregidas para que coincidan con tu proyecto.
const CHARACTER_DATA = {
    "CAT": "res://Cartas/frontal sin fondo/card-1-1.png",
    "CHICKEN": "res://Cartas/frontal sin fondo/card-1-2.png",
    "COW": "res://Cartas/frontal sin fondo/card-1-3.png",
    "DOG": "res://Cartas/frontal sin fondo/card-1-4.png",
    "DUCK": "res://Cartas/frontal sin fondo/card-1-5.png",
    "FISH": "res://Cartas/frontal sin fondo/card-1-6.png",
    "PIG": "res://Cartas/frontal sin fondo/card-1-7.png",
    "RABBIT": "res://Cartas/frontal sin fondo/card-1-8.png"
}
const CHARACTER_SCENE = preload("res://Scenes/character.tscn")

# --- 2. VARIABLES DEL JUEGO ---
@export var total_rounds = 3
@export var opportunities_per_round = 3

var current_round = 1
var current_opportunities = 0
var correct_answer_name = ""

# --- 3. REFERENCIAS A NODOS ---
# Rutas y nombres corregidos para que coincidan con tu escena.
@onready var word_label = $CanvasLayer/WordLabel
@onready var character_positions_container = $CharacterPositions
@onready var winner_label = $FeedbackUI/WinnerLabel
@onready var loser_label = $FeedbackUI/LoserLabel
@onready var play_again_button = $FeedbackUI/PlayAgainButton

# --- FUNCIONES DE GODOT ---
func _ready():
    play_again_button.pressed.connect(_on_play_again_button_pressed)
    start_game()

# --- FUNCIONES PRINCIPALES DEL JUEGO ---
func start_game():
    print("Iniciando nuevo juego...")
    current_round = 1
    play_again_button.hide()
    setup_round()

func setup_round():
    # Limpia la UI y los personajes de la ronda anterior
    winner_label.hide()
    loser_label.hide()
    for pos_marker in character_positions_container.get_children():
        if pos_marker.get_child_count() > 0:
            pos_marker.get_child(0).queue_free()

    # Configura las variables para la nueva ronda
    current_opportunities = opportunities_per_round
    var all_names = CHARACTER_DATA.keys()
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
        var char_texture = CHARACTER_DATA[char_name]
        
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
    winner_label.show()
    await get_tree().create_timer(1.0).timeout
    
    current_round += 1
    if current_round > total_rounds:
        game_won()
    else:
        setup_round()

func handle_incorrect_answer():
    current_opportunities -= 1
    loser_label.show()
    print("Incorrecto. Oportunidades restantes: %s" % current_opportunities)
    
    await get_tree().create_timer(1.0).timeout
    loser_label.hide()
    
    if current_opportunities <= 0:
        game_over()

func game_over():
    loser_label.text = "GAME OVER"
    loser_label.show()
    
    await get_tree().create_timer(2.0).timeout
    loser_label.text = "X"
    
    start_game()

func game_won():
    winner_label.text = "WINNER!"
    winner_label.show()
    play_again_button.show()

func _on_play_again_button_pressed():
    winner_label.text = "WINNER!"
    start_game()
