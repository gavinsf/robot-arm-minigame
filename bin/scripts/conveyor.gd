extends Node3D
## Creates balls, accelerating them if they reside in the PropellArea node



# MEMBERS ####################################################################
var balls_markov_chain : Array[int] = [3,3,3]
var spawn_timer = Timer.new()
var spawn_rate = 0.3
var ball_force = 5.0
var ball_direction : Vector3
@onready var packed_ball = preload("res://scenes/Ball.tscn")
@onready var ball_spawn_point = $BallSpawnMarker


# VIRTUALS ###################################################################
func _ready() -> void:
	# Manage timer.
	add_child(spawn_timer)
	spawn_timer.timeout.connect(on_spawn)
	spawn_timer.start(spawn_rate)
	# Shift ball impulse vector direction based on rotation.
	ball_direction = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)
	



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
	_inst_ball.apply_impulse(ball_force * ball_direction)
	
	add_child(_inst_ball)
	
	spawn_timer.start(spawn_rate)
