extends CharacterBody2D

@export var move_speed: float 
@export var jump_speed: float 
#El export se utiliza para que en la parte gráfica de las características se pueda ajustar la velocidad o salto la variable es la velocidad en que se mueve
@onready var animated_Sprite = $SpriteAnimado
var is_facing_right = true
 # Para que el jugador gire en caso de no mirar a la derecha
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#Variable con el valor de la gravedad por defecto

func _physics_process(delta):
		
	jump(delta)
	move_x()
	flip()
	update_animations()
	move_and_slide()

func update_animations():
		if velocity.x:
			animated_Sprite.play("run")
		else:
			animated_Sprite.play("idle")
	
	
	#Ahora se van a controlar los giros con move_and_slide
		#Si el jugador esta mirando a la derecha y se oprime izq
		#Si el jugador esta mirando a la izq y se oprime derecha
func flip():
	if (is_facing_right and velocity.x < 0 ) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		#Si la escala en x vale en 1 ahora, valerá -1
		is_facing_right = not is_facing_right
	
#Ahora se controla el movimiento horizontal
func move_x():
	var input_axis= Input.get_axis("move_left","move_right")
	#Permite el movimiento a la izquierda y derecha
	velocity.x = input_axis * move_speed
	
func jump(delta):
	if Input .is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		
	if not is_on_floor():
		velocity.y += gravity*delta
	# Para que el muñeco no salte infinitamente, vamos a poner una variable de gravedad
