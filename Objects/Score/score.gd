extends Label
var birdexists: bool = false
var bird_dead: bool = false

func _ready() -> void:
	if get_node_or_null(^"../Bird"):
		birdexists = true
		(get_node(^"../Bird") as Bird).died.connect(_on_bird_died)
	else:
		print_debug("nobrd")

func _on_bird_died() -> void:
	bird_dead = true

func _process(delta: float) -> void:
	text = str(scoremanager.score)
	if bird_dead:
		position.y = lerpf(position.y, -128, delta * 4)
