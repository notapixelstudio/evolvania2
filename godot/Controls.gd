extends Node

var right_down : bool = false
var left_down : bool = false
var jump_down : bool = false

# input buffering - see https://www.yoyogames.com/blog/544/flynn-advanced-jump-mechanics
var grace_jump_down : bool = false
const GRACE_JUMP_TIMEOUT : float = 0.15
var grace_jump_timeout : float = GRACE_JUMP_TIMEOUT

var jump_just_requested : bool = false
var jump_just_released : bool = false

var spin_just_requested : bool = false
var spin_just_released : bool = false


var x_dir : int = 0

func _process(delta):
	x_dir = int(right_down)-int(left_down)
	
	jump_just_requested = Input.is_action_just_pressed('jump')
	jump_just_released = Input.is_action_just_released('jump')
	
	spin_just_requested = Input.is_action_just_pressed('spin')
	spin_just_released = Input.is_action_just_released('spin')
	
	
	if grace_jump_timeout > 0:
		grace_jump_timeout -= delta
	else:
		grace_jump_down = false
	
func _input(event):
	if event.is_action_pressed('ui_right'):
		right_down = true
		
	if event.is_action_pressed('ui_left'):
		left_down = true
	
	if event.is_action_released('ui_right'):
		right_down = false
		
	if event.is_action_released('ui_left'):
		left_down = false
		
		
	if event.is_action_pressed('jump'):
		jump_down = true
		if not grace_jump_down:
			grace_jump_down = true
			grace_jump_timeout = GRACE_JUMP_TIMEOUT
		
	if event.is_action_released('jump'):
		jump_down = false
		grace_jump_down = false
		
func release_left():
	left_down = false
	
func release_right():
	right_down = false
