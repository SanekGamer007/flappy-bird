extends Control
var birdexists: bool = false

func _ready() -> void:
	set_process(false)
	size = get_viewport().get_visible_rect().size
	position.y = Vector2i(get_viewport().get_visible_rect().size).y * -1
	if get_node_or_null(^"../Bird"):
		birdexists = true
		(get_node(^"../Bird") as Bird).died.connect(_on_bird_died)
	else:
		print_debug("nobrd")

func _on_bird_died() -> void:
	set_process(true)
	
	
func _process(delta: float) -> void:
	position.y = lerpf(position.y, get_screen_position().y / 2, delta * 4)
