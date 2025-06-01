extends Button

func _on_pressed() -> void:
	scoremanager.reset()
	FadeManager.play("fadeinoutquick")
	await get_tree().create_timer(0.375).timeout
	main.load_level("res://Maps/Main/main_map.tscn")
