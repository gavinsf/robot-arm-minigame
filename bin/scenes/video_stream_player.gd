extends VideoStreamPlayer

signal video_hidden

func _ready() -> void:
	play()  

func hide_video():
	stop()
	hide()
	set_process(false)
	set_process_input(false)
	emit_signal("video_hidden")
