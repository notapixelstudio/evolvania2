extends State

func update(delta):
	if this.controls.spin_just_requested:
		state_machine.travel('Spin')
	elif this.is_on_floor():
		# landing
		if this.controls.x_dir == 0:
			state_machine.travel('Idle')
		else:
			state_machine.travel('Running')
	elif this.is_on_wall():
		state_machine.travel('WallSliding')
	
	# can move horizontally while descending
	this.update_horizontal_movement(this.air_x_speed)
	this.apply_gravity(delta)
	
