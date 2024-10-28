extends Area2D

const TARGET_X = -16  # Target position on the left
const SPAWN_X = 320   # Spawn position on the right (adjust as necessary)
const DIST_TO_TARGET = TARGET_X - SPAWN_X

const LEFT_LANE_SPAWN = Vector2(SPAWN_X, 80)
const CENTRE_LANE_SPAWN = Vector2(SPAWN_X, 120)
const RIGHT_LANE_SPAWN = Vector2(SPAWN_X, 160)

var speed = 0
var hit = false

func _ready():
	pass

func _physics_process(delta):
	if !hit:
		position.x += speed * delta  # Move right to left (decrease x)
		if position.x < TARGET_X:  # Check if it has moved off-screen
			queue_free()
			get_parent().reset_combo()
	else:
		$Node2D.position.y -= speed * delta  # Adjust if you want to move down after hit

func initialize(lane):
	if lane == 0:
		$AnimatedSprite2D.frame = 0
		position = LEFT_LANE_SPAWN
	elif lane == 1:
		$AnimatedSprite2D.frame = 1
		position = CENTRE_LANE_SPAWN
	elif lane == 2:
		$AnimatedSprite2D.frame = 2
		position = RIGHT_LANE_SPAWN
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return
	
	speed = DIST_TO_TARGET / 2.0  # Set speed for how fast it moves

func destroy(score):
	$CPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$Timer.start()
	hit = true
	if score == 3:
		$Node2D/Label.text = "GREAT"
		$Node2D/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = Color("c3a38a")
	elif score == 1:
		$Node2D/Label.text = "OKAY"
		$Node2D/Label.modulate = Color("997577")

func _on_Timer_timeout():
	queue_free()
