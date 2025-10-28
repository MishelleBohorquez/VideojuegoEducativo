extends CharacterBody2D

const SPEED = 150
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	# Inicia moviéndose a la derecha
	velocity.x = SPEED

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	
	if velocity.x > 0 and $RayCast_wall_detection.is_colliding():
		velocity.x *= -1 # Gira (ve a la izquierda)
	
	elif velocity.x < 0 and $RayCast_wall_detection2.is_colliding():
		velocity.x *= -1 # Gira (ve a la derecha)
	
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false # Mirando a la derecha
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true  # Mirando a la izquierda

	
	move_and_slide()
