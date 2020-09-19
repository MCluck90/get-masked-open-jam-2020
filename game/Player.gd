extends KinematicBody2D

const ACCELERATION = 1024
const MAX_SPEED = 2.5
const FRICTION = 0.25

var motion = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_input_vector()

	if input_vector.x == 0:
		motion.x = lerp(motion.x, 0.0, FRICTION)
	if input_vector.y == 0:
		motion.y = lerp(motion.y, 0.0, FRICTION)

	if input_vector.x != 0 || input_vector.y != 0:
		var x_acceleration = ACCELERATION
		var y_acceleration = ACCELERATION
		motion.x += input_vector.x * x_acceleration * delta
		motion.y += input_vector.y * y_acceleration * delta

	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)

	var _collision = move_and_collide(motion)

func get_input_vector():
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_input = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_input, y_input)
