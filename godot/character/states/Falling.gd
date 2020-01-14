extends State

func update(delta):
	if this.is_on_floor():
		# landing
		state_machine.travel('Idle')
	elif this.is_on_wall() and this.controls.x_dir != 0:
		state_machine.travel('WallSliding')
	
	# can move horizontally while descending
	this.update_horizontal_movement(this.air_x_speed)
	this.apply_gravity(delta)
	