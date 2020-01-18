extends Node2D

export var integrity : int = 6

func damage(amount, direction):
	integrity -= amount
	
	if integrity <= 0:
		queue_free()
	
