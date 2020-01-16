extends Node2D

class_name Destructible

export var integrity : int = 3

func destroy():
	integrity -= 1
	
	if integrity <= 0:
		queue_free()
	
