extends Node2D

@onready var game_manager: Node = %GameManager
@onready var info2: Label = $sword2/info2

func _on_close_pressed() -> void:
	hide()
	game_manager.get_node("UI/shop_btn").show()


func _on_buy_2_pressed() -> void:
	if game_manager.coin >= 10:
		game_manager.coin -= 10
		game_manager.sword2_owned = true
		game_manager.coin_count()
		info2.text = "Owned"
		get_node("sword2/buy2").hide()
		get_node("sword2/equip2").show()
		


func _on_equip_2_pressed() -> void:
	if game_manager.sword2_owned:
		GameManager.equip_sword2()
		get_node("sword1/equiped").hide()
		get_node("sword1/equip").show()
		get_node("sword2/equiped2").show()
		get_node("sword2/equip2").hide()

func _on_equip_pressed() -> void:
	if game_manager.sword_owned:
		GameManager.equip_sword()
		get_node("sword1/equiped").show()
		get_node("sword1/equip").hide()
		get_node("sword2/equiped2").hide()
		get_node("sword2/equip2").show()
