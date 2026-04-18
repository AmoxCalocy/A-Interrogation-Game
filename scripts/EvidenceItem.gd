extends Button

var evidence_id: String = ""

func setup(evidence: EvidenceResource) -> void:
	evidence_id = evidence.id
	text = evidence.name
	tooltip_text = evidence.description
	pivot_offset = size / 2

func _on_pressed() -> void:
	# 【动效】点击反馈
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
	# 【音效】播放点击音
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("res://assets/audio/ui_click.wav")
	
	# 【修改】通过 GameState 内部方法处理选中逻辑，消除编译器警告
	GameState.select_evidence(evidence_id)

func _on_mouse_entered() -> void:
	# 【动效】悬停
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.2)
	tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.2)
	
	# 【音效】播放悬停音
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("res://assets/audio/ui_hover.wav", -10.0)

func _on_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
