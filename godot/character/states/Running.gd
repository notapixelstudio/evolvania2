extends State

func update(delta):
	if this.velocity.y > 0:
		state_machine.travel('Falling')
	elif this.controls.jump_just_requested:
		state_machine.travel('Jumping')
	elif this.controls.x_dir == 0:
		state_machine.travel('Idle')
	
	this.update_horizontal_movement(this.x_speed)
	this.apply_gravity(delta) # needed to fall
	