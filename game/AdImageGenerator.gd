class_name AdImageGenerator
extends Node

signal image_generated

var generated_image

func generate_image(genre) -> void:
	var _generated_image = await aws_amplify.data.query("""adsImageGenerator(prompt: "%s", negativePrompt: "%s")""" % [_sanitize_string(genre.prompt), _sanitize_string(genre.negative_prompt)], "GetImage")
	var string_response = _generated_image.result.data.adsImageGenerator
	var json_response = JSON.parse_string(string_response)

	if json_response == null || not(json_response.has("statusCode")):
		print("error while parsing the response")

	if json_response.statusCode == 200:
		if json_response.has("body"):
			if json_response.body.has("images") && json_response.body.images.size() > 0:
				var img = Image.new()
				img.load_png_from_buffer(Marshalls.base64_to_raw(json_response.body.images[0]))
				generated_image = ImageTexture.create_from_image(img)	
				image_generated.emit(generated_image)
			else:
				print(JSON.stringify(json_response.body))
	else:
		if json_response.body.has("body"):
			print(JSON.stringify(json_response.body))

func _sanitize_string(input: String) -> String:
	var output = input
	# Remove or replace problematic characters
	output = output.replace("\"", "") # Remove double quotes
	output = output.replace("'", "") # Remove single quotes
	output = output.replace("\\", "") # Remove backslashes
	return output
