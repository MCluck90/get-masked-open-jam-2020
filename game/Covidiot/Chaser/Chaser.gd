extends "res://Covidiot/Covidiot.gd"

onready var player: KinematicBody2D = null

export(float) var run_speed = 100

func _ready():
	find_player()

func _process(_delta):
	if player == null:
		find_player()
		return

	if !is_wearing_a_mask:
		var angle = get_angle_to(player.position)
		rotation += angle

func _physics_process(_delta):
	if !is_wearing_a_mask:
		var velocity = Vector2.RIGHT.rotated(rotation) * run_speed
		var _x = move_and_slide(velocity)

func find_player():
	player = find_node_by_name(get_tree().get_root(), "Player")

func find_node_by_name(root, name):
	if root.get_name() == name:
		return root

	for child in root.get_children():
		var found = find_node_by_name(child, name)
		if found:
			return found

	return null
