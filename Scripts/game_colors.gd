extends Node

@onready var score_label = $ScoreLabel
@onready var winner_panel = $WinnerPanel
@onready var grid = $Grid
@onready var play_again_button = $WinnerPanel/Button

func _ready():
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.game_won.connect(_on_game_won)
	
	play_again_button.pressed.connect(_on_play_again_pressed)

	# La línea clave que inicia todo
	GameManager.dealDeck(grid)

func _on_score_updated(new_score):
	score_label.text = " " + str(new_score)

func _on_game_won():
	winner_panel.show()

# --- FUNCIÓN QUE FALTABA ---
func _on_play_again_pressed():
	# Esta función se ejecutará cuando el jugador presione el botón.
	# La acción más común aquí es reiniciar la escena actual.
	print("El botón 'Jugar de Nuevo' fue presionado.") 
	#get_tree().reload_current_scene()
	get_tree().change_scene_to_file("res://Scenes/test_levelColors.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
