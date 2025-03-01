extends Node

@onready var coins: Label = $/root/Game/GameManager/UI/coins

var coin = 0

@export var sword_owned: bool = true
@export var sword2_owned: bool = false
@export var axe_owned: bool = false

@export var sword_equipped: bool = true
@export var sword2_equipped: bool = false
@export var axe_equipped: bool = false

@onready var player: Player = get_node("/root/Game/Player")

@onready var shop_ui: Node2D = $/root/Game/GameManager/UI/shop
@onready var shop_btn: Button = $/root/Game/GameManager/UI/shop_btn

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await get_tree().process_frame  # Wait for nodes to load
	coin_count()
	print(get_path())
	

	
func _physics_process(_delta: float) -> void:
	open_shop()

func add_point():
	coin += 1
	coin_count()

func coin_count():
	if coins == null:
		print("0")
	else:
		coins.text = ": " + str(coin)

# Functions to change equipment
func equip_sword():
	sword_equipped = true
	sword2_equipped = false
	axe_equipped = false
	if player:
		player.equip_weapon("sword")  # Ensure Player gets the correct weapon

func equip_sword2():
	sword_equipped = false
	sword2_equipped = true
	axe_equipped = false
	if player:
		player.equip_weapon("sword2")  # Ensure Player gets the correct weapon

func equip_axe():
	sword_equipped = false
	sword2_equipped = false
	axe_equipped = true
	if player:
		player.equip_weapon("axe")

func _on_shop_btn_pressed() -> void:
	get_node("UI/shop").show()
	get_node("UI/shop_btn").hide()

		
func open_shop():
	if Input.is_action_just_pressed("shop"):
		if shop_ui and shop_btn:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var viewport_size = get_viewport().get_visible_rect().size
			Input.warp_mouse(viewport_size / 2)
			shop_ui.show()
			shop_btn.hide()
	
