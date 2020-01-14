extends Node

var right_down : bool = false
var left_down : bool = false

var jump_just_requested : bool = false
var jump_just_released : bool = false

var x_dir : int = 0

func _process(delta):
	x_dir = int(right_down)-int(left_down)
	
	jump_just_requested = Input.is_action_just_pressed('ui_accept')
	jump_just_released = Input.is_action_just_released('ui_accept')
	
func _input(event):
	if event.is_action_pressed('ui_right'):
		right_down = true
		
	if event.is_action_pressed('ui_left'):
		left_down = true
	
	if event.is_action_released('ui_right'):
		right_down = false
		
	if event.is_action_released('ui_left'):
		left_down = false
	
func release_left():
	left_down = false
	
func release_right():
	right_down = false
