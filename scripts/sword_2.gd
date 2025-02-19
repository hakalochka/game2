extends Area2D
@onready var shape: CollisionShape2D = $CollisionShape2D

@export var damage: int = 15

func enable():
	shape.disabled = false
	
func disable():
	shape.disabled = true
