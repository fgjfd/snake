extends CanvasLayer
			
@onready var achievement1 = $Control/HBoxContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/Label3
@onready var achievement2 = $Control/HBoxContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer/VBoxContainer2/HBoxContainer/Label3
@onready var achievement3 = $Control/HBoxContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Label3
@onready var achievement4 = $Control/HBoxContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer/VBoxContainer4/HBoxContainer/Label3
@onready var achievement5 = $Control/HBoxContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer/VBoxContainer5/HBoxContainer/Label3
@onready var max_grade_lebel = $Control/HBoxContainer/Control2/VBoxContainer/max_grade
@onready var game_play_count_label = $Control/HBoxContainer/Control2/VBoxContainer/game_play_count

func _ready() -> void:
	achievements_handle()

func achievements_handle() -> void :
	max_grade_lebel.text = "历史最高分为: " + str(Record.max_grade)
	game_play_count_label.text = "总游戏次数为: " + str(Record.game_play_count)
	
	if Record.max_grade >= 2000 :
		achievement1.text = "已获得" 
		achievement2.text = "已获得" 
		achievement3.text = "已获得" 
		achievement4.text = "已获得" 
		achievement5.text = "已获得" 
		
		
	if Record.max_grade >= 1000 and Record.max_grade <= 2000 :
		achievement1.text = "已获得" 
		achievement2.text = "已获得" 
		achievement3.text = "已获得" 
		achievement4.text = "已获得" 
		achievement5.text = "未获得" 
		
	if Record.max_grade >= 500 and Record.max_grade <= 1000 :
		achievement1.text = "已获得" 
		achievement2.text = "已获得" 
		achievement3.text = "已获得" 
		achievement4.text = "未获得" 
		achievement5.text = "未获得" 
		
	if Record.max_grade >= 250 and Record.max_grade <= 500 :
		achievement1.text = "已获得" 
		achievement2.text = "已获得" 
		achievement3.text = "未获得" 
		achievement4.text = "未获得" 
		achievement5.text = "未获得" 
		
	if Record.max_grade >= 30 and Record.max_grade <= 250 :
		achievement1.text = "已获得" 
		achievement2.text = "未获得" 
		achievement3.text = "未获得" 
		achievement4.text = "未获得" 
		achievement5.text = "未获得" 
		
	if Record.max_grade <= 30:
		achievement1.text = "获得" 
		achievement2.text = "未获得" 
		achievement3.text = "未获得" 
		achievement4.text = "未获得" 
		achievement5.text = "未获得" 


func _on_exit_pressed() -> void:
	SoundManager.player_ui("cancel")
	get_tree().change_scene_to_file("res://mainmenu/mainmenu.tscn")
