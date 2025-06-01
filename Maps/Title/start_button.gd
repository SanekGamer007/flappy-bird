extends TextureButton

func _on_pressed() -> void:
	if FadeManager.is_playing():
		FadeManager.stop()
	FadeManager.play("fadeinout")
	await get_tree().create_timer(1).timeout
	main.load_level("res://Maps/Main/main_map.tscn")
