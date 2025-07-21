class_name Snake_Head
extends CharacterBody2D
signal die
signal eat_food

@onready var collide_area := $collide
@onready var receiver_area := $receiver

func _ready() -> void:
	collide_area.area_entered.connect(end)
	receiver_area.area_entered.connect(snake_ate)
	
func end(_area) -> void:
	emit_signal("die")
	
func snake_ate(_area) -> void:
	emit_signal("eat_food")






	
	
