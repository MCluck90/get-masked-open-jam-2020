extends KinematicBody2D

enum BreathState {BREATHING, COUGHING}

export(float) var cough_timeout = 1.0

onready var breathing_particles = $Breathing/Particles
onready var breathing_collider = $Breathing/Collider
onready var cough_particles = $Cough/Particles
onready var cough_collider = $Cough/Collider
onready var cough_timer = $Cough/Timer
onready var sprite = $Sprite

var rng = RandomNumberGenerator.new()
var breath_state = BreathState.BREATHING
var is_wearing_a_mask = false

func _ready():
	rng.randomize()
	$Cough/Timer.wait_time = cough_timeout
	$Cough.visible = false
	$Breathing.visible = false
	cough_particles.one_shot = true

	yield(get_tree().create_timer(rng.randf() * 3.0), "timeout")
	# Technically the player can mask this person before the timeout completes
	# which means this will be null
	if !$Cough/Timer:
		return

	$Cough/Timer.start()
	$Breathing.visible = true
	breathing_particles.lifetime *= rng.randf_range(0.9, 1.1)
	cough_particles.visible = true
	breathing_particles.visible = true
	breathing_particles.emitting = true

func _process(_delta):
	if is_wearing_a_mask:
		$Breathing.visible = breathing_particles.emitting
		$Cough.visible = cough_particles.emitting
	else:
		breathing_collider.disabled = !breathing_particles.emitting
		cough_collider.disabled = !cough_particles.emitting

func _on_CoughTimer_timeout():
	if cough_particles.emitting:
		return

	$Cough.visible = !$Cough.visible
	if $Cough.visible:
		cough_particles.restart()

func on_mask_hit():
	if is_wearing_a_mask:
		return

	breathing_particles.one_shot = true
	cough_particles.one_shot = true
	cough_timer.queue_free()

	sprite.frame = 1
	breathing_collider.queue_free()
	cough_collider.queue_free()
	is_wearing_a_mask = true

var cough_collisions = []
func _on_Cough_body_entered(body):
	var id = body.get_instance_id()
	if !cough_collisions.has(id):
		cough_collisions.push_back(id)

	$Cough.visible = false

func _on_Cough_body_exited(body):
	var id = body.get_instance_id()
	var index = cough_collisions.find(id)
	if index > -1:
		cough_collisions.remove(index)
	$Cough.visible = len(cough_collisions) > 0
