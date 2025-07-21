extends Node2D


@export  var phase_time = 60.0
@export var const_trap_interval = 5.0
# 网格大小(20x20)
const SIZE = 20
# 陷阱数组: true=有陷阱, false=无陷阱
var traps = []
# 活动中的陷阱列表 (类型, 索引, 激活时间, 节点引用)
var active_traps = []
var game_time = 0.0
var phase = 1  
var trap_interval :float  # 默认5秒
var trap_duration = 5.0  # 陷阱持续5秒
# 自动创建定时器
var spawn_timer: Timer
#生成范围不包括边界
var stance_scope = range(1,19)

var trap_instance = preload("res://trap/trap.tscn")

func _ready():
	# 初始化陷阱数组
	trap_interval = const_trap_interval 
	traps.resize(SIZE)
	for i in range(SIZE):
		traps[i] = []
		traps[i].resize(SIZE)
		for j in range(SIZE):
			traps[i][j] = false
	
	# 创建并设置定时器
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = trap_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()


func _process(delta):
   
	game_time += delta
	if game_time >= phase_time :
		phase += floori(game_time / phase_time) 
		trap_interval = max(const_trap_interval - phase, 3)
		spawn_timer.wait_time = trap_interval
		spawn_timer.start()		
		game_time -= phase_time
		
	_update_active_traps(delta)
	print(min(phase * 10,50))

# 当陷阱生成定时器触发时
func _on_spawn_timer_timeout():

	spawn_random_traps(min(phase * 10,50))  


# 随机生成指定数量的陷阱
func spawn_random_traps(count):
	var trap_nodes = []
	var empty_positions = []
	
	# 收集所有空位置
	for row in stance_scope:
		for col in stance_scope:
			if not traps[row][col]:
				empty_positions.append(Vector2(row, col))
	
	# 随机选择位置生成陷阱
	for i in range(min(count, empty_positions.size())):
		var random_index = randi() % empty_positions.size()
		var pos = empty_positions[random_index]
		
		
		var trap = trap_instance.instantiate()
		trap.position = Vector2(pos.x * SIZE, pos.y * SIZE)
		add_child(trap)
		trap_nodes.append(trap)
		traps[pos.x][pos.y] = true
	
	if trap_nodes.size() > 0:
		active_traps.append({
			"type": "random",
			"time_left": trap_duration,
			"nodes": trap_nodes
		})


# 更新并清理过期陷阱
func _update_active_traps(delta):
	var traps_to_remove = []
	
	# 更新陷阱剩余时间
	for i in range(active_traps.size()):
		active_traps[i].time_left -= delta
		
		# 检查是否过期
		if active_traps[i].time_left <= 0:
			traps_to_remove.append(i)
	
	# 移除过期陷阱（从后往前移除）
	traps_to_remove.reverse()
	for idx in traps_to_remove:
		var trap = active_traps.pop_at(idx)
		
		# 实际删除陷阱节点
		for node in trap.nodes:
			var grid_x = int(node.position.x / SIZE)
			var grid_y = int(node.position.y  / SIZE)
			traps[grid_x][grid_y] = false
			node.queue_free()
		
