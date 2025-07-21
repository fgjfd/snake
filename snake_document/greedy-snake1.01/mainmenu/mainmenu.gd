extends Node2D


func _ready() -> void:
	$Control.visible = true
	$classic_mode.visible = false
func _on_test_pressed() -> void:
	SoundManager.player_ui("confirm")
	$Control.visible = false
	$classic_mode.visible = true
	

func _on_exit_pressed() -> void:
	
	Address.need_address = Address.address["start"]
	get_tree().change_scene_to_file(Address.address["sceneloader"])	
	


func _on_texture_button_pressed() -> void:
	SoundManager.player_ui("cancel")
	$Control.visible = true
	$volume.visible  = false
	$achievements.visible = false
	
func _on_volume_pressed() -> void:
	SoundManager.player_ui("openmenu")
	get_tree().change_scene_to_file("res://UI/volumeslider/volumeslider.tscn")

func _on_achievement_pressed() -> void:
	SoundManager.player_ui("openmenu")
	get_tree().change_scene_to_file("res://achievements/achievements.tscn")
	



func _on_ordered_pressed() -> void:
	
	ModeChange.choose_mode = "ordered"
	SoundManager.player_ui("confirm")
	Address.need_address = Address.address["test"]
	get_tree().change_scene_to_file(Address.address["sceneloader"])	
	

func _on_random_pressed() -> void:
	ModeChange.choose_mode = "random"
	SoundManager.player_ui("confirm")
	Address.need_address = Address.address["test"]
	get_tree().change_scene_to_file(Address.address["sceneloader"])	
