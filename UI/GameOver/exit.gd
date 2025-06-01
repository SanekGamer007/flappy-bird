extends Button

func _on_pressed() -> void:
	scoremanager.reset()
	FadeManager.play("fadeinout")
	await get_tree().create_timer(1).timeout
	main.load_level("res://Maps/Title/title.tscn")
