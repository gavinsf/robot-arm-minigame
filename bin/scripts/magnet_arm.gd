extends Node3D
## Points towards mouse. "Shocks" targeted ball to chain them together

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_rotate(Vector3.UP, 2*delta)
	print(get_global_rotation())
