extends Control



func _input(event: InputEvent) -> void:
	# Exit program on Esc key pressed.
	if event.is_action("ui_cancel"): get_tree().quit()
