extends RigidBody3D


@onready var ball_mesh : MeshInstance3D = $BallMeshInstance
static var ball_colours : Array[Color]  = [Color(1,0,0), Color(0,1,0), Color(0,0,1)]
var ball_colour : int


# Virtuals ###################################################################
func _ready() -> void:
	var _ball_material = StandardMaterial3D.new()
	_ball_material.albedo_color = ball_colours[ball_colour]
	
	ball_mesh.set_surface_override_material(0,_ball_material)
