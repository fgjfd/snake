extends HSlider

@export var bus: StringName = "Master"

@onready var bus_index := AudioServer.get_bus_index(bus)


func _ready() -> void:
	value = SoundManager.get_volume(bus_index)
	value_changed.connect(valuechanged)
	$"../Control3/master".text = "总音量： " + str(value * 100)
func valuechanged(v:float) -> void:
	SoundManager.set_volume(bus_index,v)
	Save.saving_volume()
	$"../Control3/master".text = "总音量： " +  str(value * 100)
