extends State

# coyote time - see https://www.yoyogames.com/blog/544/flynn-advanced-jump-mechanics
const COYOTE_TIME : float = 0.1
var coyote_time : float = COYOTE_TIME

func enter(from):
	this.get_node('Graphics/StepsParticles').emitting = true
	coyote_time = COYOTE_TIME
	
func update(delta):
	coyote_time -= delta
	if this.velocity.y <= 0:
		coyote_time = COYOTE_TIME
	
	if this.velocity.y > 0 and coyote_time <= 0:
		state_machine.travel('Falling')
	elif this.controls.grace_jump_down:
		state_machine.travel('Jumping')
	elif this.controls.x_dir == 0:
		state_machine.travel('Idle')
	
	this.update_horizontal_movement(this.x_speed)
	this.apply_gravity(delta) # needed to fall
	
func exit(to):
	this.get_node('Graphics/StepsParticles').emitting = false
	