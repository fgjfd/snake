extends ParallaxBackground
@export var speed = 50

func _process(delta: float) -> void:
	scroll_offset.x -= speed * delta
