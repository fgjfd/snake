extends Node 
 
var const_trap_interval = 5.0
var phase_time = 60.0

# 网格大小(20x20) 
const SIZE = 20 
# 陷阱数组: true=有陷阱, false=无陷阱 
var traps = [] 
# 活动中的陷阱列表 (类型, 索引, 激活时间, 节点引用) 
var active_traps = [] 
 
var game_time = 0.0 
var phase = 1  # 1=第一分钟, 2=第二分钟

var trap_interval = const_trap_interval # 
var trap_duration = 5.0  # 陷阱持续5秒 
var stance_scope = range(1,19)
# 自动创建定时器 
var spawn_timer: Timer 

var trap_instance = preload("res://trap/trap.tscn") 
 
func _ready(): 	# 初始化陷阱数组 
	traps.resize(SIZE) 
	for i in range(SIZE): 
		traps[i] = [] 
		traps[i].resize(SIZE) 
		for j in range(SIZE): 
			traps[i][j] = false 
	 
	# 创建并设置定时器 
	spawn_timer = Timer.new() 
	add_child(spawn_timer) 
	trap_interval = const_trap_interval
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
 
# 当陷阱生成定时器触发时 
func _on_spawn_timer_timeout(): 
	if phase == 1:
	# 第一阶段：随机一整行或一整列
		var trap_type = randi() % 2  # 0=行, 1=列
		var index = randi() % 18 + 1
	
		if trap_type == 0:
			activate_row_trap(index)
		else:
			activate_col_trap(index)
	elif phase == 2:
	# 第二阶段：随机两行、两列或一行一列
		var pattern = randi() % 3  # 0=两行, 1=两列, 2=一行一列
	
		if pattern == 0:
		# 激活两行
			activate_row_trap(randi() % 18 + 1)
			activate_row_trap(randi() % 18 + 1)
		elif pattern == 1:
		# 激活两列
			activate_col_trap(randi() % 18 + 1)
			activate_col_trap(randi() % 18 + 1)
		else:
		# 激活一行一列
			activate_row_trap(randi() % 18 + 1)
			activate_col_trap(randi() % 18 + 1)
	else:  # phase >= 3
	# 第三阶段及以上：随机激活4次行列组合
		for i in range(4):
		# 随机选择行或列
			if randi() % 2 == 0:
				activate_row_trap(randi() % 18 + 1)
			else:
				activate_col_trap(randi() % 18 + 1)
			
# 激活整行陷阱 
func activate_row_trap(row): 
	var trap_nodes = [] 
	for col in stance_scope: 
		var trap = trap_instance.instantiate() 
		# 修正位置计算，假设SIZE是网格单元格大小 
		trap.position = Vector2(row * SIZE, col * SIZE) 
		add_child(trap) 
		trap_nodes.append(trap) 
		traps[row][col] = true 
	active_traps.append({ 
		"type": "row", 
		"index": row, 
		"time_left": trap_duration, 
		"nodes": trap_nodes 
	}) 
	print("激活第 %d 行陷阱" % row) 
 
# 激活整列陷阱 
func activate_col_trap(col): 
	var trap_nodes = [] 
	for row in stance_scope: 
		var trap = trap_instance.instantiate() 
		# 修正位置计算，假设SIZE是网格单元格大小 
		trap.position = Vector2(row * SIZE, col * SIZE) 
		add_child(trap) 
		trap_nodes.append(trap) 
		traps[row][col] = true 
	active_traps.append({ 
		"type": "col", 
		"index": col, 
		"time_left": trap_duration, 
		"nodes": trap_nodes 
	}) 
	print("激活第 %d 列陷阱" % col) 
 
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
			node.queue_free() 
		 
		# 取消陷阱逻辑状态 
		if trap.type == "row": 
			for col in range(SIZE): 
				traps[trap.index][col] = false 
			print("第 %d 行陷阱已移除" % trap.index) 
		else: 
			for row in range(SIZE): 
				traps[row][trap.index] = false 
			print("第 %d 列陷阱已移除" % trap.index) 
