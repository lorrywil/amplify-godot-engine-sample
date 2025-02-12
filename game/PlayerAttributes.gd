class_name PlayerAttributes
extends ColorRect

@onready var player_name: LineEdit = %Name
@onready var player_color: ColorPickerButton = %Color

func _ready() -> void:
	aws_amplify.auth.user_changed.connect(_on_user_changed)
	
	player_name.text = ""
	player_color.color = Color.ORANGE_RED
	
	var user_attributes = aws_amplify.auth.get_user_attributes()
	_update_user_attributes(user_attributes)
	
func _exit_tree() -> void:
	aws_amplify.auth.user_changed.disconnect(_on_user_changed)
	player_name.text = ""
	player_color.color = Color.ORANGE_RED
	
func _on_update_pressed() -> void:
	var user_attributes = {}
	user_attributes[UserAttributes.PREFERRED_NAME] = player_name.text
	user_attributes[UserAttributesColor] = player_color.color.to_html()
	var response = await aws_amplify.auth.update_user_attributes(user_attributes)
	if response.error:
		print(response.error.message)

func _on_user_changed(user_attributes) -> void:
	_update_user_attributes(user_attributes)
	
func _update_user_attributes(user_attributes) -> void:
	if user_attributes.has(UserAttributes.PREFERRED_NAME):
		player_name.text = user_attributes[UserAttributes.PREFERRED_NAME]
	if user_attributes.has(UserAttributesColor):
		player_color.color = Color(user_attributes[UserAttributesColor])

const UserAttributes = AWSAmplifyAuth.UserAttributes
var UserAttributesColor = UserAttributes.CUSTOM("color")
