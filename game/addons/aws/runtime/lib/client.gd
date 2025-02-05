## AWS client for making authenticated requests using SigV4
## @desc A client for making HTTP requests to AWS services with SigV4 authentication
class_name AWSClient
extends Node

## AWS SigV4 signing algorithm constant
const ALGORITHM = "AWS4-HMAC-SHA256"

## Computes HMAC SHA256 of a message using a key
## @param key: The key to use for HMAC
## @param msg: The message to hash
## @return: The HMAC result as bytes
func hmac_sha256(key: PackedByteArray, msg: String) -> PackedByteArray:
	var hmac = HMACContext.new()
	hmac.start(HashingContext.HASH_SHA256, key)
	hmac.update(msg.to_utf8_buffer())
	return hmac.finish()

## Computes SHA256 hash of data
## @param data: The string to hash
## @return: The hash as a hex string
func sha256(data: String) -> String:
	var hash = HashingContext.new()
	hash.start(HashingContext.HASH_SHA256)
	hash.update(data.to_utf8_buffer())
	return hash.finish().hex_encode()

## Generates AWS signature key through recursive HMAC operations
## @param key: The secret key
## @param date_stamp: Date in YYYYMMDD format
## @param region: AWS region
## @param service: AWS service
## @return: The signature key as bytes
func get_signature_key(key: String, date_stamp: String, region: String, service: String) -> PackedByteArray:
	var k_date = hmac_sha256(("AWS4" + key).to_utf8_buffer(), date_stamp)
	var k_region = hmac_sha256(k_date, region)
	var k_service = hmac_sha256(k_region, service)
	var k_signing = hmac_sha256(k_service, "aws4_request")
	return k_signing

## Creates canonical request string for AWS signature
## @param method: HTTP method
## @param uri: Request URI
## @param host: Target host
## @param amz_date: Timestamp in AWS format
## @return: The canonical request string
func create_canonical_request(method: String, uri: String, host: String, amz_date: String) -> String:
	var canonical_uri = uri
	var canonical_querystring = ""
	var canonical_headers = "host:%s\nx-amz-date:%s\n" % [host, amz_date]
	var signed_headers = "host;x-amz-date"
	var payload_hash = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
	
	return "%s\n%s\n%s\n%s\n%s\n%s" % [
		method,
		canonical_uri,
		canonical_querystring,
		canonical_headers,
		signed_headers,
		payload_hash
	]

## Creates string to sign for AWS signature
## @param amz_date: Timestamp in AWS format
## @param credential_scope: AWS credential scope
## @param canonical_request: The canonical request string
## @return: The string to sign
func create_string_to_sign(amz_date: String, credential_scope: String, canonical_request: String) -> String:
	return "%s\n%s\n%s\n%s" % [
		ALGORITHM,
		amz_date,
		credential_scope,
		sha256(canonical_request)
	]

## Generates AWS SigV4 signed headers
## @param method: HTTP method
## @param uri: Request URI
## @param host: Target host
## @param access_key: AWS access key
## @param secret_key: AWS secret key
## @param region: AWS region
## @param service: AWS service
## @param custom_headers: Additional headers to include
## @param session_token: Optional session token
## @return: Dictionary containing all headers
func sign_request(
	method: String, 
	uri: String, 
	host: String,
	access_key: String, 
	secret_key: String,
	region: String, 
	service: String,
	custom_headers: Dictionary = {},
	session_token: String = ""
) -> Dictionary:
	# Create timestamp strings
	var now = Time.get_datetime_dict_from_system()
	var amz_date = "%04d%02d%02dT%02d%02d%02dZ" % [
		now.year, now.month, now.day,
		now.hour, now.minute, now.second
	]
	var date_stamp = "%04d%02d%02d" % [now.year, now.month, now.day]
	
	# Create credential scope
	var credential_scope = "%s/%s/%s/aws4_request" % [
		date_stamp, region, service
	]
	
	var canonical_request = create_canonical_request(method, uri, host, amz_date)
	var string_to_sign = create_string_to_sign(amz_date, credential_scope, canonical_request)
	
	# Calculate signature
	var signing_key = get_signature_key(secret_key, date_stamp, region, service)
	var signature = hmac_sha256(signing_key, string_to_sign).hex_encode()
	
	# Create authorization header
	var authorization = "%s Credential=%s/%s, SignedHeaders=host;x-amz-date, Signature=%s" % [
		ALGORITHM,
		access_key,
		credential_scope,
		signature
	]
	
	# Set required AWS headers
	var headers = {
		"Host": host,
		"x-amz-date": amz_date,
		"Authorization": authorization
	}
	
	if not session_token.is_empty():
		headers["x-amz-security-token"] = session_token
	
	headers.merge(custom_headers)
	
	return headers

## Parses HTTP response into a standardized format
## @param result: Array containing response data
## @return: Dictionary with parsed response
func _parse_response(result: Array) -> Dictionary:
	var response = {
		"success": false,
		"error": "",
		"code": 0,
		"headers": [],
		"body": null
	}
	
	var result_code: int = result[0]
	var response_code: int = result[1]
	var headers: PackedStringArray = result[2]
	var body: PackedByteArray = result[3]
	
	response.code = response_code
	response.headers = headers
	
	match result_code:
		HTTPRequest.RESULT_SUCCESS:
			response.success = true
			var response_text = body.get_string_from_utf8()
			
			if response_text:
				var json = JSON.new()
				var parse_error = json.parse(response_text)
				if parse_error == OK:
					response.body = json.data
				else:
					response.body = response_text
					
		HTTPRequest.RESULT_CHUNKED_BODY_SIZE_MISMATCH:
			response.error = "Chunked body size mismatch"
		HTTPRequest.RESULT_CANT_CONNECT:
			response.error = "Can't connect to host"
		HTTPRequest.RESULT_CANT_RESOLVE:
			response.error = "Can't resolve hostname"
		HTTPRequest.RESULT_CONNECTION_ERROR:
			response.error = "Connection error"
		HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR:
			response.error = "TLS handshake error"
		HTTPRequest.RESULT_NO_RESPONSE:
			response.error = "No response"
		HTTPRequest.RESULT_BODY_SIZE_LIMIT_EXCEEDED:
			response.error = "Body size limit exceeded"
		HTTPRequest.RESULT_REQUEST_FAILED:
			response.error = "Request failed"
		HTTPRequest.RESULT_DOWNLOAD_FILE_CANT_OPEN:
			response.error = "Can't open download file"
		HTTPRequest.RESULT_DOWNLOAD_FILE_WRITE_ERROR:
			response.error = "Download file write error"
		HTTPRequest.RESULT_REDIRECT_LIMIT_REACHED:
			response.error = "Redirect limit reached"
		_:
			response.error = "Unknown error occurred"
	
	return response

## Sends an HTTP request to AWS with SigV4 authentication
## @param method: HTTP method (GET, POST, etc.)
## @param uri: Request URI
## @param host: Target host
## @param access_key: AWS access key
## @param secret_key: AWS secret key
## @param region: AWS region
## @param service: AWS service
## @param custom_headers: Additional headers to include
## @param session_token: Optional session token
## @param body: Request body
## @param timeout: Request timeout in seconds
## @return: Dictionary containing response data
func send(
	method: String, 
	uri: String, 
	host: String,
	access_key: String, 
	secret_key: String,
	region: String, 
	service: String,
	custom_headers: Dictionary = {},
	session_token: String = "",
	body: String = "",
	timeout: float = 10.0
) -> Dictionary:
	var http = HTTPRequest.new()
	add_child(http)
	
	var request_headers = sign_request(
		method,
		uri,
		host,
		access_key,
		secret_key,
		region,
		service,
		custom_headers,
		session_token
	)
	
	var header_list: PackedStringArray = []
	for key in request_headers:
		header_list.append("%s: %s" % [key, request_headers[key]])
	
	var url = "https://%s%s" % [host, uri]
	
	var http_method = HTTPClient.METHOD_GET
	match method.to_upper():
		"POST":
			http_method = HTTPClient.METHOD_POST
		"PUT":
			http_method = HTTPClient.METHOD_PUT
		"DELETE":
			http_method = HTTPClient.METHOD_DELETE
		"PATCH":
			http_method = HTTPClient.METHOD_PATCH
		"HEAD":
			http_method = HTTPClient.METHOD_HEAD
	
	var error = http.request(
		url,
		header_list,
		http_method,
		body
	)
	
	if error != OK:
		http.queue_free()
		return {
			"success": false,
			"error": "Failed to send request: %s" % error,
			"code": error
		}

	var result = await http.request_completed
	var response = _parse_response(result)
	http.queue_free()
	
	return response
