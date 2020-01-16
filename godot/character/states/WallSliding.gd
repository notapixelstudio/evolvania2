extends State

const max_slide_speed = 500.0

func update(delta):
	this.apply_gravity(delta)
	
	if this.controls.grace_jump_down:
		state_machine.travel('WallJumping')
	elif this.velocity.y > 0:
		this.velocity.y = min(this.velocity.y, max_slide_speed)
		
	if this.velocity.x != 0 or this.is_on_floor():
		state_machine.travel('Falling')
		
	this.update_horizontal_movement(this.air_x_speed)
	this.velocity.x -= 800.0*this.last_wall # trick to keep pushing a little to the wall
	
