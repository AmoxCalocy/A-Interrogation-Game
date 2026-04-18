extends Node

@onready var stress_bar: ProgressBar = $ControlLayer/HUD/StressBar/ProgressBar
@onready var defense_bar: ProgressBar = $ControlLayer/HUD/DefenseBar/ProgressBar
@onready var start_button: Button = $ControlLayer/StartButton
@onready var intel_panel: Control = $ControlLayer/IntelligencePanel
@onready var present_evidence_button: Button = $ControlLayer/RightControls/PresentEvidenceButton
@onready var suspect_selector: OptionButton = $ControlLayer/RightControls/SuspectSelector
@onready var right_controls: VBoxContainer = $ControlLayer/RightControls
@onready var result_panel: Control = $ControlLayer/ResultPanel
@onready var background_rect: TextureRect = $VisualsLayer/Background
@onready var portrait_rect: TextureRect = $VisualsLayer/SuspectPortrait

func _ready() -> void:
	_setup_initial_data()
	
	stress_bar.value = GameState.current_stress
	defense_bar.value = GameState.current_defense
	intel_panel.hide()
	right_controls.hide()
	result_panel.hide()
	
	_update_visuals()
	
	if intel_panel.has_method("refresh_evidence"):
		intel_panel.refresh_evidence()
	
	GameState.stress_changed.connect(_on_stress_changed)
	GameState.defense_changed.connect(_on_defense_changed)
	GameState.evidence_presented.connect(_on_evidence_presented)
	GameState.presentation_ui_toggled.connect(_on_presentation_ui_toggled)
	GameState.case_solved.connect(_on_case_solved)
	GameState.case_failed.connect(_on_case_failed)
	GameState.suspect_switched.connect(_on_suspect_switched)

func _setup_initial_data() -> void:
	GameState.collected_evidences.clear()
	GameState.recorded_testimonies.clear()
	
	var suspects: Array[SuspectResource] = [
		load("res://data/suspect_wang.tres"),
		load("res://data/suspect_li.tres")
	]
	GameState.setup_suspects(suspects)
	
	GameState.collected_evidences.append(load("res://data/evidence_knife.tres"))
	
	suspect_selector.clear()
	for i in range(GameState.active_suspects.size()):
		var s = GameState.active_suspects[i]
		suspect_selector.add_item(s.suspect_name, i)
		suspect_selector.set_item_metadata(i, s.id)

func _update_visuals() -> void:
	if GameState.current_suspect and GameState.current_suspect.portrait:
		portrait_rect.texture = GameState.current_suspect.portrait
		portrait_rect.modulate.a = 0
		create_tween().tween_property(portrait_rect, "modulate:a", 1.0, 0.5)
	else:
		portrait_rect.texture = null
	
	var bg_path = "res://assets/sprites/interrogation_room_bg.png"
	if FileAccess.file_exists(bg_path):
		background_rect.texture = load(bg_path)
	else:
		background_rect.texture = null

func _on_start_button_pressed() -> void:
	_play_ui_sfx("res://assets/audio/ui_click.wav")
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(start_button, "modulate:a", 0.0, 0.3)
	tween.tween_property(start_button, "scale", Vector2(1.2, 1.2), 0.3)
	await tween.finished
	start_button.hide()
	
	right_controls.show()
	suspect_selector.show()
	right_controls.modulate.a = 0
	create_tween().tween_property(right_controls, "modulate:a", 1.0, 0.5)
	
	_start_dialogue_for_current_suspect()

func _start_dialogue_for_current_suspect() -> void:
	if not _is_dialogue_manager_available() or GameState.current_suspect == null:
		printerr("【错误】Dialogue Manager 插件未启用或未选择嫌疑人！")
		return
	
	for child in get_tree().root.get_children():
		if child.name.contains("Balloon") or child.has_method("get_role"):
			child.queue_free()
	
	var dialogue_resource = load("res://data/main_dialogue.dialogue")
	var start_node = "start_" + GameState.current_suspect.id
	
	if not GameState.is_game_over:
		get_tree().root.get_node("DialogueManager").show_dialogue_balloon(dialogue_resource, start_node)

func _on_suspect_selector_item_selected(index: int) -> void:
	var suspect_id = suspect_selector.get_item_metadata(index)
	GameState.switch_suspect(suspect_id)

func _on_suspect_switched(_suspect: SuspectResource) -> void:
	present_evidence_button.disabled = true
	GameState.disable_presentation()
	_update_visuals()
	
	if not GameState.is_game_over:
		_start_dialogue_for_current_suspect()
	else:
		for child in get_tree().root.get_children():
			if child.name.contains("Balloon") or child.has_method("get_role"):
				child.queue_free()

func _on_stress_changed(new_value: int) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(stress_bar, "value", new_value, 0.6)

func _on_defense_changed(new_value: int) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(defense_bar, "value", new_value, 0.6)

func _on_intel_button_pressed() -> void:
	_play_ui_sfx("res://assets/audio/paper_slide.wav")
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	
	if intel_panel.visible:
		tween.tween_property(intel_panel, "position:x", intel_panel.position.x + 50, 0.3)
		tween.tween_property(intel_panel, "modulate:a", 0.0, 0.3)
		await tween.finished
		intel_panel.hide()
	else:
		intel_panel.modulate.a = 0
		intel_panel.position.x += 50
		intel_panel.show()
		tween.tween_property(intel_panel, "position:x", intel_panel.position.x - 50, 0.4)
		tween.tween_property(intel_panel, "modulate:a", 1.0, 0.4)

func _on_present_evidence_button_pressed() -> void:
	var btn_tween = create_tween()
	btn_tween.tween_property(present_evidence_button, "scale", Vector2(0.9, 0.9), 0.05)
	btn_tween.tween_property(present_evidence_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	_play_ui_sfx("res://assets/audio/ui_click.wav")
	GameState.present_evidence()

func _on_evidence_presented(_is_correct: bool) -> void:
	var dialogue_resource = load("res://data/main_dialogue.dialogue")
	if _is_dialogue_manager_available() and GameState.current_suspect != null:
		var node = "on_evidence_presented_" + GameState.current_suspect.id
		get_tree().root.get_node("DialogueManager").show_dialogue_balloon(dialogue_resource, node)

func _on_presentation_ui_toggled(is_enabled: bool) -> void:
	present_evidence_button.disabled = !is_enabled
	if is_enabled:
		var tween = create_tween()
		tween.tween_property(present_evidence_button, "modulate", Color(1.5, 1.5, 1.5), 0.2)
		tween.tween_property(present_evidence_button, "modulate", Color.WHITE, 0.2)

func _on_case_solved() -> void:
	if result_panel.has_method("set_result"):
		result_panel.set_result(true)
	_show_result_panel()

func _on_case_failed() -> void:
	present_evidence_button.disabled = true
	if _is_dialogue_manager_available():
		for child in get_tree().root.get_children():
			if child.name.contains("Balloon") or child.has_method("get_role"):
				child.queue_free()
	
	if result_panel.has_method("set_result"):
		result_panel.set_result(false)
	_show_result_panel()

func _show_result_panel() -> void:
	await get_tree().create_timer(1.0).timeout
	
	if GameState.current_defense >= 90:
		_play_ui_sfx("res://assets/audio/impact_fail.wav")
	else:
		_play_ui_sfx("res://assets/audio/impact_success.wav", 5.0)
	
	result_panel.show()
	result_panel.modulate.a = 0
	create_tween().tween_property(result_panel, "modulate:a", 1.0, 0.8)

func _play_ui_sfx(path: String, vol: float = 0.0) -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx(path, vol)

func _is_dialogue_manager_available() -> bool:
	return has_node("/root/DialogueManager")
