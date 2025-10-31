extends CharacterBody2D

@export var move_speed: float = 210.0  
@export var jump_speed: float = -350.0

@onready var animated_Sprite = $SpriteAnimado
@export var max_jumps: int = 2  # Número de saltos (1 = normal, 2 = doble salto)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var appeared: bool = false
var leaved_floor: bool = false
var jumps_remaining: int = 0

func _ready():
	animated_Sprite.play("appear")
	appeared = false  

func _physics_process(delta):
	# No procesar física hasta que termine la animación de aparecer
	if not appeared:
		return
	
	if not is_on_floor():
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
		velocity.y += gravity * delta
	else:
		# Si está en el suelo, resetea los saltos y el coyote time
		leaved_floor = false
		jumps_remaining = max_jumps 

	# 2. Gestionar el salto
	if Input.is_action_just_pressed("jump"):
		# Solo puede saltar si le quedan saltos O si el coyote time está activo
		if jumps_remaining > 0:
			velocity.y = jump_speed 
			
			jumps_remaining -= 1 
			
			if not $coyote_timer.is_stopped():
				$coyote_timer.stop()
				
		elif not $coyote_timer.is_stopped(): # Caso especial: Coyote time
			# El coyote time te permite usar tu primer salto
			velocity.y = jump_speed
			jumps_remaining = max_jumps - 1 # Gasta el primer salto, le queda 1
			$coyote_timer.stop()
		
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
	if velocity.x < 0:
		animated_Sprite.flip_h = true
	elif velocity.x > 0:
		animated_Sprite.flip_h = false

func _on_coyote_timer_timeout() -> void:
	leaved_floor = false

func _on_sprite_animado_animation_finished() -> void:
	
	if animated_Sprite.animation == "appear":
		appeared = true
		animated_Sprite.play("idle") 


func _on_damage_detenction_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health -= 10


func _on_zona_mortal_body_entered(body: Node2D) -> void:
	# Verificar si el jugador entró a la zona
	if body.is_in_group("Player"):
		# Si cae o entra a la zona se devuelve a la escena principal
		get_tree().reload_current_scene()
