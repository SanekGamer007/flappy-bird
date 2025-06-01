extends Area2D
var birdexists: bool = false

func _ready() -> void:
	if get_node_or_null(^"../Bird"):
		birdexists = true
		(get_node(^"../Bird") as Bird).died.connect(_on_bird_died)
	else:
		print_debug("nobrd")
	spawn()
func spawn() -> void:
	position.y = randf_range(200, 600)

	
func _process(delta: float) -> void:
	if position.x < -128:
		position.x = 1280
		spawn()
	position.x -= 256 * delta

func _on_bird_died() -> void:
	set_process(false)
