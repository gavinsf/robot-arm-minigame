extends Label
class_name ScoreLabel
## Tracks and displays score via Ball signals

var score : int = 0

func _ready() -> void:
	add_score(0)

func add_score(amount) -> void:
	score += amount
	text = "Score: " + str(score)
