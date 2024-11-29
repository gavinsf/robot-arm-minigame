extends RigidBody3D


@onready var ball_mesh : MeshInstance3D = $BallMeshInstance
static var ball_materials : Array[StandardMaterial3D] = []
var ball_colour : int


# Virtuals ###################################################################
func _init() -> void:
	ball_materials.append(load("res://materials/ball_material_0.tres"))
	ball_materials.append(load("res://materials/ball_material_1.tres"))
	ball_materials.append(load("res://materials/ball_material_2.tres"))

func _ready() -> void:
	ball_mesh.mesh.surface_set_material(0, ball_materials[ball_colour])
