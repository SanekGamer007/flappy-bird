extends HSlider


@export var audio_bus_name: String = "Master"

@onready var _bus: int = AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	value = SaveSystem.get_var("AudioVolume", 0.5)
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
	SaveSystem.set_var("AudioVolume", value)
