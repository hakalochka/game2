extends Area2D
@onready var shape: CollisionPolygon2D = $CollisionPolygon2D

@export var damage: int = 30

func enable():
	shape.disabled = false
	
func disable():
	shape.disabled = true
