extends HSlider


@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	if SaveSystem.get_var("AudioVolume"):
		value = SaveSystem.get_var("AudioVolume")
	else:
		return
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
	SaveSystem.set_var("AudioVolume", value)
