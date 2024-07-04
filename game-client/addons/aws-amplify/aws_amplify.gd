extends Node

var auth_token = ''
var client_id = ''
var cognito_endpoint = ''
var graphql_endpoint = ''
var email = ''

func _ready():
	var file_path = "res://amplify_outputs.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var content = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(content)
		
		if parse_result == OK:
			var result = json.get_data()
			var auth = result["auth"]
			var region = auth["aws_region"]
			cognito_endpoint = "https://cognito-idp." + region + ".amazonaws.com/"
			client_id = auth["user_pool_client_id"]
			graphql_endpoint = result["data"]["url"]
			
			print("File loaded, Cognito Endpoint: ", cognito_endpoint)
			print("Client ID: ", client_id)
			print("GraphQL Endpoint: ", graphql_endpoint)
			
		else:
			print("Failed to parse JSON")
	else:
		print("File does not exist: ", file_path)

func authenticate(email, password):
	var response = await _send_authentication_request(email, password)
	var result = response[0]
	var response_code = response[1]
	var body = response[3]
	
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if json.has("AuthenticationResult") and json.AuthenticationResult.has("AccessToken"):
			auth_token = json.AuthenticationResult.AccessToken
			return true
		else:
			return false
	else:
		return false

func update_score(score):
	var response = await _send_update_score_request(email, score)
	var result = response[0]
	var response_code = response[1]
	var body = response[3]
	print(response_code)
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if json.has("data") and json.data.has("createLeaderboard"):
			print("Score updated successfully, ID: ", json.data.createLeaderboard.id)
			return true
		else:
			print("Failed to update score")
			return false
	else:
		print("HTTP request failed with response code: ", response_code)
		return false

func _send_authentication_request(email, password):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var headers = [
		"X-Amz-Target: AWSCognitoIdentityProviderService.InitiateAuth",
		"Content-Type: application/x-amz-json-1.1"
	]
	
	var body = JSON.stringify({
		"AuthFlow": "USER_PASSWORD_AUTH",
		"ClientId": client_id,
		"AuthParameters": {
			"USERNAME": email,
			"PASSWORD": password
		}
	})
	
	var error = http_request.request(cognito_endpoint, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		return {"error": "Failed to send request"}

	var response = await http_request.request_completed
	http_request.queue_free()
	
	return response

func _send_update_score_request(email, score):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + auth_token
	]
	
	var body = JSON.stringify({
		"query": "mutation MyMutationtest { createLeaderboard(input: {score: " + str(score) + ", username: \"" + email + "\"}) { id } }",
		"variables": null,
		"operationName": "MyMutationtest"
	})
	
	var error = http_request.request(graphql_endpoint, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		return {"error": "Failed to send request"}

	var response = await http_request.request_completed
	http_request.queue_free()
	
	return response
