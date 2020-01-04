extends KinematicBody2D

export var x_speed : float = 500.0

onready var state_machine = $AnimationTree.get('parameters/playback')

func _process(delta):
	var current_state = state_machine.get_current_node()
	
	var x_dir = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	if x_dir != 0:
		$Graphics.scale.x = x_dir
		
	var velocity = x_speed * x_dir * Vector2(1, 0)
	velocity = move_and_slide(velocity)
	
	
	if current_state == 'Idle' and x_dir != 0:
		state_machine.travel('Running')
		
	if current_state == 'Running' and x_dir == 0:
		state_machine.travel('Idle')
		