extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 测试读取 GameState 中的变量
	print("【测试成功】初始压力值为: ",
GameState.current_stress)

	# 测试调用 GameState 中的方法
	GameState.adjust_stress(10)
	print("【测试成功】增加后压力值为: ",
GameState.current_stress)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
