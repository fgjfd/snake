extends CanvasLayer


func _on_exit_pressed() -> void:
	SoundManager.player_ui("cancel")
	get_tree().change_scene_to_file("res://mainmenu/mainmenu.tscn")
