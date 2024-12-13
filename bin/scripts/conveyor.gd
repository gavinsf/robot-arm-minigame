extends Node3D

# MEMBERS ####################################################################
var balls_markov_chain : Array[int] = [3,3,3]
var spawn_timer = Timer.new()
var spawn_rate = 0.75
var ball_force = 60.0
var ball_direction : Vector3
@onready var packed_ball = preload("res://scenes/Ball.tscn")
@onready var ball_spawn_point = $BallSpawnMarker
@onready var click_sound = preload("res://sounds/pop_0.wav")  
@export var node_score_label : ScoreLabel = null
@export var node_magnet_arm : Node3D = null
@export var node_path_origin : Path3D = null

var impulsed_balls : Array[Ball] = [null]

# VIRTUALS ###################################################################
func _ready() -> void:
	# Manage timer.
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn)
	# Shift ball impulse vector direction based on rotation.
	ball_direction = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)

func _physics_process(delta: float) -> void:
	for _ball in impulsed_balls:
		if _ball is Ball: _ball.apply_impulse((ball_force * delta) * ball_direction)

# SIGNALS ####################################################################
func _on_start_pressed():
	spawn_timer.start(spawn_rate + randf()*2)

func _on_impulse_area_body_exited(body: Node3D) -> void:
	if (
		body is Ball
		&& impulsed_balls.has(body)
		):
		impulsed_balls.erase(body)

func _on_spawn() -> void:
	var _inst_ball : Ball = packed_ball.instantiate()
	_inst_ball.unique_name_in_owner = true
	var _color = null
	
	while _color == null:
		# Base case: empty markov chain, time for reset.
		if (balls_markov_chain[0] == 0 &&
		balls_markov_chain[1] == 0 &&
		balls_markov_chain[2] == 0):
			balls_markov_chain[0] = 3
			balls_markov_chain[1] = 3
			balls_markov_chain[2] = 3
		# Set from available markov result.
		var _result = floor(randf() * 3)
		if balls_markov_chain[_result] > 0: 
			_color = _result
			balls_markov_chain[_result] -= 1
	
	_inst_ball.ball_color = _color
	if node_score_label: _inst_ball.add_score.connect(node_score_label.add_score)
	if node_path_origin: _inst_ball.node_path_origin = node_path_origin
	if node_magnet_arm: _inst_ball.node_magnet_arm = node_magnet_arm
	
	add_child(_inst_ball)
	impulsed_balls.append(_inst_ball)
	spawn_timer.start(spawn_rate)
	
	for _i in range(8):
		_inst_ball.transform.origin = ball_spawn_point.transform.origin.slerp(ball_spawn_point.transform.origin, .2)
	
	# Connect the ball's input_event signal to the function that plays the sound
	_inst_ball.connect("input_event", Callable(self, "_on_ball_clicked"))

# METHODS ####################################################################
func _on_ball_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = click_sound
		add_child(audio_player)
		audio_player.play()
		queue_free()  # Remove the ball after playing the sound
