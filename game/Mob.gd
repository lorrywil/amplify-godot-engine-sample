extends CharacterBody3D

# Emitted when the player jumped on the mob.
signal squashed

## Minimum speed of the mob in meters per second.
@export var min_speed = 10
## Maximum speed of the mob in meters per second.
@export var max_speed = 18

@onready var timer: Timer = $Timer
@onready var animation: AnimationPlayer = $Animation
@onready var collision_shape: CollisionShape3D = $CollisionShape

var dead = false

func _physics_process(_delta):
	if not dead:
		move_and_slide()

func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4, PI / 4))

	var random_speed = randf_range(min_speed, max_speed)
	# We calculate a forward velocity first, which represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the vector based on the mob's Y rotation to move in the direction it's looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	$Animation.speed_scale = random_speed / min_speed
	$Animation.play("swim")

func squash():
	squashed.emit(global_position)
	dead = true
	collision_shape.disabled = true
	animation.play("sink")
	timer.start(2)

func _on_visible_on_screen_notifier_screen_exited():
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
