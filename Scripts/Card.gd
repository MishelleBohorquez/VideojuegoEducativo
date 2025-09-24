# Card.gd
extends TextureButton
class_name Card

var suit: int
var value: int
var face: Texture2D
var back: Texture2D

func _init(s: int, v: int):
	suit = s
	value = v
	face = load("res://Cartas/frontal/card-%s-%s.png" % [s, v])
	back = GameManager.card_back
	texture_normal = back

func _ready():
	custom_minimum_size = Vector2(100, 150)
	stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
	self.pressed.connect(_on_pressed)

func _on_pressed():
	GameManager.chooseCard(self)

func flip():
	if texture_normal == back:
		texture_normal = face
	else:
		texture_normal = back
