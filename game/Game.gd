extends Node

const COMERCIAL_TIMEOUT = 10

@export var mob_scene: PackedScene

@onready var score: Control = %Score

@onready var commercial_container: Control = %CommercialContainer
@onready var comercial_a: AdButton = %ComercialA
@onready var comercial_b: AdButton = %ComercialB
@onready var commercial_progress_bar: ProgressBar = %CommercialProgressBar
@onready var commercial_timeout: float = COMERCIAL_TIMEOUT

@onready var leaderboard_container: Control = %LeaderboardContainer
@onready var leaderboard: ItemList = %Leaderboard
@onready var leaderboard_retry: Button = %LeaderboardRetry
@onready var leaderboard_quit: Button = %LeaderboardQuit

func _ready():
	$UserInterface/Retry.hide()
	
	var genre = game_genres.selected_genre
	comercial_b.label.text = genre.name
	comercial_b.image.texture = load(genre.ads[randi() % genre.ads.size()])

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
	mob.squashed.connect($UserInterface/Score._on_Mob_squashed)

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	await _update_player_score()
	await _refresh_leaderboard()
	commercial_container.visible = true
	comercial_a.grab_focus()

func _update_player_score():	
	var current_score = int(score.score)
	var username = await aws_amplify.auth.get_user_attribute(AWSAmplifyAuth.UserAttributes.EMAIL)
	var get_score_response = await aws_amplify.data.query("""getScore(leaderboard: "%s", username: "%s") { score }""" % ["global", username], "GetScore")

	if get_score_response.result:
		if get_score_response.result.data.getScore == null:
			await aws_amplify.data.mutation("""createScore(input: {leaderboard: "%s", score: %s, username: "%s"}) { createdAt }""" % ["global", str(current_score), username], "CreateScore")
		elif int(get_score_response.result.data.getScore.score) < current_score:
			await aws_amplify.data.mutation("""updateScore(input: {leaderboard: "%s", score: %s, username: "%s"}) { createdAt }""" % ["global", str(current_score), username], "UpdateScore")
	else:
		print("Error: " + get_score_response.error.message)
		
func _refresh_leaderboard():
	var request = """listScoreByLeaderboardAndScore(leaderboard: "%s", sortDirection: DESC, limit:%s) { items { score username } }""" % ["global", "30"]
	var response = await aws_amplify.data.query(request)

	if response.result and response.result.has("data"):
		var items = response.result.data.listScoreByLeaderboardAndScore.items
		leaderboard.clear()
		for i in items.size():
			var item = items[i]
			leaderboard.add_item("%s | %s %s" % [str(i+1), item.username, item.score])
	else:
		print(response.error.message)

func _on_disconnect_button_pressed() -> void:
	var response = await aws_amplify.auth.sign_out(true)
	if response.error:
		print(response.error.message)

func _on_leaderboard_retry_pressed() -> void:
	get_parent().change_scene("res://Game.tscn")

func _on_leaderboard_quit_pressed() -> void:
	var response = await aws_amplify.auth.sign_out(true)
	if response.error:
		print(response.error.message)

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
	# TODO: Log the selected commercial to the player profile
	print("Commercial A Selected")
	_on_commercial_pressed() 

func _on_commercial_b_pressed() -> void:
	# TODO: Log the selected commercial to the player profile
	print("Commercial B Selected")
	_on_commercial_pressed() 

func _on_commercial_pressed() -> void:
	commercial_container.visible = false
	leaderboard_container.visible = true
	leaderboard_retry.grab_focus()
