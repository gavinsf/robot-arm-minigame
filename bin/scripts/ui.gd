extends Control

# MEMBERS ####################################################################
@onready var node_ui_game_over = $GameOver
@onready var node_ui_play = $Play
@onready var node_ui_splash = $Splash

@export var camera_path_follower : PathFollow3D

const PROGRESS_SPLASH = 0.4233
const PROGRESS_GAME_OVER = 0.99
const PROGRESS_PLAY = 0.01

# VIRTUALS ###################################################################
func _ready() -> void:
	focus(PROGRESS_SPLASH)
	node_ui_play.hide()
	node_ui_game_over.hide()
	

func _input(event: InputEvent) -> void:
	# Exit program on Esc key pressed.
	if event.is_action("ui_cancel"): get_tree().quit()

# METHODS ####################################################################
func focus(progress_ratio : float) -> void:
	camera_path_follower.progress_ratio = progress_ratio

# SIGNALS ####################################################################
func _on_start_pressed() -> void:
	focus(PROGRESS_PLAY)
	node_ui_splash.hide()
	node_ui_play.show()
	
	

func game_over():
	node_ui_game_over.show()
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func restart():
	pass

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
