extends CanvasLayer



func saving_volume() -> void:
	var config = ConfigFile.new()
	config.set_value("audio","master",SoundManager.get_volume(SoundManager.Bus.Master))#分区，索引，数据
	config.set_value("audio","sfx",SoundManager.get_volume(SoundManager.Bus.SFX))
	config.set_value("audio","bgm",SoundManager.get_volume(SoundManager.Bus.BGM))
	config.save("user://audio.cfg")

	
func loading_volume() -> void:
	var config = ConfigFile.new()
	var result =config.load("user://audio.cfg")
	if result == OK:
		SoundManager.set_volume(SoundManager.Bus.Master,config.get_value("audio","master",1))
		SoundManager.set_volume(SoundManager.Bus.SFX,config.get_value("audio","sfx",1))
		SoundManager.set_volume(SoundManager.Bus.BGM,config.get_value("audio","bgm",1))
	else:
		print("erro")

func saving_record() -> void:
	var config = ConfigFile.new()
	config.set_value("record","max_grade",Record.max_grade)#分区，索引，数据
	config.set_value("record","game_play_count",Record.game_play_count)
	config.save("user://record.cfg")
	
func loading_record() -> void:
	var config = ConfigFile.new()
	var result =config.load("user://record.cfg")
	if result == OK :
		Record.max_grade = config.get_value("record","max_grade",0)
		Record.game_play_count = config.get_value("record","game_play_count",0)
	else:
		print("erro")
