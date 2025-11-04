# Script Música de fondo
extends AudioStreamPlayer2D

func _ready():
	finished.connect(_on_finished)
	play()

func _on_finished():
	play()
