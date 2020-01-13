extends State

func enter(from):
	this.emit_signal('harmed')
	
func exit(to):
	this.emit_signal('recovered')
	this.set_position(this.last_safe_position)
	