extends Area2D

var speed = 750
var start_position
var max_distance = 300

func _ready():
	start_position = position

func _physics_process(delta):
	position += transform.x * speed * delta
	if start_position.distance_to(position) >= max_distance:
		queue_free()

func _on_body_entered(body):
	if body.has_method("on_mask_hit"):
		body.on_mask_hit()
	queue_free()