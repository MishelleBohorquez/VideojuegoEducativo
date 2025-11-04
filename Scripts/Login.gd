# Script escena de inicio de sesión
extends Control

const SUPABASE_URL = "https://weucutfquntzkerlmwnv.supabase.co/"
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndldWN1dGZxdW50emtlcmxtd252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0ODU4NTksImV4cCI6MjA3NzA2MTg1OX0.3jyE5VX1wZb480teqkcnea6GLcyUl8-x1DNscx81YVU"


@onready var codigo_input = $PanelContainer/VBoxContainer/CodigoInput
@onready var ingresar_button = $PanelContainer/VBoxContainer/IngresarButton
@onready var mensaje_error = $PanelContainer/VBoxContainer/MensajeError
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
	
	
	if json and json.size() > 0:
		
		var alumno_data = json[0]
		

		Global1.alumno_actual_id = alumno_data["id"]
		
	
		mensaje_error.text = "¡Bienvenido, " + alumno_data["nombre"] + "!"
		
		print("¡Login exitoso! ID de Alumno guardado en Global1: ", Global1.alumno_actual_id)
		
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
		
	else:
	
		mensaje_error.text = "Código incorrecto. Intenta de nuevo."
