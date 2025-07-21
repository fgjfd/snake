extends Node2D

@onready var snake_sprite = $snake
@onready var anim = $AnimationPlayer
func _ready() -> void:

	anim.play("pass")
	await anim.animation_finished
	await get_tree().create_timer(0.2).timeout
	
	get_tree().change_scene_to_file(Address.need_address)
	
