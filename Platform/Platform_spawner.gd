extends Node3D

const PLATFORM = preload("res://Platform/Platform.tscn")

func _ready():
	spawn_platform()

func spawn_platform():
	var new_platform1 = PLATFORM.instantiate()
	new_platform1.global_position = %SpawnPoint1.position
	new_platform1.global_position = %SpawnPoint1.position
	get_tree().current_scene.add_child(new_platform1)
	
	var new_platform2 = PLATFORM.instantiate()
	new_platform2.global_position = %SpawnPoint2.position
	new_platform2.global_position = %SpawnPoint2.position
	get_tree().current_scene.add_child(new_platform2)
	
	var new_platform3 = PLATFORM.instantiate()
	new_platform3.global_position = %SpawnPoint3.position
	new_platform3.global_position = %SpawnPoint3.position
	get_tree().current_scene.add_child(new_platform3)
