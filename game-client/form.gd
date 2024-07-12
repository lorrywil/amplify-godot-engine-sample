extends Control

@onready var mail_input = $MailInput
@onready var password_input = $PasswordInput
@onready var signin_button = $SignInButton
@onready var test_button = $TestButton

# Called when the node enters the scene tree for the first time.
func _ready():
	signin_button.pressed.connect(_on_button_pressed)
	test_button.pressed.connect(_on_test_button_pressed)
	pass

func _on_test_button_pressed():

	#print("Previous token : ", AwsAmplify.auth.auth_token)
	#var success = await AwsAmplify.auth.refresh_access_token()
	##print("Auth Response bool : ", success)
	
	var response = await AwsAmplify.data.mutate("{ createLeaderboard(input: {score: " + str(-1000) + ", username: \"" + AwsAmplify.auth.current_user.email + "\"}) { id } }", "DataMutation")
	##print("Current User : ", AwsAmplify.auth.current_user)
	
	print("test ", response)
	

func _on_button_pressed():
	print(mail_input.text + " " + password_input.text)
	var success = await AwsAmplify.auth.sign_in_with_user_password(mail_input.text, password_input.text)
	if success:
		get_tree().change_scene_to_file("res://Main.tscn")
