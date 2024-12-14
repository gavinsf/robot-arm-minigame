extends Control

@onready var node_ui_game_over = $GameOver
@onready var node_ui_play = $Play
@onready var node_ui_splash = $Splash

@onready var particles = $explosion  # Ensure this is a GPUParticles3D node
@export var camera_path_follower : PathFollow3D

const PROGRESS_SPLASH = 0.4233
const PROGRESS_GAME_OVER = 0.99
const PROGRESS_PLAY = 0.01

func _ready() -> void:
	focus(PROGRESS_SPLASH)
	node_ui_play.hide()
	node_ui_game_over.hide()
	particles.emitting = false  # Make sure particles are off initially
	

func _input(event: InputEvent) -> void:
	# Exit program on Esc key pressed.
	if event.is_action("ui_cancel"): get_tree().quit()


func focus(progress_ratio : float) -> void:
	camera_path_follower.progress_ratio = progress_ratio

func _on_start_pressed() -> void:
	focus(PROGRESS_PLAY)
	node_ui_splash.hide()
	node_ui_play.show()

func game_over():
	# Start particle emission
	particles.emitting = true
	
	# Optional: wait a moment for the particles to "play"
	var delay = 1.0  # seconds to wait
	await get_tree().create_timer(delay).timeout
	
	# Now show the game over UI
	node_ui_game_over.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func restart():
	pass

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
