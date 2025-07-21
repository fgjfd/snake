extends TouchScreenButton
const DRAG_RADIUS = 30
var finger_index := -1
var drag_offset : Vector2
var rest_pos : Vector2

func _ready():
	update_joystick_position_and_size()
	get_viewport().size_changed.connect(update_joystick_position_and_size)
func update_joystick_position_and_size():
	var viewport_size = get_viewport_rect().size
	rest_pos = Vector2(viewport_size.x * 1/10, viewport_size.y * 2/3)
	var constscale = Vector2(1,1)
	scale = constscale * viewport_size.x/20 * 0.1
	global_position = get_canvas_transform() * rest_pos
func _input(event:InputEvent) -> void:
	var st := event as InputEventScreenTouch
	if st:
		if st.pressed and finger_index == -1:
			var global_pos := get_global_mouse_position()
			var local_pos := to_local(global_pos)
			var rect := Rect2(Vector2.ZERO, texture_normal.get_size())
			if rect.has_point(local_pos):
				finger_index = st.index
				drag_offset = global_pos - global_position
		elif not st.pressed and st.index == finger_index:
			release_button()
			finger_index = -1
			global_position = rest_pos  # 释放后立即回到原位
	var sd := event as InputEventScreenDrag
	if sd and sd.index == finger_index:
		var wish_pos := sd.position * get_canvas_transform() - drag_offset
		var movement := (wish_pos - rest_pos).limit_length(DRAG_RADIUS)
		global_position = rest_pos + movement
		movement /= DRAG_RADIUS
		
		# 水平方向控制优化
		if abs(movement.x) > abs(movement.y):
			if movement.x > 0.3:
				release_button()
				Input.action_press("move_right", 1.0)
			elif movement.x < -0.3:
				release_button()
				Input.action_press("move_left", 1.0)
			else:
				Input.action_release("move_left")
				Input.action_release("move_right")
		# 垂直方向控制优化
		else:
			if movement.y > 0.3:
				release_button()
				Input.action_press("move_down", 1.0)
			elif movement.y < -0.3:
				release_button()
				Input.action_press("move_up", 1.0)
			else:
				release_button()
	
func release_button() -> void:
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("move_up")
	Input.action_release("move_down")
