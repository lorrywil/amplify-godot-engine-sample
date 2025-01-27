extends TextureRect

const PROFILING = "res://Profiling.tscn"

@onready var start: Button = $Welcome/Start

func _ready() -> void:
	start.grab_focus()

func _on_start_pressed() -> void:
	get_parent().change_scene(PROFILING, true)
