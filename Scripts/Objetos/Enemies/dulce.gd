# Script para configuración del dulce, este es un objeto que hiere al jugador
extends Node2D

var floorDetected = false
var safeTimeOut = false
var raycastInitValue = 27 

func _ready():
	$raycast_floor_detection.target_position.y = raycastInitValue
	$safeTime.start()
	pass
	
func _process(delta):
	if not floorDetected && safeTimeOut:
		$raycast_floor_detection.target_position.y += 6
		if $raycast_floor_detection.is_colliding():
			floorDetected = true
			$raycast_floor_detection.target_position.y -= 24
			init_dulce()
	$Dulce.rotation = self.rotation

func init_dulce():
	var numberOfChains = ($raycast_floor_detection.target_position.y - raycastInitValue) / 6
	$Dulce.position.y += (numberOfChains * 6)
	#Este bucle es para que con los pixeles de distancia al suelo duplique la cadena del dulces
	for i in range(numberOfChains):
		var newRing = preload("res://Scenes/Objetos/enemies/onechain.tscn").instantiate()
		newRing.position = Vector2(0,(6*(i+1)))
		self.add_child(newRing)
	$animation_rotation.play("regular_move")

func _on_safe_time_timeout() -> void:
	safeTimeOut = true


func _on_area_collision_with_map_body_entered(body: Node2D) -> void:
	$animation_rotation.speed_scale *= -1
