extends HSlider

@export var bus: StringName = "BGM"

@onready var bus_index := AudioServer.get_bus_index(bus)


func _ready() -> void:
	value = SoundManager.get_volume(bus_index)
	value_changed.connect(valuechanged)
	$"../Control/BACKGROUND".text = "背景音乐： " + str(value * 100)

func valuechanged(v:float) -> void:
	SoundManager.set_volume(bus_index,v)
	Save.saving_volume()
	$"../Control/BACKGROUND".text = "背景音乐： " + str(value * 100)
