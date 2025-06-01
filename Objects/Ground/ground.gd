extends Parallax2D
var birdexists: bool = false

func _ready() -> void:
	if get_node_or_null(^"../Bird"):
		birdexists = true
		(get_node(^"../Bird") as Bird).died.connect(_on_bird_died)
	else:
		print_debug("nobrd")

func _on_bird_died() -> void:
	self.autoscroll = Vector2.ZERO
	pass
