extends Node2D  

signal game_end(score)

const grid_size = Vector2(20, 20)
const cell_size = 20

enum State_Acting {STOP,IDLE,MOVE}
enum State_buff {GROW,IDLE}



@export var snake_init_length : int
@export var timer: float 
@export var const_move_interval: float 
@export var min_move_interval: float
@export var init_pos: Vector2
@export var speed_rate:	float


var food_position_num = []
var snake_num_index = []  
var body_sprites = []

var body_num_need_add_old : int
var body_num_need_add_new : int
var snake_length :int

var food_instance : Node2D
var snake_head : Node2D

var new_head_pos : Vector2
var cur_direction = Vector2.RIGHT
var old_direction = cur_direction
var pending_direction = cur_direction
var food_position : Vector2

var state_acting = State_Acting.STOP
var state_buff = State_buff.IDLE


var move_interval :float

var touch_move_direction :String

var food_preload = preload("res://apple/apple.tscn")
var snake_head_preload = preload("res://snake/snake_head/snake_head.tscn")
var snake_body_preload = preload("res://snake/snake_body/snake_body.tscn")



func _ready() -> void:
	init_snake()

func _process(delta:float) -> void:
	handle_input()
	turn_time(delta)
	turn()

func init_snake() -> void:
	#初始化身体数目
	snake_length = snake_init_length
	body_num_need_add_new = snake_init_length -1
	#初始化蛇头
	snake_num_index.append(Vector2(init_pos.x , init_pos.y))
	snake_head = snake_head_preload.instantiate()
	add_child(snake_head)
	snake_head.position = Vector2(snake_num_index[0].x * cell_size, snake_num_index[0].y * cell_size)
	#连接信号
	snake_head.die.connect(game_over)
	snake_head.eat_food.connect(food_eaten)
	#生成食物
	food_generated()
	
	
	
	
func turn():
	if state_acting == State_Acting.MOVE:
		grow_exam()
		speed()
		head_pos()
		instantiate_snake()
		update_snake_sprites()
		food_generated()
		state_acting = State_Acting.IDLE
		state_buff = State_buff.IDLE	
				
func turn_time(delta:float) -> void:
	if state_acting != State_Acting.STOP :
		timer += delta
		if timer > move_interval:
			state_acting = State_Acting.MOVE
			timer -= move_interval		


func head_pos() ->void:
	old_direction = cur_direction
	cur_direction = pending_direction
	new_head_pos = snake_num_index[0] + cur_direction

	if state_buff == State_buff.GROW:
		snake_num_index.push_front(new_head_pos)
				
	elif state_buff == State_buff.IDLE:
		snake_num_index.pop_back()            
		snake_num_index.push_front(new_head_pos)	



func speed() -> void:
	move_interval = max(const_move_interval-(snake_length-snake_init_length) * speed_rate, min_move_interval)


func grow_exam() -> void:
	if body_num_need_add_new != 0:
		state_buff = State_buff.GROW


func handle_input() -> void:
	if Input.is_action_pressed("move_up") and cur_direction != Vector2.DOWN:
		pending_direction = Vector2.UP
		
	elif Input.is_action_pressed("move_down") and cur_direction != Vector2.UP:
		pending_direction = Vector2.DOWN
	elif Input.is_action_pressed("move_right") and cur_direction != Vector2.LEFT:
		pending_direction = Vector2.RIGHT
	elif Input.is_action_pressed("move_left") and cur_direction != Vector2.RIGHT:
		pending_direction = Vector2.LEFT

		
func instantiate_snake() -> void:
	body_num_need_add_old = body_num_need_add_new

	if body_num_need_add_old != 0:		
		var snake_body = snake_body_preload.instantiate() 
		add_child(snake_body)
		body_sprites.append(snake_body)
		body_num_need_add_new -= 1
		snake_body.position = Vector2(snake_num_index[-1].x * cell_size, snake_num_index[-1].y * cell_size)
		
func update_snake_sprites() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(snake_head,"position", Vector2(snake_num_index[0].x * cell_size, snake_num_index[0].y * cell_size),move_interval)

	for i in range(1, snake_num_index.size()):
		tween.parallel().tween_property(body_sprites[i-1],"position",Vector2(snake_num_index[i].x * cell_size, snake_num_index[i].y * cell_size),move_interval)
		




func food_generated() -> void:
	if food_position_num.size() == 0:
		var valid_positions = []
		for x in range(1,grid_size.x-1):
			for y in range(1,grid_size.y-1):
				var pos = Vector2(x, y)
				if not position_in_snake(pos):
					valid_positions.append(pos)
		if valid_positions.size() > 0:
			food_position = valid_positions[randi() % valid_positions.size()]
			food_instance = food_preload.instantiate()
			add_child(food_instance)
			food_position_num.append(food_position)
			food_instance.position = Vector2(food_position.x * cell_size, food_position.y * cell_size)
			print("food" + str(food_instance.position))
		else:
			print("没有可用的位置来生成食物！")

		
func position_in_snake(pos: Vector2) -> bool:
	return pos in snake_num_index
	
func game_over() -> void:
	emit_signal("game_end",(snake_length-snake_init_length)*10) 

func food_eaten() -> void:
	SoundManager.player_ui("eat")
	body_num_need_add_new += 1
	food_instance.queue_free()
	food_position_num.clear()
	snake_length += 1

func  play_game() -> void:
	state_acting = State_Acting.IDLE
	
