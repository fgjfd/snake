extends Node
@onready var ui : Node = $ui
@onready var background : Node = $background
var playerui :AudioStreamPlayer
var playerbac :AudioStreamPlayer
enum Bus {Master, SFX, BGM}
func _ready() -> void:
	Save.loading_volume()

func player_ui(name) -> void:
	playerui = ui.get_node(name)
	playerui.play()
	

func player_background(name) -> void:
	playerbac = background.get_node(name)
	playerbac.play()


func stop_all_music():
	# 停止 UI 音效
	if playerui and playerui.is_playing():
		playerui.stop()
	# 停止背景音乐
	if playerbac and playerbac.is_playing():
		playerbac.stop()





func get_volume(bus_index:int) -> float:
	var db := AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)
	
	
func set_volume(bus_index: int,v: float) ->void:
	var db := linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index,db)
	
