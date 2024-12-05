extends Node
## Holds & aligns balls. Bottom can open as part of a reset mechanism



#@export var classMember : Node = 0
@onready var node_alignment_markers : Node = $AlignmentMarkers
var markers : Array[Marker3D] = []
var markers_range : int = 0
#signal UserDefinedSignal

# VIRTUALS ####################################################
#func _init() -> void: pass
func _ready() -> void:
	for _node in node_alignment_markers.get_children():
		if _node is Marker3D: markers.append(_node)
	
	markers_range = markers.size()
#func _process(_delta: float) -> void: pass
#func _physics_process(_delta: float) -> void: pass

# SIGNALS #####################################################
# HELPERS #####################################################


func _on_alignment_area_body_exited(body: Node3D) -> void:
	if body is Ball:
		body.global_position = markers[floor(randf() * markers_range)].global_position
		body.axis_lock_linear_x = true
