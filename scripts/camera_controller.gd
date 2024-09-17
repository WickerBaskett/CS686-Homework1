extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		var mouse_velocity = Input.get_last_mouse_velocity().normalized()
		#transform.basis.x += transform.basis.z * mouse_velocity.x / 50
		
		#print(mouse_velocity)
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transform.basis.y += transform.basis.z * -event.relative.y / 500
