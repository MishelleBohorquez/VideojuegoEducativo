extends Area2D

@onready var zanahoria_manger: Node = %ZanahoriaManger
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	zanahoria_manger.incrementa_un_punto()
	queue_free()
