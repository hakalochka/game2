class_name Enemy
extends CharacterBody2D
@onready var hurt_box: Area2D = $hurtBox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_check: Area2D = $playerCheck
@onready var LOS: RayCast2D = $lineOfSight
@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var dmg_timer: Timer = $dmgTimer
@onready var respawn_timer: Timer = $respawnTimer

@export var speed: int = 25
@export var player = null
@export var stop_distance: float = 5

@export var coin_scene = preload("res://scenes/coin.tscn")
@export var coin_drop_count: int = 2

signal healthChanged

var maxHealth: int = 30
var currentHealth: int = maxHealth
var isDead: bool = false
var spawn_position: Vector2


const DEFAULT_MODULATE = Color(1,1,1,1)

func _ready() -> void:
	spawn_position = global_position

func updateAnimation(direction: Vector2):
	if isDead: return
	if direction.length() == 0:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")
	else:
		if animated_sprite.animation != "move":
			animated_sprite.play("move")
	#if direction.length() == 0:
		#animated_sprite.play("idle")
	#else:
		#animated_sprite.play("move")


func _physics_process(delta: float) -> void:
	
	if isDead: return
	
	if player:
		# Update RayCast2D direction dynamically
		LOS.target_position = player.global_position - global_position
		LOS.force_raycast_update()  # Force an immediate update
		if has_clear_line_of_sight():
			var distance_to_player = global_position.distance_to(player.global_position)
			if distance_to_player > stop_distance:
				var direction = (player.global_position - global_position).normalized()
				if direction.length() > 0:
					global_position += direction * speed * delta
				
				updateAnimation(direction)
				#global_position += direction * speed * delta
				#updateAnimation(direction)
	

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Weapons"):
		var damage = area.damage
		currentHealth -= damage
		healthChanged.emit()
		get_node("AnimatedSprite2D").modulate = Color(1, 0.3, 0.3)
		dmg_timer.start()
		
		if currentHealth <= 0:
			isDead = true
			drop_coins()
			animation.play("death")
			await animation.animation_finished  
			hide_enemy()
			respawn_timer.start()

func _on_dmg_timer_timeout() -> void:
	get_node("AnimatedSprite2D").modulate = DEFAULT_MODULATE

func _on_player_check_body_entered(body: Node2D) -> void:
	if body is Player: player = body

func _on_player_check_body_exited(body: Node2D) -> void:
	if body is Player: player = null
	
func has_clear_line_of_sight() -> bool:
	if not player: 
		return false 
	return not LOS.is_colliding() or LOS.get_collider() == player
	
func drop_coins():
	var min_coins = 1  # Set minimum number of coins dropped
	var max_coins = 3  # Set maximum number of coins dropped
	var coin_drop_count = randi_range(min_coins, max_coins)
	
	for i in range(coin_drop_count):
		var coin = coin_scene.instantiate()
		get_tree().get_root().add_child(coin)
		
		var game_manager = %GameManager
		if game_manager:
			coin.game_manager = game_manager  # Pass the reference to the coin
		# Position coins randomly around the enemy
		var random_offset = Vector2(randf_range(-7, 7), randf_range(-7, 7))
		coin.global_position = global_position + random_offset



func _on_respawn_timer_timeout() -> void:
	isDead = false
	currentHealth = maxHealth
	healthChanged.emit()
	global_position = spawn_position  
	show_enemy()   
	respawn_timer.stop()
	animated_sprite.play("idle")

func hide_enemy():
	# Hide the entire enemy
	hide()  
	$CollisionShape2D.set_deferred("disabled", true)  
	$hurtBox/CollisionShape2D.set_deferred("disabled", true) 
	$hitBox/CollisionShape2D.set_deferred("disabled", true)
	$playerCheck/CollisionShape2D.set_deferred("disabled", true) 
	
func show_enemy():
	# Hide the entire enemy
	show()  
	$CollisionShape2D.set_deferred("disabled", false)  
	$hurtBox/CollisionShape2D.set_deferred("disabled", false) 
	$hitBox/CollisionShape2D.set_deferred("disabled", false)
	$playerCheck/CollisionShape2D.set_deferred("disabled", false) 
