extends Label

func _process(delta: float) -> void:
	text = str(scoremanager.score)
