extends Label
class_name ScoreLabel
## Tracks and displays score via Ball signals


# MEMBERS ####################################################################
var score : int = 0



# VIRTUALS ###################################################################
func _ready() -> void:
	add_score(0)





# METHODS ####################################################################
func add_score(amount) -> void:
	score += amount
	text = "Score: " + str(score)
