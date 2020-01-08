extends KinematicBody2D

export var x_speed : float = 700.0
export var air_x_speed: float = 550.0
export var jump_speed: float = 1500.0
export var jump_gravity : float = 50.0
export var gravity : float = 120.0

onready var state_machine = $AnimationTree.get('parameters/playback')

var old_state = null

var velocity : Vector2 = Vector2(0,0)

func _process(delta):
	# use the animation state machine for gameplay purposes too
	var current_state = state_machine.get_current_node()
	
	# read left / right input
	var x_dir = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	
	### running on a platform
	# start
	if current_state == 'Idle' and x_dir != 0:
		state_machine.travel('Running')
		
	# stop
	if current_state == 'Running' and x_dir == 0:
		state_machine.travel('Idle')
		
	### jumping from a platform
	if (current_state == 'Idle' or current_state == 'Running') and Input.is_action_just_pressed('ui_accept'):
		state_machine.travel('Jumping')
	
	### falling
	if current_state != 'Falling' and velocity.y > 0:
		state_machine.travel('Falling')
		
	# controllable height of jump
	if current_state == 'Jumping' and Input.is_action_just_released("ui_accept"):
		state_machine.travel('Falling')
		
	### landing
	if current_state == 'Falling' and is_on_floor():
		state_machine.travel('Idle')
		
		
	### horizontal movement
	if current_state == 'Jumping' or current_state == 'Falling':
		velocity.x = air_x_speed * x_dir
	else:
		velocity.x = x_speed * x_dir
		
	# flipping
	if x_dir != 0:
		$Graphics.scale.x = x_dir
	
	### gravity
	if current_state == 'Jumping':
		velocity.y += jump_gravity
	else:
		velocity.y += gravity
		
	velocity = move_and_slide(velocity, Vector2(0,-1)) # second arg is the floor normal, needed by is_on_floor()
	
	
	# call whenever there is a status transition
	if current_state != old_state:
		_on_state_changed(old_state, current_state)
		old_state = current_state
		
func _on_state_changed(old_name, new_name):
	# log status change
	print(old_name, ' -> ', new_name)
	
	if new_name == 'Jumping':
		velocity.y = -jump_speed
