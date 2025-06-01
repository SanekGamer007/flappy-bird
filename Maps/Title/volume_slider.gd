extends HSlider


@export var audio_bus_name: String = "Master"

@onready var _bus: int = AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	value = SaveSystem.get_var("AudioVolume", 0.5)
	AudioServer.set_bus_volume_linear(_bus, value)
func _on_value_changed(value: float) -> void:
	print(value, AudioServer.get_bus_volume_linear(_bus))
	AudioServer.set_bus_volume_linear(_bus, value)
	SaveSystem.set_var("AudioVolume", value)
