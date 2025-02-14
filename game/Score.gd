extends Control

@onready var score_value: Label = %ScoreValue
var score = 0

func _on_mob_squashed(_position):
	score += 1
	score_value.text = "%s" % score
