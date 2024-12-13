extends Area3D

@onready var area = $"."
@onready var ui = $"../UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".connect("area_entered", game_over)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func game_over(_name) -> void:
	ui.game_over()
	pass
