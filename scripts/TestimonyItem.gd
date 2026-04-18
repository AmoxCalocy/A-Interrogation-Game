extends Label

func setup(testimony: TestimonyResource) -> void:
	text = "• " + testimony.summary
	tooltip_text = testimony.full_text
