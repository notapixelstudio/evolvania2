extends State

func enter(from):
	# stop when staggering
	this.velocity = Vector2(0,0)
	this.emit_signal('harmed')
	
func exit(to):
	this.emit_signal('recovered')
	this.set_position(this.safe_position)
	
