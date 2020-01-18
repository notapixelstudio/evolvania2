extends Node2D

class_name Destructible

export var integrity : int = 6

func damage(amount):
	integrity -= amount
	
	if integrity <= 0:
		queue_free()
	
