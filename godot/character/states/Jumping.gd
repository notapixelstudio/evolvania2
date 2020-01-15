extends State

const wall_jump_y_starting_speed = 1000.0

func enter(from):
	if from == 'Idle' or from == 'Running':
		# starting upwards velocity
		this.velocity.y = -this.jump_starting_speed
	elif from == 'WallSliding':
		this.velocity.y = -wall_jump_y_starting_speed
	
func update(delta):
	# controllable height of jump
	this.velocity.y -= this.ascending_gravity_bonus * delta
	
	if this.velocity.y > 0 :
		state_machine.travel('Falling')
	elif this.controls.jump_just_released:
		state_machine.travel('Falling')
		
	# can move horizontally while ascending
	this.update_horizontal_movement(this.air_x_speed)
	this.apply_gravity(delta) # ascend against gravity
	