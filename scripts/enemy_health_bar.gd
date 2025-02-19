extends TextureProgressBar

@export var enemy: Enemy

func _ready():
	enemy.healthChanged.connect(update)
	update()
	
"""func _process(delta: float) -> void:
	enemy.healthChanged.connect(update)
	update()"""

func update():
	value = enemy.currentHealth * 100 / enemy.maxHealth
