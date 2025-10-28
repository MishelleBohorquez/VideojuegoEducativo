extends CharacterBody2D

@export var move_speed: float = 330.0  
@export var jump_speed: float = -350.0

@onready var animated_Sprite = $SpriteAnimado

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var appeared: bool = false
var leaved_floor: bool = false
var had_jump: bool = false

func _ready():
	animated_Sprite.play("appear")
	appeared = false  # El personaje aún no ha terminado de aparecer

func _physics_process(delta):
	# No procesar física hasta que termine la animación de aparecer
	if not appeared:
		return
	
	if is_on_floor():
		leaved_floor = false
		had_jump = false
		
	# 1. Aplicar gravedad
	if not is_on_floor():
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
		velocity.y += gravity * delta

	# 2. Gestionar el salto
	if Input.is_action_just_pressed("jump") and right_to_jump():
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

func right_to_jump():
	if is_on_floor(): 
		had_jump = true
		return true
	elif not $coyote_timer.is_stopped(): 
		had_jump = true
		return true
	
func flip():
	if velocity.x < 0:
		animated_Sprite.flip_h = true
	elif velocity.x > 0:
		animated_Sprite.flip_h = false

func _on_coyote_timer_timeout() -> void:
	leaved_floor = false
	print("Saltó!!")

func _on_sprite_animado_animation_finished() -> void:
	# Cuando la animación "appear" termina, permitir el juego normal
	if animated_Sprite.animation == "appear":
		appeared = true
		animated_Sprite.play("idle")  # Cambiar a idle después de aparecer


func _on_damage_detenction_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health -= 10
	print("Daño detectado") # Replace with function body.
