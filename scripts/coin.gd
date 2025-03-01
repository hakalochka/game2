extends Area2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_manager: Node = GameManager

func _on_body_entered(_body: Node2D) -> void:
	#game_manager = %GameManager
	game_manager.add_point()
	animation_player.play("pickup")
	

	
	
