extends OmniLight3D

var wave : float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wave += delta;
	position = Vector3(sin(wave) * 2.0, position.y, cos(wave) * 2.0);
