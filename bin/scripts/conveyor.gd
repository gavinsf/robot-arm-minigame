extends Node3D
## Creates balls, accelerating them if they reside in the PropellArea node



# MEMBERS ####################################################################
var balls_markov_chain : Array[int] = [3,3,3]
var spawn_timer = Timer.new()
var spawn_rate = 0.75
var ball_force = 2.0
var ball_direction : Vector3
@onready var packed_ball = preload("res://scenes/Ball.tscn")
@onready var ball_spawn_point = $BallSpawnMarker

@export var node_score_label : ScoreLabel = null
@export var node_magnet_arm : Node3D = null
@export var node_camera : Camera3D = null

var impulsed_balls : Array[Ball] = [null]


# VIRTUALS ###################################################################
func _ready() -> void:
	# Manage timer.
	add_child(spawn_timer)
	spawn_timer.timeout.connect(on_spawn)
	spawn_timer.start(spawn_rate + randf()*2)
	# Shift ball impulse vector direction based on rotation.
	ball_direction = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)

func _physics_process(delta: float) -> void:
	for _ball in impulsed_balls:
		if _ball is Ball: _ball.apply_impulse(ball_force * ball_direction)


# HELPERS ####################################################################
func on_spawn() -> void:
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
	_inst_ball.transform.origin = ball_spawn_point.transform.origin
	if node_score_label is ScoreLabel: _inst_ball.add_score.connect(node_score_label.add_score)
	if node_camera is Camera3D: _inst_ball.current_camera = node_camera
	
	
	add_child(_inst_ball)
	impulsed_balls.append(_inst_ball)
	
	
	spawn_timer.start(spawn_rate)





func _on_impulse_area_body_exited(body: Node3D) -> void:
	if (
		body is Ball
		&& impulsed_balls.has(body)
		):
		impulsed_balls.erase(body)
	
