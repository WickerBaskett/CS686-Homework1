extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass

func _input(event):
	if event is InputEventMouseMotion:
		#transform.basis.x += transform.basis.z * (event.relative.x / 500)
		transform.basis.y += transform.basis.z * (-event.relative.y /500)
		transform.basis = transform.basis.orthonormalized()
