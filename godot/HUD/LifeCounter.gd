tool
extends Node2D

export var life : int = 3 setget set_life
export var max_life : int = 3 setget set_max_life

func set_life(amount):
	life = amount
	refresh()
	
func set_max_life(amount):
	max_life = amount
	refresh()
	
func refresh():
	$hearts.region_rect = Rect2(Vector2(0,0), Vector2(80*life,80))
	$hearts_empty.region_rect = Rect2(Vector2(0,0), Vector2(80*max_life,80))
	
func lose_life(amount):
	set_life(max(0, life - amount))
	