extends Node2D

signal play_game

@onready var stop_menu = $ui/stop_menu
@onready var begin_and_die_menu = $ui/begin_and_die_menu
@onready var playgame = $ui/begin_and_die_menu/Control/playgame
@onready var panel_restart =$ui/begin_and_die_menu/Control/HBoxContainer
@onready var point_text = $ui/begin_and_die_menu/Control/HBoxContainer/VBoxContainer/Panel/VBoxContainer/point
@onready var player_touch = $ui/player_touch
@onready var paused_button = $ui/player_touch/Control/VBoxContainer
@onready var snake_manager =$Control/background/snake_manager

var left = "left"
var right = "right"
var up = "up"
var down = "down"
var mode_order_instance = preload("res://mode/mode_order.tscn")
var mode_random_instance = preload("res://mode/mode_random.tscn")


func _ready() -> void:
	
	mode()
	
	begin_and_die_menu.visible = true	
	playgame.visible = true
	panel_restart.visible = false
	stop_menu.visible = false
	player_touch.visible = false
	play_game.connect(snake_manager.play_game)
	snake_manager.game_end.connect(game_end)
	



#暂停键按下
func _on_paused_pressed() -> void:
	get_tree().paused = true
	player_touch.visible = false
	stop_menu.visible = true
	SoundManager.player_ui("pause")
	
#panel中的三个选项
func _on_resume_pressed() -> void:#继续
	get_tree().paused = false
	stop_menu.visible = false
	player_touch.visible = true	
	SoundManager.player_ui("resume")
	
func _on_back_to_scene_pressed() -> void:#退到上一级
	get_tree().paused = false
	Address.need_address = Address.address["start"]
	get_tree().change_scene_to_file(Address.address["sceneloader"])
	SoundManager.stop_all_music()
	SoundManager.player_ui("resume")
func _on_exit_pressed() -> void:#退出游戏
	SoundManager.player_ui("cancel")
	await get_tree().create_timer(0.1).timeout#防止没播放音效就结束
	get_tree().quit()


#开始游戏按键
func _on_playgame_pressed() -> void:
	begin_and_die_menu.visible = false
	playgame.visible = false
	player_touch.visible = true
	emit_signal("play_game")
	SoundManager.player_ui("saved")
	SoundManager.stop_all_music()
	SoundManager.player_background("gaming")
	Record.game_play_count += 1
#结束游戏
func game_end(score) -> void:
	SoundManager.stop_all_music()
	SoundManager.player_background("gameover")
	player_touch.visible = false	
	begin_and_die_menu.visible = true
	playgame.visible = false
	panel_restart.visible = true
	point_text.text = "您的得分为" + str(score)
	Record.common_grade = score
	get_tree().paused = true
	
#重新开始选项	
func _on_restart_pressed() -> void:
	SoundManager.stop_all_music()
	SoundManager.player_ui("saved")
	get_tree().paused = false
	Address.need_address = Address.address["test"]
	get_tree().change_scene_to_file(Address.address["sceneloader"])



func mode() -> void:
	if ModeChange.choose_mode == "ordered":
		var mode_order = mode_order_instance.instantiate()
		var parent_node = get_node("Control/background")
		parent_node.add_child(mode_order)
		
	elif ModeChange.choose_mode == "random":
		var mode_random = mode_random_instance.instantiate()
		var parent_node = get_node("Control/background")
		parent_node.add_child(mode_random)
	
