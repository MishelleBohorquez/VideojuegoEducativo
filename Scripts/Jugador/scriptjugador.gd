extends CharacterBody2D

@export var move_speed: float
@export var jump_speed: float
# El export se utiliza para que en la parte gráfica de las características se pueda ajustar la velocidad o salto.

@onready var animated_Sprite = $SpriteAnimado

var is_facing_right = true
# Para que el jugador gire en caso de no mirar a la derecha.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Variable con el valor de la gravedad por defecto.

func _physics_process(delta):
	# 1. Aplicar gravedad en cada fotograma.
	# Esto es crucial para que `move_and_slide` funcione correctamente.
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Gestionar el salto.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		
	# 3. Gestionar el movimiento horizontal.
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed
	
	# 4. Actualizar animaciones y dirección del sprite.
	update_animations()
	flip()
	
	# 5. Aplicar el movimiento final.
	# Esta función debe llamarse al final, después de calcular toda la velocidad.
	move_and_slide()

func update_animations():
	# Si hay velocidad horizontal, reproduce la animación de correr.
	if velocity.x != 0:
		animated_Sprite.play("run")
	# Si no, reproduce la de estar quieto.
	else:
		animated_Sprite.play("idle")
	
func flip():
	# Gira el sprite si la dirección del movimiento no coincide con la dirección a la que mira.
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		# Invierte la escala horizontal del personaje (y todo lo que sea su hijo).
		scale.x *= -1
		is_facing_right = not is_facing_right
