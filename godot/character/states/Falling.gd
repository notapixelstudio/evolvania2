extends State

func update(delta):
	if this.is_on_floor():
		# landing
		state_machine.travel('Idle')
	
	# can move horizontally while descending
	this.update_horizontal_movement(this.air_x_speed)
	