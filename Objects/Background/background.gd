extends Parallax2D
var isday: bool = true
var birdexists: bool = false

func _ready() -> void:
	if get_node_or_null(^"../Bird"):
		birdexists = true
		(get_node(^"../Bird") as Bird).died.connect(_on_bird_died)
	else:
		print_debug("nobrd")

func _on_daycycle_timeout() -> void:
	if isday == true:
		print_debug("day to night")
		isday = false
		(get_node(^"AnimationPlayer")as AnimationPlayer).play("Day_to_night")
	else:
		print_debug("night to day")
		isday = true
		(get_node(^"AnimationPlayer") as AnimationPlayer).play("Night_to_Day")

func _on_bird_died() -> void:
	self.autoscroll = Vector2.ZERO
	pass
