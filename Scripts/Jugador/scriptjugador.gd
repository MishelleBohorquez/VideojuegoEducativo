extends CharacterBody2D

@export var move_speed: float = 300.0  # Añade valores por defecto para pruebas rápidas
@export var jump_speed: float = 400.0

@onready var animated_Sprite = $SpriteAnimado

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# 1. Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Gestionar el salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		
	# 3. Gestionar el movimiento horizontal
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed
	
	# 4. Actualizar animaciones y dirección del sprite
	update_animations()
	flip()
	
	# 5. Aplicar el movimiento final
	move_and_slide()

func update_animations():
	if velocity.x != 0:
		animated_Sprite.play("run")
	else:
		animated_Sprite.play("idle")
	
func flip():
	# Si nos movemos a la izquierda, el sprite se voltea horizontalmente.
	if velocity.x < 0:
		animated_Sprite.flip_h = true
	# Si nos movemos a la derecha, vuelve a su estado original.
	elif velocity.x > 0:
		animated_Sprite.flip_h = false
	# Si velocity.x es 0, no hacemos nada para que mantenga la última dirección.
