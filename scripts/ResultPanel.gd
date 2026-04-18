extends Control

@onready var title_label: Label = $CenterContainer/VBoxContainer/Title
@onready var desc_label: Label = $CenterContainer/VBoxContainer/Description

func set_result(is_success: bool) -> void:
	if is_success:
		title_label.text = "案 件 破 获"
		desc_label.text = "嫌疑人王某已经交代了全部犯罪事实。\n真相大白，正义得以伸张。"
	else:
		title_label.text = "审 讯 失 败"
		desc_label.text = "嫌疑人对你的提问产生极大抵触情绪，拒绝配合。\n审讯被迫终止。"

func _on_restart_button_pressed() -> void:
	# 全局重置数据
	GameState.reset()
	
	# 重启背景音乐
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_ambience()
		
	# 重新加载当前场景 (这是最干净的重置方式)
	get_tree().reload_current_scene()
