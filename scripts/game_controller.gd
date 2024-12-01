extends Node3D

@onready var effects: Array = [%ColorEdgeDetection, %DepthEdgeDetection, %Hatching]
# Change Post-Processing Effect
func _on_option_button_item_selected(index: int) -> void:
	for effect in effects:
		effect.visible = false
	
	if index > 0:
		effects[index - 1].visible = true
	
	
