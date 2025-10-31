# GameManager.gd
extends Node

signal score_updated(new_score)
signal game_won

# Vuelve a verificar esta ruta por última vez.
# Si moviste el archivo a la carpeta 'reversa', esta es la ruta correcta:
var card_back = preload("res://Cartas/reversa/TarjeZanahoria.png")

var deck = []
var card1: Card = null
var card2: Card = null
var can_choose = true
var score = 0
var pairs_found = 0
var total_pairs = 8

func _ready():
	pass

func fillDeck(level_id: int):
	deck.clear()
	pairs_found = 0
	score = 0
	emit_signal("score_updated", score)
	for i in range(1, total_pairs + 1):
		deck.append(Card.new(level_id, i))
		deck.append(Card.new(level_id, i))
	

func dealDeck(grid_node: GridContainer):
	if not grid_node:
		print("ERROR: El nodo Grid no fue encontrado. No se pueden repartir las cartas.")
		return
	
	deck.shuffle()
	
	for card_instance in deck:
		grid_node.add_child(card_instance)

func chooseCard(card: Card):
	if not can_choose: return
	if card1 == null:
		card1 = card
		card1.flip()
		card1.disabled = true
	elif card2 == null:
		card2 = card
		card2.flip()
		card2.disabled = true
		can_choose = false
		get_tree().create_timer(0.8).timeout.connect(checkCards)

func checkCards():
	if card1.value == card2.value:
		score += 1
		pairs_found += 1
		emit_signal("score_updated", score)
		if pairs_found == total_pairs:
			emit_signal("game_won")
	else:
		card1.flip()
		card2.flip()
		card1.disabled = false
		card2.disabled = false
	
	card1 = null
	card2 = null
	can_choose = true
