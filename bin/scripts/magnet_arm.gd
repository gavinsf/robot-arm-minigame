extends Node3D
## Points towards mouse. "Shocks" targeted ball to chain them together



# MEMBERS ####################################################################
@onready var node_armature =  $Armature
var viewport_height : int
var slerp_count : int = 25
var target = Vector3(0, -2.0, 2.5)



# VIRTUALS ###################################################################


func _physics_process(delta: float) -> void:
	if slerp_count > 0:
		target_point(delta)




# METHODS ####################################################################
func target_point(delta) -> void:
	# Rotate towards target.
	var _target_vector = global_position.direction_to(target)
	var _target_angle = Basis.looking_at(_target_vector)
	node_armature.basis = node_armature.basis.slerp(_target_angle, 10 * delta)

	
	# decrement slerp counter
	slerp_count -= 1
