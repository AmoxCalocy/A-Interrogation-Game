extends PanelContainer

@onready var speaker_label: Label = $VBoxContainer/Speaker
@onready var text_label: Label = $VBoxContainer/Text

func setup(speaker: String, content: String) -> void:
	speaker_label.text = speaker + ":"
	text_label.text = content
	
	# 根据说话人改变颜色
	if speaker == "警官":
		speaker_label.add_theme_color_override("font_color", Color.CYAN)
	else:
		speaker_label.add_theme_color_override("font_color", Color.GOLD)
