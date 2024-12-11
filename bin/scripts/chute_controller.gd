extends Node



# MEMBERS ####################################################################
@onready var packed_chute = preload("res://scenes/Chute.tscn")
var chute_origins : Array[Vector3]



# VIRTUALS ###################################################################
func _ready() -> void:
	var _chute_offset = 0
	
	for _unique_chute in Ball.ball_colors:
		var _chute : Chute = packed_chute.instantiate()
		add_child(_chute)
		var _chute_material = StandardMaterial3D.new()
		
		_chute_material.albedo_color = _unique_chute
		_chute.node_mesh.set_surface_override_material(0, _chute_material)
		_chute.position.z += _chute_offset
		_chute_offset += .7
		
		chute_origins.append(_chute.global_position)
