extends Node2D

var max_grade : int = 0

var game_play_count = 0:
	set(value):
		game_play_count = value
		Save.saving_record()

var common_grade = 0:
	set(value):
		common_grade = value
		if common_grade > max_grade:
			max_grade = common_grade
			Save.saving_record()
			
			
			
			

	
func _ready() -> void:
	Save.loading_record()
