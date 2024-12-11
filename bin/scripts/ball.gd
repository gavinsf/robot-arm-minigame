extends RigidBody3D
class_name Ball
## Rolls down the play area. Can be clicked, chaining to score same colour balls
# Clickable surface will rotate to always face the camera



# MEMBERS ####################################################################
var node_path_origin : Path3D
var node_magnet_arm : Node3D = null
@onready var ball_mesh : MeshInstance3D = $BallMesh
@onready var chain_area : Area3D = $Tracking/RemoteTarget/ChainArea
@onready var click_area : Area3D = $Tracking/RemoteTarget/ClickArea
static var ball_colors : Array[Color]  = [Color(0.8, 0.4, 0.4), Color(0.4, 0.9, 0.4), Color(0.4, 0.6, 0.9)] # red, green, blue
var ball_color : int
var chained = false
var score_max = 5.0

signal add_score(score_amount)



# VIRTUALS ###################################################################
func _ready() -> void:
	var _ball_material = StandardMaterial3D.new()
	_ball_material.albedo_color = ball_colors[ball_color]
	ball_mesh.set_surface_override_material(0, _ball_material)

func _physics_process(_delta: float) -> void:
	adjust_click_angle()



# METHODS ####################################################################
func get_similar_color_collisions() -> Array[Ball]:
	var _chain_array : Array[Ball] = [self]
	# Set chained = true prevents loops
	chained = true
	
	for _body in chain_area.get_overlapping_bodies():
		if (
			_body is Ball
			&& !_body.chained
			&& _body.ball_color == ball_color
			):
			_chain_array.append_array(_body.get_similar_color_collisions())
	
	return _chain_array

func score_point() -> void:
	var _chain : Array[Ball] = get_similar_color_collisions()
	var _score = clamp(_chain.size(), 0, score_max)
	
	for _ball in _chain:
		# Define what to go for each scored ball
		_ball.queue_free()
		add_score.emit(_score)

func adjust_click_angle() -> void:
	click_area.look_at(node_path_origin.transform.origin)



# SIGNALS #####################################################
func _on_click_area_input_event(
		_camera: Node, 
		event: InputEvent, 
		_event_position: Vector3, 
		_normal: Vector3, 
		_shape_idx: int
		) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		if node_magnet_arm: 
			node_magnet_arm.target = global_position
			node_magnet_arm.slerp_count = 15
		score_point()
