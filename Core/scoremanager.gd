extends Node
var score: int = 0
var bird_node: Bird
var highscore: int

func _ready() -> void:
	highscore = SaveSystem.get_var("highscore")
	get_tree().node_added.connect(_on_any_node_tree_entered)
func _on_any_node_tree_entered(node: Node) -> void:
	if bird_node:
		return
	else:
		if node.name == "Bird":
			print_debug("Found Bird node, connecting to \"Scored\" signal.")
			bird_node = node
			bird_node.scored.connect(_on_bird_scored)
func _on_bird_scored() -> void:
	score += 1

func reset() -> void:
	if bird_node:
		bird_node.scored.disconnect(_on_bird_scored)
		bird_node = null
	if score > highscore:
		highscore = score
		SaveSystem.set_var("highscore", highscore)
		SaveSystem.save()
	score = 0
