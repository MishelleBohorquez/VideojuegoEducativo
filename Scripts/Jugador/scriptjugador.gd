# Script de jugador, aquí se ajusta funcionalidades de movimiento, de escenas y conexionaes

extends CharacterBody2D

@export var move_speed: float = 210.0  
@export var jump_speed: float = -350.0

@onready var animated_Sprite = $SpriteAnimado
@export var max_jumps: int = 2  

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var appeared: bool = false
var leaved_floor: bool = false
var jumps_remaining: int = 0

func _ready():
	animated_Sprite.play("appear")
	appeared = false  

func _physics_process(delta):
	if not appeared:
		return
	
	if not is_on_floor():
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
		velocity.y += gravity * delta
	else:
		leaved_floor = false
		jumps_remaining = max_jumps 

	if Input.is_action_just_pressed("jump"):
		if jumps_remaining > 0:
			velocity.y = jump_speed 
			
			jumps_remaining -= 1 
			
			if not $coyote_timer.is_stopped():
				$coyote_timer.stop()
				
		elif not $coyote_timer.is_stopped(): 
			velocity.y = jump_speed
			jumps_remaining = max_jumps - 1 
			$coyote_timer.stop()
		
	# Movimiento horizontal
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed
	
	# Actualizar animaciones y dirección del sprite
	update_animations()
	flip()
	
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
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()
