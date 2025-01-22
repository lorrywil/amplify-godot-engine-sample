extends Node
class_name Profiling

@onready var answer: LineEdit = $Answer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_validate_pressed() -> void:
	# TODO: update player profile and generate a dynamic commercial
	get_tree().change_scene_to_file("res://Main.tscn")
