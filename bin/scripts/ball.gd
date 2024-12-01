extends RigidBody3D
## Play object. Provides interactivity and scoring

@onready var ball_mesh : MeshInstance3D = $BallMeshInstance
static var ball_colors : Array[Color]  = [Color(0.8, 0.4, 0.4), Color(0.4, 0.9, 0.4), Color(0.4, 0.6, 0.9)] # red, green, blue
var ball_color : int
var clickable : bool = false



# Virtuals ###################################################################
func _ready() -> void:
	var _ball_material = StandardMaterial3D.new()
	_ball_material.albedo_color = ball_colors[ball_color]
	
	ball_mesh.set_surface_override_material(0, _ball_material)



# HELPERS ####################################################################
func get_similar_color_collisions() -> Node3D:
	
	
	return null
