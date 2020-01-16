extends State

const BACK_DURATION : float = 0.2
var back_duration : float

const wall_jump_y_starting_speed = 1200.0
const wall_jump_x_starting_speed = 1350.0

func enter(from):
	back_duration = BACK_DURATION
	
	this.velocity.y = -wall_jump_y_starting_speed
	if this.last_wall == 1:
		this.velocity.x = wall_jump_x_starting_speed
	elif this.last_wall == -1:
		this.velocity.x = -wall_jump_x_starting_speed
		
func update(delta):
	if this.last_wall != this.controls.x_dir:
		back_duration -= delta
	
	this.velocity.y -= this.ascending_gravity_bonus * delta
	
	if this.last_wall == this.controls.x_dir and this.controls.jump_just_released:
		state_machine.travel('Falling')
	elif back_duration < 0 or this.velocity.y > 0:
		state_machine.travel('Falling')
		
	# cannot move horizontally while wall jumping
	this.update_flip()
	this.apply_gravity(delta)
	
