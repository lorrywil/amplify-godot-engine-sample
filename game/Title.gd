extends TextureRect

const PROFILING = "res://Profiling.tscn"

@onready var start: Button = $Welcome/Start

func _ready() -> void:
	start.grab_focus()
	music_player.play_title()

func _on_start_pressed() -> void:
	get_parent().change_scene(PROFILING, true)
