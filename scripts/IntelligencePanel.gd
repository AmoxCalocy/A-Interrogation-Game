extends Control

@onready var evidence_list: VBoxContainer = $"Panel/TabContainer/证据档案/ScrollContainer/EvidenceList"
@onready var testimony_list: VBoxContainer = $"Panel/TabContainer/证词记录/ScrollContainer/TestimonyList"
@onready var history_list: VBoxContainer = $"Panel/TabContainer/对话回顾/ScrollContainer/HistoryList"
@onready var selected_label: Label = $Panel/SelectedInfo/Label

const EVIDENCE_ITEM = preload("res://scenes/EvidenceItem.tscn")
const TESTIMONY_ITEM = preload("res://scenes/TestimonyItem.tscn")
const HISTORY_ITEM = preload("res://scenes/HistoryItem.tscn")

func _ready() -> void:
	# Initial populate
	refresh_evidence()
	refresh_testimony()
	refresh_history()
	
	# Listen for selection changes (from anywhere in the game)
	GameState.evidence_selected.connect(_on_evidence_selected)
	GameState.testimony_recorded.connect(_on_testimony_recorded)
	GameState.history_updated.connect(_on_history_updated)

func refresh_evidence() -> void:
	# Clear list
	for child in evidence_list.get_children():
		child.queue_free()
	
	# Add items
	for evidence in GameState.collected_evidences:
		var item = EVIDENCE_ITEM.instantiate()
		evidence_list.add_child(item)
		item.setup(evidence)

func refresh_testimony() -> void:
	# Clear list
	for child in testimony_list.get_children():
		child.queue_free()
		
	# Add items
	for testimony in GameState.recorded_testimonies:
		var item = TESTIMONY_ITEM.instantiate()
		testimony_list.add_child(item)
		item.setup(testimony)

func refresh_history() -> void:
	# Clear list
	for child in history_list.get_children():
		child.queue_free()
		
	# Add items
	for entry in GameState.dialogue_history:
		var item = HISTORY_ITEM.instantiate()
		history_list.add_child(item)
		item.setup(entry["speaker"], entry["text"])

func _on_evidence_selected(id: String) -> void:
	# Update label
	for e in GameState.collected_evidences:
		if e.id == id:
			selected_label.text = "当前选中：" + e.name
			break

func _on_testimony_recorded(_testimony) -> void:
	refresh_testimony()

func _on_history_updated() -> void:
	refresh_history()
