extends State

func enter(from):
	# stop when idle
	this.velocity = Vector2(0,0)
	
func update(delta):
	if this.controls.grace_jump_down:
		state_machine.travel('Jumping')
	elif this.velocity.y > 0:
		state_machine.travel('Falling')
	elif this.controls.x_dir != 0:
		state_machine.travel('Running')
		
	this.apply_gravity(delta) # needed to fall
	
func exit(to):
	# remember the last safe position to respawn to
	this.last_safe_position = this.position
	