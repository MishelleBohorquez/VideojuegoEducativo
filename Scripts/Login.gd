# LoginScene.gd
extends Control


const SUPABASE_URL = "https://weucutfquntzkerlmwnv.supabase.co/"
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndldWN1dGZxdW50emtlcmxtd252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0ODU4NTksImV4cCI6MjA3NzA2MTg1OX0.3jyE5VX1wZb480teqkcnea6GLcyUl8-x1DNscx81YVU"


@onready var codigo_input = $VBoxContainer/CodigoInput
@onready var ingresar_button = $VBoxContainer/IngresarButton
@onready var mensaje_error = $VBoxContainer/MensajeError
@onready var api_request = $APIRequest



func _on_ingresar_button_pressed():
	# Limpiamos mensajes de error anteriores y desactivamos el botón
	mensaje_error.text = "Validando código..."
	ingresar_button.disabled = true

	# .strip_edges() quita espacios en blanco al inicio o al final
	var codigo = codigo_input.text.strip_edges()

	# Validación simple, si no se escribe nada se da un aviso
	if codigo.is_empty():
		mensaje_error.text = "Por favor, escribe tu código de acceso."
		ingresar_button.disabled = false
		return 

	# Llamada a la DB
	
	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY
	]
	
	
	var query_url = "/rest/v1/alumnos?select=*&codigo_acceso=eq.%s" % [codigo]
	var url_completa = SUPABASE_URL + query_url
	
	print("Consultando URL: ", url_completa) # Útil para depurar

	api_request.request(url_completa, headers)


func _on_api_request_request_completed(result, response_code, headers, body):
	ingresar_button.disabled = false

	if result != HTTPRequest.RESULT_SUCCESS:
		mensaje_error.text = "Error de conexión. Revisa tu internet."
		print("Error de red: ", result)
		return

	if response_code != 200:
		mensaje_error.text = "Error del servidor. Contacta al administrador."
		print("Error de servidor. Código: ", response_code)
		return

	
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	
	if json and json.size() > 0:
				
		# Guardamos los datos del primer alumno encontrado en nuestro Global.
		Global.current_student = json[0]
		
		# Saludamos y nos preparamos para cambiar de escena
		mensaje_error.text = "¡Bienvenido, " + Global.current_student.nombre + "!"
		
		# (Opcional) Puedes esperar 1 segundo para que el niño lea el mensaje
		# await get_tree().create_timer(1.0).timeout
		
		# Cambiamos a la escena principal del Menu
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
		
	else:
		# FRACASO DE LOGIN: La consulta fue exitosa, pero no encontró a nadie
		mensaje_error.text = "Código incorrecto. Intenta de nuevo."
