extends Area2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

@export var damage: int = 10

func enable():
	shape.disabled = false
	
func disable():
	shape.disabled = true
	
