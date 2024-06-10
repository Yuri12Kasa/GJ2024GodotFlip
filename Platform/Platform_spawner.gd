extends Node3D

const PLATFORM = preload("res://Platform/Platform.tscn")

func _ready():
	spawn_platform()

func spawn_platform():
	var new_platform = PLATFORM.instantiate()
	new_platform.global_position = $Player/Node3D.position
	new_platform.global_position = $Player/Node3D.position
	get_tree().current_scene.add_child(new_platform)
