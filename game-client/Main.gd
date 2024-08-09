extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()
	var avatar_name = AwsAmplify.auth.get_user_attribute("custom:avatar_name")
	if avatar_name:
		$UserInterface/AvatarLabel.text = avatar_name
		
	var avatar_color = AwsAmplify.auth.get_user_attribute("custom:avatar_color")
	if avatar_color:
		$Player.change_player_color(avatar_color)


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


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
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_squashed)


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
