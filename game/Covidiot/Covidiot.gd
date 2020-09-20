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
	cough_particles.visible = true
	cough_particles.one_shot = true

	$Breathing.visible = true
	breathing_particles.visible = true
	breathing_particles.emitting = true

func _process(_delta):
	breathing_collider.disabled = !breathing_particles.emitting
	cough_collider.disabled = !cough_particles.emitting

	if is_wearing_a_mask:
		$Breathing.visible = breathing_particles.emitting
		$Cough.visible = cough_particles.emitting


func _on_CoughTimer_timeout():
	if cough_particles.emitting:
		return

	$Cough.visible = !$Cough.visible
	if $Cough.visible:
		cough_particles.restart()

func on_mask_hit():
	breathing_particles.one_shot = true
	cough_timer.stop()

	sprite.frame = 1
	is_wearing_a_mask = true
