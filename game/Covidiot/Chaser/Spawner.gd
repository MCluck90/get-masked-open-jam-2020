extends Node2D

export (PackedScene) var actor

onready var marker = $Marker

var spawn_count = 0
var wave = 0
var waves = [
	{"minimum": 20, "timeout": 0.9}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	marker.visible = false

func _on_Timer_timeout():
	var pos = position + marker.rect_size / 2.0
	var new_actor = actor.instance()
	new_actor.position = pos
	get_tree().get_root().add_child(new_actor)
	
	spawn_count += 1
	if len(waves) <= wave:
		return

	var wave_info = waves[wave]
	if wave_info && spawn_count >= wave_info["minimum"]:
		wave += 1
		$Timer.wait_time = wave_info["timeout"]

