extends Node3D

const PLATFORM = preload("res://Platform/Platform.tscn")

var spawn_points = []

func _ready():
	init_spawn_points_array()
	spawn_rnd_platform()

func _process(delta):
	check_game_over()

func init_spawn_points_array():
	spawn_points.push_back(%SpawnPoint1)
	spawn_points.push_back(%SpawnPoint2)
	spawn_points.push_back(%SpawnPoint3)

func spawn_rnd_platform():
	var spawn_point_size = spawn_points.size()
	var spawn_order = []
	for n in spawn_point_size:
		spawn_order.push_back(n) 
	spawn_order.shuffle()
	var chance_increase = 100 / spawn_point_size 
	for n in spawn_point_size:
		var chance = randi_range(0, 100)
		if (chance <= (chance_increase * (n + 1))):
			spawn_platform(spawn_points[spawn_order[n]])

func spawn_platform(spawn_point):
	var new_platform = PLATFORM.instantiate()
	new_platform.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(new_platform)

func _on_player_platform_reached(flipped):
	if flipped:
		game_over()
	else:
		spawn_rnd_platform()

func check_game_over():
	if($Player.position.y < -5):
		game_over()

func game_over():
	get_tree().reload_current_scene()
