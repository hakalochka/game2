extends Node2D

#@onready var game_manager: Node = %GameManager


@onready var sword: Area2D = $sword
@onready var sword2: Area2D = $sword2
@onready var axe: Area2D = $axe

var weapon: Area2D

func _ready() -> void:
	if get_children().is_empty(): return
	
	weapon = get_children()[0]

func enable():
	visible = true
	if GameManager.sword_equipped:
		sword.enable()
		sword2.disable()
		axe.disable()
	elif GameManager.sword2_equipped:
		sword2.enable()
		sword.disable()
		axe.disable()
	elif GameManager.axe_equipped:
		sword2.disable()
		sword.disable()
		axe.enable()

func disable():
	visible = false
	sword.disable()
	sword2.disable()
	axe.disable()

func swap_weapon(new_weapon: Area2D) -> void:
	if weapon:
		weapon.hide()  # Hide previous weapon
		weapon.disable()  # Disable previous weapon
	weapon = new_weapon
	weapon.show()  # Show new weapon
	weapon.enable()  # Enable new weapon
	
