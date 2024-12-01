extends Node3D

@onready var directional_light_3d: DirectionalLight3D = %DirectionalLight3D
@onready var omni_light_3d: OmniLight3D = %OmniLight3D
@onready var posterization_settings: HBoxContainer = %PosterizationSettings
@onready var num_tones: LineEdit = %NumTones
@onready var edge_detection_colors: CheckButton = %EdgeDetectionColors
@onready var effects: Array = [%ColorEdgeDetection, %DepthEdgeDetection, %Hatching, %Posterization]

var active_effect: MeshInstance3D
var current_edge_detection_color: bool = false
#################################
# Change Post-Processing Effect #
#################################
func _on_option_button_item_selected(index: int) -> void:
	for effect in effects:
		effect.visible = false
	posterization_settings.visible = false
	edge_detection_colors.visible = false
	current_edge_detection_color = false
	
	if index > 0:
		effects[index - 1].visible = true
		active_effect = effects[index - 1]
	
	# Turn on settings for the selected options
	if index == 4: # Posterization Settings
		posterization_settings.visible = true
		for child in posterization_settings.get_children():
			child.visible = true
	elif index == 1 or index == 2: # Edge Detection Settings
		edge_detection_colors.visible = true
		edge_detection_colors.button_pressed = false

###################
# Change Lighting #
###################
func _on_switch_lighting_pressed() -> void:
	directional_light_3d.visible = !directional_light_3d.visible
	omni_light_3d.visible = !omni_light_3d.visible

#########################################################################
# Handles changing the number of tones used in the posterization effect #
#########################################################################

func _on_add_tone_pressed() -> void:
	num_tones.text = str(int(num_tones.text) + 1)
	effects[3].get_active_material(0).set_shader_parameter("num_tones", int(num_tones.text))

func _on_subtract_tone_pressed() -> void:
	if int(num_tones.text) != 0: 
		num_tones.text = str(int(num_tones.text) - 1)
		effects[3].get_active_material(0).set_shader_parameter("num_tones", int(num_tones.text))

func _on_num_tones_text_changed(new_text: String) -> void:
	for char in new_text:
		if char >= '0' and char <= '9':
			effects[3].get_active_material(0).set_shader_parameter("num_tones", int(new_text))
		else:
			print("Only accepts integer Input")

#######################################################
# Change color palette used in edge detection shaders #
#######################################################
func _on_edge_detection_colors_pressed() -> void:
	current_edge_detection_color = !current_edge_detection_color
	active_effect.get_active_material(0).set_shader_parameter("color_mode", current_edge_detection_color)
	
