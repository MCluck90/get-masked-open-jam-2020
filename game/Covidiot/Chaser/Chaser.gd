extends "res://Covidiot/Covidiot.gd"

var player: KinematicBody2D = null
var is_looking_for_player = false
var is_chasing = false

export(float) var run_speed = 100

onready var raycast: RayCast2D = $RayCast2D

func _ready():
	find_player()

func _process(_delta):
	if is_wearing_a_mask:
		return

	if player == null:
		find_player()
		return


	if is_looking_for_player:
		var angle = get_angle_to(player.position)
		rotation += angle

	raycast.force_raycast_update()
	var collider = raycast.get_collider()
	is_chasing = collider && collider.name == "Player"

func _physics_process(_delta):
	if is_wearing_a_mask:
		return

	if is_chasing:
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

func _on_PlayerDetection_body_entered(_body):
	is_looking_for_player = true

func _on_PlayerDetection_body_exited(_body):
	is_looking_for_player = is_chasing
