extends Node2D


func _ready() -> void:
	SoundManager.player_background("idle")

func _on_start_pressed() -> void:
	SoundManager.player_ui("confirm")
	Address.need_address =Address.address["mainmenu"] 
	get_tree().change_scene_to_file(Address.address["sceneloader"])

func _on_exit_pressed() -> void:
	SoundManager.player_ui("cancel")
	await get_tree().create_timer(0.1).timeout#防止没播放音效就
	get_tree().quit()
