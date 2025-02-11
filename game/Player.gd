extends CharacterBody3D

class USER_ATTRIBUTES:
	const NAME = "preferred_username"
	const COLOR = "custom:color"
		
signal hit

## How fast the player moves in meters per second.
@export var speed = 14
## Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20
## Vertical impulse applied to the character upon bouncing over a mob in meters per second.
@export var bounce_impulse = 16
## The downward acceleration when in the air, in meters per second.
@export var fall_acceleration = 75

@onready var player_name: Label3D = %PlayerName
@onready var timer: Timer = $Timer
@onready var sessionID = str(int(Time.get_unix_time_from_system()))
@onready var animation: AnimationPlayer = $Animation
@onready var mob_detector: Area3D = $MobDetector

var dead = false
var idle = false
var username = null

func _ready() -> void:
	dead = false
	idle = true
	username = await aws_amplify.auth.get_user_attribute(AWSAmplifyAuth.UserAttributes.EMAIL)
	animation.play("idle")

func _physics_process(delta):
	if not dead:
		var direction = Vector3.ZERO
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_back"):
			direction.z += 1
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1

		if direction != Vector3.ZERO:
			# In the lines below, we turn the character when moving and make the animation play faster.
			direction = direction.normalized()
			# Setting the basis property will affect the rotation of the node.
			basis = Basis.looking_at(direction)

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# Jumping.
		if is_on_floor():			
			if Input.is_action_just_pressed("jump"):
				mob_detector.monitoring = false
				velocity.y += jump_impulse
			elif not mob_detector.monitoring:
				mob_detector.monitoring = true

		# We apply gravity every frame so the character always collides with the ground when moving.
		# This is necessary for the is_on_floor() function to work as a body can always detect
		# the floor, walls, etc. when a collision happens the same frame.
		velocity.y -= fall_acceleration * delta
		move_and_slide()

		# Here, we check if we landed on top of a mob and if so, we kill it and bounce.
		# With move_and_slide(), Godot makes the body move sometimes multiple times in a row to
		# smooth out the character's motion. So we have to loop over all collisions that may have
		# happened.
		# If there are no "slides" this frame, the loop below won't run.
		for index in range(get_slide_collision_count()):
			var collision = get_slide_collision(index)
			if collision.get_collider().is_in_group("mob"):
				var mob = collision.get_collider()
				if Vector3.UP.dot(collision.get_normal()) > 0.1:
					mob.squash()
					velocity.y = bounce_impulse
					# TODO: Move that out of the _physics_process function
					# aws_amplify.analytics.send(username,"SCORE",score_label.score,global_position.x,(-1 * global_position.z),sessionID,"")
					# Prevent this block from running more than once,
					# which would award the player more than 1 point for squashing a single mob.
					break

		# This makes the character follow a nice arc when jumping
		#rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	# TODO: Need to update configuration
	# aws_amplify.analytics.send(username,"GAME_END",score_label.score,global_position.x,(-1 * global_position.z),sessionID,"")
	hit.emit()
	queue_free()

func _on_MobDetector_body_entered(_body):
	if not dead:
		dead = true
		player_name.visible = false
		animation.play("sink")
		timer.start(2)

func _on_timer_timeout() -> void:
	die()
