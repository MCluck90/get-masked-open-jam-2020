extends KinematicBody2D

export (PackedScene) var Mask
export (Vector2) var camera_limit

const ACCELERATION = 50
const MAX_SPEED = 250
const FRICTION = 0.1

var motion = Vector2.ZERO
var resolution = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)
onready var fire_point = $FirePoint
onready var shot_timer = $ShotTimer

func _ready():
	$Camera2D.limit_right = camera_limit.x * 16
	$Camera2D.limit_bottom = camera_limit.y * 16

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	point_at_mouse()
	move(delta)
	if Input.is_action_pressed("shoot") && shot_timer.time_left == 0:
		shoot()

func get_input_vector():
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_input = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_input, y_input)

func point_at_mouse():
	var angle = get_angle_to(get_global_mouse_position())
	rotation += angle

func move(_delta):
	var input_vector = get_input_vector()

	if input_vector.x == 0:
		motion.x = lerp(motion.x, 0.0, FRICTION)
	if input_vector.y == 0:
		motion.y = lerp(motion.y, 0.0, FRICTION)

	if input_vector.x != 0 || input_vector.y != 0:
		var x_acceleration = ACCELERATION
		var y_acceleration = ACCELERATION
		motion.x += input_vector.x * x_acceleration
		motion.y += input_vector.y * y_acceleration


	# TODO: Make sure diagonals aren't faster
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)

	motion = move_and_slide(motion)
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision && collision.collider.has_method("move_and_slide"):
			collision.collider.move_and_slide(position.direction_to(collision.collider.position) * 100.0)

func shoot():
	var mask = Mask.instance()
	mask.transform = transform
	get_tree().root.add_child(mask)
	shot_timer.start()

