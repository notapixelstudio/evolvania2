extends State

const wall_jump_vector = Vector2(3000,-2000)

func enter(from):
	this.velocity = wall_jump_vector
	this.controls.x_dir = 0
	this.controls.set_process(false)
	
func update(delta):
	# controllable height of jump
	this.velocity.y -= this.ascending_gravity_bonus * delta
	
	if this.velocity.y > 0 :
		state_machine.travel('Falling')
	elif this.controls.jump_just_released:
		state_machine.travel('Falling')
		
	# can move horizontally while ascending
	#this.update_horizontal_movement(this.air_x_speed)
	this.apply_gravity(delta) # ascend against gravity
	
func exit(to):
	this.controls.set_process(true)
	