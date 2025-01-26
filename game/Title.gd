extends TextureRect

const PROFILING = "res://Profiling.tscn"

@onready var start: Button = %Start
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start.grab_focus()

func _on_start_pressed() -> void:
	get_parent().change_scene(PROFILING, true)

func _on_start_focus_entered() -> void:
	animation_player.play("start")

func _on_start_focus_exited() -> void:
	animation_player.stop()
