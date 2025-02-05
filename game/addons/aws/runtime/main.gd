class_name AWS
extends Node

var client: AWSClient

func _init() -> void:
	client = AWSClient.new()
