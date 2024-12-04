extends RigidBody3D
class_name Ball
## Rolls down the play area. Can be clicked, chaining to score same colour balls

@onready var ball_mesh : MeshInstance3D = $BallMeshInstance
@onready var expanded_area : Area3D = $ExpandedArea
static var ball_colors : Array[Color]  = [Color(0.8, 0.4, 0.4), Color(0.4, 0.9, 0.4), Color(0.4, 0.6, 0.9)] # red, green, blue
var ball_color : int
var chained = false


# VIRTUALS ###################################################################
func _ready() -> void:
	var _ball_material = StandardMaterial3D.new()
	_ball_material.albedo_color = ball_colors[ball_color]
	
	ball_mesh.set_surface_override_material(0, _ball_material)




# HELPERS ####################################################################
func get_similar_color_collisions() -> Array[Ball]:
	var _chain_array : Array[Ball] = [self]
	# Set chained = true prevents loops
	chained = true
	
	for _body in expanded_area.get_overlapping_bodies():
		if _body is Ball && !_body.chained && _body.ball_color == ball_color:
			_chain_array.append_array(_body.get_similar_color_collisions())
	
	return _chain_array

func _on_click_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		score_point()

func score_point():
	for _ball in get_similar_color_collisions():
			# Define what to go for each scored ball
			_ball.queue_free()
