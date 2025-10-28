extends Node2D


func _on_activation_area_body_entered(body: Node2D) -> void:
	$Animaciones_trampolin.play("launch")
	body.velocity.y = -700
	print(body)
