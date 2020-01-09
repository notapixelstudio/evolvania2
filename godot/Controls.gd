extends Node

var x_dir : int = 0
var jump_just_requested : bool = false
var jump_just_released : bool = false

func _process(delta):
	x_dir = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	
	jump_just_requested = Input.is_action_just_pressed('ui_accept')
	jump_just_released = Input.is_action_just_released('ui_accept')
	