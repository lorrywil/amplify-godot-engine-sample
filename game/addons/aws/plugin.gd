## AWS plugin for Godot Engine.
##
## This plugin integrates AWS resources into Godot projects,
##
## @tutorial: https://github.com/aws-samples/aws-godot-engine-plugin
## @tutorial: https://github.com/aws-samples/aws-godot-engine/wiki
@tool
class_name AWSPlugin
extends EditorPlugin

## Name of the AWS Amplify plugin.
const AWS_PLUGIN_NAME = "AWS"

## Icon for the AWS Amplify plugin.
const AWS_PLUGIN_ICON: Texture2D = preload("res://addons/aws/plugin/icons/logo.svg")

## Main panel
const MAIN_PANEL = preload("res://addons/aws/plugin/ui/Main.tscn")

## Home page URL for the AWS Amplify plugin.
const AWS_PLUGIN_HOME: String = "https://github.com/aws-samples/aws-godot-engine-plugin"

## Name of the AWS Amplify singleton.
const AWS_PLUGIN_SINGLETON_NAME = "aws"

## Path to the AWS Amplify singleton.
const AWS_PLUGIN_SINGLETON_PATH = "res://addons/aws/runtime/main.gd"

var main_panel

## Called when the plugin enters the scene tree.
func _enter_tree() -> void:
	# Add AWS Amplify singleton autoload
	add_autoload_singleton(AWS_PLUGIN_SINGLETON_NAME, AWS_PLUGIN_SINGLETON_PATH)
	
	# Show the main panel
	main_panel = MAIN_PANEL.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel)
	_make_visible(false)
	
	# Display welcome message
	print("%s Plugin v%s (c) 2025-present Amazon, Inc" % [AWS_PLUGIN_NAME, get_plugin_version()])
	print("Use '%s' singleton to access AWS resources" % [AWS_PLUGIN_SINGLETON_NAME])
	print("Please visit %s!" % [AWS_PLUGIN_HOME])

		
## Called when the plugin exits the scene tree.
func _exit_tree() -> void:
	# Remove AWS Amplify singleton autoload
	remove_autoload_singleton(AWS_PLUGIN_SINGLETON_NAME)

	# Hide the main panel
	if main_panel:
		main_panel.queue_free()

## Determines if the plugin has a main screen.
func _has_main_screen() -> bool:
	return true

## Show/Hide the main panel
func _make_visible(visible):
	if main_panel:
		main_panel.visible = visible

## Returns the name of the plugin.
func _get_plugin_name() -> String:
	return AWS_PLUGIN_NAME

## Returns the icon for the plugin.
func _get_plugin_icon() -> Texture2D:
	return AWS_PLUGIN_ICON
