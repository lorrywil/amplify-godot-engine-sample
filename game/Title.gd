extends TextureRect

const PROFILING = "res://Profiling.tscn"

@onready var timer: Timer = $Timer
@onready var video: VideoStreamPlayer = $Video
@onready var speech: AudioStreamPlayer = $Speech
@onready var welcome: ColorRect = $Welcome
@onready var start: Button = $Welcome/Start
@onready var player: AnimationPlayer = $Player

func _ready() -> void:
	start.grab_focus()
	music_player.play_title()

func _on_start_pressed() -> void:
	timer.start(5)
	video.play()
	speech.play()
	player.play("hide")

func _on_timer_timeout():
	get_parent().change_scene(PROFILING, true)
