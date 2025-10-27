# LoginScene.gd
extends Control

const SUPABASE_URL = "https://weucutfquntzkerlmwnv.supabase.co/"
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndldWN1dGZxdW50emtlcmxtd252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0ODU4NTksImV4cCI6MjA3NzA2MTg1OX0.3jyE5VX1wZb480teqkcnea6GLcyUl8-x1DNscx81YVU"


@onready var codigo_input = $VBoxContainer/CodigoInput
@onready var ingresar_button = $VBoxContainer/IngresarButton
@onready var mensaje_error = $VBoxContainer/MensajeError
@onready var api_request = $APIRequest


func _on_ingresar_button_pressed():
	mensaje_error.text = "Validando código..."
	ingresar_button.disabled = true

	var codigo = codigo_input.text.strip_edges()

	if codigo.is_empty():
		mensaje_error.text = "Por favor, escribe tu código de acceso."
		ingresar_button.disabled = false
		return 

	var headers = [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY
	]
	
	# Usamos %s para el código, que es más seguro
	var query_url = "/rest/v1/alumnos?select=id,nombre&codigo_acceso=eq.%s" % [codigo]
	var url_completa = SUPABASE_URL + query_url
	
	print("Consultando URL: ", url_completa)
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
	
	# ¡¡AQUÍ ESTÁ LA CORRECCIÓN!!
	if json and json.size() > 0:
		# La consulta fue exitosa y encontramos un alumno.
		var alumno_data = json[0] # Esto es un diccionario: {"id": 1, "nombre": "Ruby"}
		
		# Guardamos los datos en la "mochila" CORRECTA (Global1)
		# Tu script del juego (test_level.gd) busca "Global1.alumno_actual_id"
		Global1.alumno_actual_id = alumno_data["id"]
		
		# (Opcional, pero bueno) También podemos guardar el nombre si lo tienes en Global1.gd
		# Global1.alumno_actual_nombre = alumno_data["nombre"] 
		
		# Saludamos y nos preparamos para cambiar de escena
		mensaje_error.text = "¡Bienvenido, " + alumno_data["nombre"] + "!"
		
		# ¡Imprimimos en consola para confirmar!
		print("¡Login exitoso! ID de Alumno guardado en Global1: ", Global1.alumno_actual_id)
		
		# Cambiamos a la escena principal del Menu
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
		
	else:
		# FRACASO DE LOGIN: La consulta fue exitosa, pero no encontró a nadie
		mensaje_error.text = "Código incorrecto. Intenta de nuevo."
