extends Node

const COMERCIAL_TIMEOUT = 10

@export var mob_scene: PackedScene

@onready var score: Control = %Score
@onready var player: Player = $Player

@onready var commercial_container: Control = %CommercialContainer
@onready var commercial_a: AdButton = %CommercialA
@onready var commercial_b: AdButton = %CommercialB
@onready var commercial_c: AdButton = %CommercialC
@onready var commercial_progress_bar: ProgressBar = %CommercialProgressBar
@onready var commercial_timeout: float = COMERCIAL_TIMEOUT
@onready var leaderboard_container: Control = %LeaderboardContainer
@onready var leaderboard: ItemList = %Leaderboard
@onready var leaderboard_retry: Button = %LeaderboardRetry
@onready var leaderboard_quit: Button = %LeaderboardQuit

var sessionID

func _ready():
	music_player.play_loop()
	
	$UserInterface/Retry.hide()
	
	sessionID = str(int(Time.get_unix_time_from_system()))
	player.player_name.text = GlobalData.player_name
	
	aws_amplify.custom_analytics.record(GlobalData.player_name,"GAME_START",0,0,0,sessionID,"")
	
	var genre = game_genres.selected_genre
	var commercials = [commercial_a, commercial_b, commercial_c]
	
	var personalized_commercial_index = randi() % commercials.size()
	var personalized_commercial = commercials[personalized_commercial_index]
	personalized_commercial.label.text = "Pirates vs Sharks"
	personalized_commercial.image.texture = null
	
	# Dynamic image generation
	var generated_image_response = await _get_ad_image(genre)

	if !generated_image_response.error:
		var generated_image_b64 = generated_image_response.data
		var img = Image.new()
		img.load_png_from_buffer(Marshalls.base64_to_raw(generated_image_b64))
		personalized_commercial.image.texture = ImageTexture.create_from_image(img)		
	
	else:
		print(generated_image_response)

	commercials.remove_at(personalized_commercial_index)
	
	var neutral_commercial_indices = [1, 2, 3, 4, 5]
	for neutral_commercial in commercials:
		var neutral_commercial_index = randi() % neutral_commercial_indices.size()
		neutral_commercial.label.text = "Pirates vs Sharks"
		neutral_commercial.image.texture = load("res://art/ads/neutral_%d.png" % neutral_commercial_indices[neutral_commercial_index])
		neutral_commercial_indices.remove_at(neutral_commercial_index)

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Communicate the spawn location and the player's location to the mob.
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	# We connect the mob to the score label to update the score upon squashing a mob.
	mob.squashed.connect($UserInterface/Score._on_mob_squashed)
	mob.squashed.connect(_on_mob_squashed)

func _on_player_hit(position: Vector3):
	music_player.play_commercial()
	
	commercial_container.visible = true
	
	var commercials = [commercial_a, commercial_b, commercial_c]
	commercials[randi() % commercials.size()].grab_focus()
		
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
	aws_amplify.custom_analytics.record(GlobalData.player_name, "GAME_END", score.score, position.x,(-1 * position.z), sessionID, "")
	
	await _update_player_score()
	await _refresh_leaderboard()

func _on_mob_squashed(position: Vector3):
	aws_amplify.custom_analytics.record(GlobalData.player_name, "SCORE", score.score, position.x,(-1 * position.z), sessionID, "")

func _update_player_score():
	var current_score = int(score.score)
	var get_score_response = await aws_amplify.data.query("""getScore(leaderboard: "%s", username: "%s") { score }""" % ["global", GlobalData.player_name], "GetScore")

	if get_score_response.result:
		if get_score_response.result.data.getScore == null:
			await aws_amplify.data.mutation("""createScore(input: {leaderboard: "%s", score: %s, username: "%s"}) { createdAt }""" % ["global", str(current_score), GlobalData.player_name], "CreateScore")
		elif int(get_score_response.result.data.getScore.score) < current_score:
			await aws_amplify.data.mutation("""updateScore(input: {leaderboard: "%s", score: %s, username: "%s"}) { createdAt }""" % ["global", str(current_score), GlobalData.player_name], "UpdateScore")
	else:
		print("Error: " + get_score_response.error.message)
		
func _refresh_leaderboard():
	var request = """listScoreByLeaderboardAndScore(leaderboard: "%s", sortDirection: DESC, limit:%s) { items { score username } }""" % ["global", "30"]
	var response = await aws_amplify.data.query(request, "ListLeaderboard")

	if response.result and response.result.has("data"):
		var items = response.result.data.listScoreByLeaderboardAndScore.items
		leaderboard.clear()
		for i in items.size():
			var item = items[i]
			leaderboard.add_item("%s | %s %s" % [str(i + 1), item.username, item.score])
	else:
		print(response.error.message)

func _on_disconnect_button_pressed() -> void:
	var response = await aws_amplify.auth.sign_out(true)
	if response.error:
		print(response.error.message)

func _on_leaderboard_retry_pressed() -> void:
	get_parent().change_scene("res://Game.tscn")

func _on_leaderboard_quit_pressed() -> void:
	get_parent().change_scene("res://Title.tscn")
	#var response = await aws_amplify.auth.sign_out(true)
	#if response.error:
	#	print(response.error.message)

func _on_user_attributes_update_button_pressed() -> void:
	$MobTimer.start()
	$UserInterface/PlayerAttributes.visible = false

func _on_user_attributes_button_pressed(toggled) -> void:
	if toggled:
		$MobTimer.stop()
		$UserInterface/PlayerAttributes.visible = true
	else:
		$MobTimer.start()
		$UserInterface/PlayerAttributes.visible = false

func _on_commercial_a_pressed() -> void:
	aws_amplify.custom_analytics.record(GlobalData.player_name,"AD_CLICK",0,0,0,"","A")
	_on_commercial_pressed()

func _on_commercial_b_pressed() -> void:
	aws_amplify.custom_analytics.record(GlobalData.player_name,"AD_CLICK",0,0,0,"","B")
	_on_commercial_pressed()

func _on_commercial_c_pressed() -> void:
	aws_amplify.custom_analytics.record(GlobalData.player_name,"AD_CLICK",0,0,0,"","C")
	_on_commercial_pressed() 

func _on_commercial_pressed() -> void:
	commercial_container.visible = false
	leaderboard_container.visible = true
	leaderboard_retry.grab_focus()

func _sanitize_string(input: String) -> String:
	var output = input
	# Remove or replace problematic characters
	output = output.replace("\"", "") # Remove double quotes
	output = output.replace("'", "") # Remove single quotes
	output = output.replace("\\", "") # Remove backslashes
	return output

func _get_ad_image(genre) -> Dictionary:

	var response = {
		"error": false,
		"data": ""
	}

	var generate_image = await aws_amplify.data.query("""adsImageGenerator(prompt: "%s", negativePrompt: "%s")""" % [_sanitize_string(genre.prompt), _sanitize_string(genre.negative_prompt)], "GetImage")
	var string_response = generate_image.result.data.adsImageGenerator
	var json_response = JSON.parse_string(string_response)

	if json_response == null || not(json_response.has("statusCode")):
		response.error = true
		response.data = "error while parsing the response"
		return response

	if json_response.statusCode == 200:
		if json_response.has("body"):
			if json_response.body.has("images") && json_response.body.images.size() > 0:
				response.data = json_response.body.images[0]
				return response
			else:
				response.data = JSON.stringify(json_response.body)
				response.error = true
				return response
	else:
		if json_response.body.has("body"):
			response.data = JSON.stringify(json_response.body)
			response.error = true
			return response

	response.error = true
	response.data = "error while parsing the response"
	return response
