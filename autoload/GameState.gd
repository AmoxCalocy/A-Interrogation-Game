extends Node

# --- 案件状态数据字典 ---
var suspects_state: Dictionary = {} # 存储 { "suspect_id": { "stress": int, "defense": int, "is_game_over": bool } }
var active_suspects: Array[SuspectResource] = []

# --- 当前选中的嫌疑人状态 ---
var current_suspect: SuspectResource
var current_stress: int = 0
var current_defense: int = 0
var is_game_over: bool = false # 防止重复触发结算

# --- 玩家状态 ---
var collected_evidences: Array[EvidenceResource] = []
var recorded_testimonies: Array[TestimonyResource] = []
var selected_evidence_id: String = ""

# --- 对话历史记录 ---
var dialogue_history: Array = [] # 存储 {"speaker": String, "text": String}

# --- 逻辑变量 (用于对话系统) ---
var required_evidence_id: String = "" 
var chen_asked_school: bool = false
var chen_asked_time: bool = false

# --- 核心信号 ---
signal stress_changed(new_value: int)
signal defense_changed(new_value: int)
signal evidence_selected(evidence_id: String)
signal testimony_recorded(testimony: TestimonyResource)
signal evidence_presented(is_correct: bool)
signal presentation_ui_toggled(is_enabled: bool)
signal case_solved()
signal case_failed()
signal suspect_switched(suspect: SuspectResource)
signal history_updated() # 对话历史更新信号

# --- 核心方法 ---
func setup_suspects(suspects: Array[SuspectResource]) -> void:
	active_suspects = suspects
	suspects_state.clear()
	for s in suspects:
		suspects_state[s.id] = {
			"stress": s.base_stress,
			"defense": s.base_defense,
			"is_game_over": false
		}
	if active_suspects.size() > 0:
		current_suspect = null
		switch_suspect(active_suspects[0].id)

func switch_suspect(suspect_id: String) -> void:
	# 1. 保存当前状态
	if current_suspect != null:
		suspects_state[current_suspect.id] = {
			"stress": current_stress,
			"defense": current_defense,
			"is_game_over": is_game_over
		}
	
	# 2. 寻找新嫌疑人并恢复状态
	for s in active_suspects:
		if s.id == suspect_id:
			current_suspect = s
			var state = suspects_state[s.id]
			current_stress = state["stress"]
			current_defense = state["defense"]
			is_game_over = state["is_game_over"]
			
			suspect_switched.emit(current_suspect)
			stress_changed.emit(current_stress)
			defense_changed.emit(current_defense)
			break

func adjust_stress(amount: int) -> void:
	if is_game_over: return
	current_stress = clamp(current_stress + amount, 0, 100)
	stress_changed.emit(current_stress)

func adjust_defense(amount: int) -> void:
	if is_game_over: return
	current_defense = clamp(current_defense + amount, 0, 100)
	defense_changed.emit(current_defense)
	
	if current_defense >= 90 and not is_game_over:
		is_game_over = true
		case_failed.emit()

func add_testimony(testimony: TestimonyResource) -> void:
	if is_game_over: return
	if not recorded_testimonies.has(testimony):
		recorded_testimonies.append(testimony)
		testimony_recorded.emit(testimony)

func has_testimony(id: String) -> bool:
	for t in recorded_testimonies:
		if t.id == id:
			return true
	return false

# 封装证据选中逻辑
func select_evidence(evidence_id: String) -> void:
	if is_game_over: return
	selected_evidence_id = evidence_id
	evidence_selected.emit(evidence_id)

# 【新增】添加对话到历史回顾
func add_to_history(speaker: String, text: String) -> void:
	dialogue_history.append({"speaker": speaker, "text": text})
	history_updated.emit()

func can_get_clue(req_stress: int, max_defense: int) -> bool:
	return current_stress >= req_stress and current_defense <= max_defense

func present_evidence() -> void:
	if is_game_over: return
	var is_correct = (selected_evidence_id == required_evidence_id and required_evidence_id != "")
	evidence_presented.emit(is_correct)

func enable_presentation(req_id: String) -> void:
	required_evidence_id = req_id
	presentation_ui_toggled.emit(true)

func disable_presentation() -> void:
	required_evidence_id = ""
	presentation_ui_toggled.emit(false)

func solve_case() -> void:
	if not is_game_over:
		is_game_over = true
		case_solved.emit()

func reset() -> void:
	current_stress = 0
	current_defense = 0
	is_game_over = false
	collected_evidences.clear()
	recorded_testimonies.clear()
	dialogue_history.clear() # 清空历史
	selected_evidence_id = ""
	required_evidence_id = ""
	chen_asked_school = false
	chen_asked_time = false
	presentation_ui_toggled.emit(false)
	current_suspect = null
