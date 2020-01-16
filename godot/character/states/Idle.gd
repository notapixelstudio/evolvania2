extends State

func enter(from):
	# stop when idle
	this.velocity = Vector2(0,0)
	
func update(delta):
	if this.is_on_floor() and this.controls.grace_jump_down:
		state_machine.travel('Jumping')
	elif this.controls.spin_just_requested:
		state_machine.travel('Spin')
	elif this.velocity.y > 0:
		state_machine.travel('Falling')
	elif this.controls.x_dir != 0:
		state_machine.travel('Running')
		
	this.apply_gravity(delta) # needed to fall
	
