class_name Player
extends CharacterBody2D

@export var speed: int = 55
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: Area2D = $hurtBox
@export var attack_range: float = 60

@onready var respawn_timer: Timer = $RespawnTimer
@onready var dmg_timer: Timer = $dmgTimer
@onready var hp_regen_timer: Timer = $hpRegenTimer

@onready var weapon: Node2D = $Weapon
@onready var sword: Area2D = $Weapon/sword
@onready var sword2: Area2D = $Weapon/sword2
@onready var axe: Area2D = $Weapon/axe

@onready var game_manager: Node = %GameManager

signal healthChanged

var maxHealth: int = 100
var currentHealth: int = maxHealth
var isDead: bool = false

@export var health_regen_rate: float = 1  # How often to regain health
@export var health_regen_amount: int = 5

const DEFAULT_MODULATE = Color(1,1,1,1)


var lastAnimDirection: String = "Up"
var spawn_position: Vector2


func _ready() -> void:
	spawn_position = global_position
	hp_regen_timer.timeout.connect(_on_hp_regen_timer_timeout)
	weapon.disable()
	if game_manager.sword_equipped:
		equip_weapon("sword")
	elif game_manager.sword2_equipped:
		equip_weapon("sword2")
	elif game_manager.axe_equipped:
		equip_weapon("axe")

func handleInput():
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
		var attackDirection = get_attack_direction()
		animation.play("attack" + attackDirection)
		weapon.enable()
		await animation.animation_finished
		weapon.disable()

func get_attack_direction() -> String:
	var closest_enemy = find_nearest_enemy()
	
	if closest_enemy:
		var direction_vector = (closest_enemy.global_position - global_position).normalized()
		return get_direction_from_vector(direction_vector)

	return lastAnimDirection  # Default if no enemy is found

func find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemies") 
	
	var closest_enemy = null
	var min_distance = attack_range  # Max detection range
	
	for enemy in enemies:
		if not enemy is Enemy:
			continue
		
		# Skip dead enemies
		if enemy.isDead:
			continue
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy

	return closest_enemy

func get_direction_from_vector(vector: Vector2) -> String:

	if abs(vector.x) > abs(vector.y):
		return "Right" if vector.x > 0 else "Left"
	else:
		return "Down" if vector.y > 0 else "Up"

func updateAnimation():
	var direction = lastAnimDirection
	if velocity.x < 0: direction = "Left"
	elif velocity.x > 0: direction = "Right"
	elif velocity.y < 0: direction = "Up"
	elif velocity.y > 0: direction = "Down"
	
	if direction != lastAnimDirection:
		lastAnimDirection = direction
	
	
func _physics_process(delta: float) -> void:
	if isDead:
		velocity = Vector2.ZERO
		return
	handleInput()
	updateAnimation()
	
	if velocity.x > 0:
		animated_sprite.flip_h = false
	if velocity.x < 0:
		animated_sprite.flip_h = true
	
	if velocity.length() == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	#if velocity.y < 0:
		#animated_sprite.play("run_back")
	#else: 
		#animated_sprite.play("run")

	
	move_and_slide()
	


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_attack"):
		currentHealth -= 35
		healthChanged.emit()

		get_node("AnimatedSprite2D").modulate = Color(1, 0.3, 0.3)
		dmg_timer.start()
		
		hp_regen_timer.stop()
		hp_regen_timer.start(2.0) 
	
	if currentHealth <= 0: 
		isDead = true
		speed = 0
		animated_sprite.play("death")
		await animated_sprite.animation_finished
		respawn_timer.start()
		
		
	

func _on_respawn_timer_timeout() -> void:
	respawn_timer.stop()
	global_position = spawn_position  
	currentHealth = maxHealth
	healthChanged.emit()
	isDead = false
	speed = 45
	animated_sprite.play("idle")
	animated_sprite.modulate = DEFAULT_MODULATE


func _on_dmg_timer_timeout() -> void:
	get_node("AnimatedSprite2D").modulate = DEFAULT_MODULATE


func _on_hp_regen_timer_timeout() -> void:
	if currentHealth < maxHealth:
		currentHealth += health_regen_amount
		healthChanged.emit()
	hp_regen_timer.start(health_regen_rate)
		
func equip_weapon(weapon_name: String) -> void:
	if weapon_name == "sword":
		sword.show()
		sword2.hide()
		axe.hide()
		game_manager.sword_equipped = true
		game_manager.sword2_equipped = false
		game_manager.axe_equipped = false
		
	elif weapon_name == "sword2":
		sword.hide()
		sword2.show()
		axe.hide()
		game_manager.sword_equipped = false
		game_manager.sword2_equipped = true
		game_manager.axe_equipped = false
	
	elif weapon_name == "axe":
		sword.hide()
		sword2.hide()
		axe.show()
		game_manager.sword_equipped = false
		game_manager.sword2_equipped = false
		game_manager.axe_equipped = true
		
