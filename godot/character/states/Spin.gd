extends State

const y_boost : float = 100.0

func enter(from):
	this.velocity.y = -y_boost
	this.slash()
	
func update(delta):
	this.update_horizontal_movement(this.air_x_speed)
	# no gravity during spin!
	
