extends State

const max_slide_speed = 500.0
	
	
func update(delta):
	this.apply_gravity(delta)
	
	if this.velocity.y > 0:
		this.velocity.y = min(this.velocity.y, max_slide_speed)
		
	if this.controls.jump_just_requested:
		state_machine.travel('WallJumping')
	elif this.velocity.x != 0 or this.is_on_floor() or this.controls.x_dir == 0:
		state_machine.travel('Falling')
		
	this.update_horizontal_movement(this.air_x_speed)
	