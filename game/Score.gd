extends Control

@onready var score_value: Label = %ScoreValue
var score = 0

func _on_Mob_squashed():
	score += 1
	score_value.text = "%s" % score
