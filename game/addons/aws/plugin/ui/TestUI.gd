#@tool
extends VBoxContainer

# Node references
@onready var method_option: OptionButton = $RequestSection/MethodOption
@onready var uri_input: LineEdit = $RequestSection/URIInput
@onready var host_input: LineEdit = $RequestSection/HostInput
@onready var region_input: LineEdit = $RequestSection/RegionInput
@onready var service_input: LineEdit = $RequestSection/ServiceInput
@onready var access_key_input: LineEdit = $CredsSection/AccessKeyInput
@onready var secret_key_input: LineEdit = $CredsSection/SecretKeyInput
@onready var session_token_input: TextEdit = $CredsSection/SessionTokenInput
@onready var headers_input: TextEdit = $HeadersSection/HeadersInput
@onready var body_input: TextEdit = $BodySection/BodyInput
@onready var response_output: TextEdit = $ResponseSection/ResponseOutput
@onready var status_label: Label = $StatusSection/StatusLabel

func _ready() -> void:
	print("_ready")
	push_error("ERROR:_ready")

func _on_send_button_pressed():
	print("_on_send_button_pressed")
	push_error("ERROR:_on_send_button_pressed")
	# Clear previous response
	response_output.text = ""
	status_label.text = "Sending request..."
	
	# Parse headers JSON
	var custom_headers = {}
	if not headers_input.text.is_empty():
		var json = JSON.new()
		var error = json.parse(headers_input.text)
		if error == OK:
			custom_headers = json.data
		else:
			status_label.text = "Error: Invalid headers JSON"
			return
	
	# Send request
	var response = await aws.client.send(
		method_option.get_item_text(method_option.selected),
		uri_input.text,
		host_input.text,
		access_key_input.text,
		secret_key_input.text,
		region_input.text,
		service_input.text,
		custom_headers,
		session_token_input.text,
		body_input.text
	)
	
	# Display response
	if response.success:
		status_label.text = "Request successful (Code: %d)" % response.code
		response_output.text = JSON.stringify(response.body, "\t")
	else:
		status_label.text = "Request failed: %s" % response.error
		response_output.text = JSON.stringify(response, "\t")

func _on_clear_button_pressed():
	# Clear all inputs
	uri_input.text = ""
	host_input.text = ""
	headers_input.text = ""
	body_input.text = ""
	response_output.text = ""
	status_label.text = "Ready"
