extends Node

@onready var coins: Label = $UI/coins

var coin = 0

@export var sword_owned: bool = true
@export var sword2_owned: bool = false

@export var sword_equipped: bool = true
@export var sword2_equipped: bool = false

@onready var player: Player = get_node("/root/Game/Player")


func _ready() -> void:
	# Initialize the sword equipment status

	sword_equipped = true
	sword2_equipped = false

func add_point():
	coin += 1
	coin_count()

func coin_count():
	coins.text = ": " + str(coin)

# Functions to change equipment
func equip_sword():
	sword_equipped = true
	sword2_equipped = false
	if player:
		player.equip_weapon("sword")  # Ensure Player gets the correct weapon

func equip_sword2():
	sword_equipped = false
	sword2_equipped = true
	if player:
		player.equip_weapon("sword2")  # Ensure Player gets the correct weapon


func _on_shop_btn_pressed() -> void:
	get_node("UI/shop").show()
	get_node("UI/shop_btn").hide()
