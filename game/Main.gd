extends Node

const DEFAULT = "res://Title.tscn"

@onready var auth: TextureRect = %Auth

var current_scene: Node
var signin_path: String

func _ready() -> void:
	change_scene(DEFAULT, false)
	
func _enter_tree() -> void:
	print("ENTER TREE")
	aws_amplify.auth.user_signed_in.connect(_user_signed_in)
	aws_amplify.auth.user_signed_out.connect(_user_signed_out)

func _exit_tree() -> void:
	print("EXIT TREE")
	aws_amplify.auth.user_signed_in.disconnect(_user_signed_in)
	aws_amplify.auth.user_signed_out.disconnect(_user_signed_out)

func _user_signed_in(_user_attributes) -> void:
	auth.visible = false
	current_scene = load(signin_path).instantiate()
	add_child(current_scene)

func _user_signed_out(_user_attributes) -> void:
	change_scene(DEFAULT, false)

func change_scene(path, secured = true):
	if current_scene:
		current_scene.queue_free()
		remove_child(current_scene)
	
	if secured && not aws_amplify.auth.is_signed_in():
		auth.visible = true
		signin_path = path
	else:
		current_scene = load(path).instantiate()
		add_child(current_scene)
