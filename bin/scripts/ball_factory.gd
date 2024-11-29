extends Node3D
## Creates balls, accelerating them if they reside in the PropellArea node


# MEMBERS ####################################################################
var balls_markov_chain : Array[int] = [3,3,3]
var spawn_timer = Timer.new()
var spawn_rate = 0.2
var ball_force = 5.0
@onready var packed_ball = preload("res://scenes/Ball.tscn")

# VIRTUALS ###################################################################
func _ready() -> void:
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(on_spawn)
	spawn_timer.start(spawn_rate)
	

func _physics_process(delta: float) -> void:
	pass



# HELPERS ####################################################################
func on_spawn() -> void:
	var _inst_ball = packed_ball.instantiate()
	_inst_ball.unique_name_in_owner = true
	var _colour = null
	
	while _colour == null:
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
			_colour = _result
			balls_markov_chain[_result] -= 1
	
	_inst_ball.ball_colour = _colour
	_inst_ball.apply_impulse(Vector3(-ball_force,0,0))
	
	add_child(_inst_ball)
	
	spawn_timer.start(spawn_rate)
