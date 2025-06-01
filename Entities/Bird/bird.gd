extends CharacterBody2D
class_name Bird

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_power: float = -580
@onready var animatedsprite: AnimatedSprite2D = get_node(^"AnimatedSprite2D")
var deathtimer: float = 0
signal scored
signal died
var didplaydeathsfx: bool = false
enum states {
	FALLING,
	FLYING,
	DEAD,
	}
var state: states = states.FALLING

func _ready() -> void:
	animatedsprite.play("idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		set_state(states.FLYING)

func _process(delta: float) -> void:
	var target_angle_deg: float = remap(velocity.y, -720 , 640, -60, 75)
	var target_angle_rad: float = deg_to_rad(target_angle_deg)
	animatedsprite.rotation = lerp_angle(animatedsprite.rotation, target_angle_rad, clamp(delta * 16, 0, 1))
func _physics_process(delta: float) -> void:
	if state == states.FALLING:
		velocity.y += gravity * delta
	if state == states.FLYING:
		(get_node(^"FlapSFX") as AudioStreamPlayer).play()
		velocity.y = jump_power
		set_state(states.FALLING)
	if state == states.DEAD:
		if position.y >= 620:
			velocity = Vector2.ZERO
			set_process(false)
			set_physics_process(false)
			return
		if deathtimer >= 0.6:
			if position.y <= 620:
				if didplaydeathsfx == false:
					(get_node(^"DeathSFX") as AudioStreamPlayer).play()
					didplaydeathsfx = true
				velocity.y += gravity * delta
		else:
			deathtimer += delta
			print(deathtimer)
	else:
		velocity.y = clamp(velocity.y, -720, 640)
	move_and_slide()

func set_state(new_state: states) -> void:
	if state == states.DEAD:
		return
	if new_state == states.DEAD:
		state = new_state
		velocity = Vector2.ZERO
		(get_node(^"HitSFX")as AudioStreamPlayer).play()
		animatedsprite.stop()
		animatedsprite.set_frame_and_progress(1, 1)
	elif new_state == states.FLYING:
		if not position.y <= 0:
			animatedsprite.play("flap")
			state = new_state
		else:
			return
	elif new_state == states.FALLING:
		animatedsprite.play("idle")
		state = new_state
	else:
		state = new_state


func _on_score_area_entered(area: Area2D) -> void:
	if area.name == "score" and not state == states.DEAD:
		print("+1")
		(get_node(^"PointSFX") as AudioStreamPlayer).play()
		scored.emit()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("death") and not state == states.DEAD:
		print("Death!")
		set_state(states.DEAD)
		died.emit()
