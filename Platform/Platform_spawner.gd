extends Node3D

const PLATFORM = preload("res://Platform/Platform.tscn")

var spawn_points = []
var spawned_platforms = []

func _ready():
	init_spawn_points_array()
	spawn_rnd_platform()

func _process(_delta):
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
	var chance_increase : int = 100 / spawn_point_size 
	for n in spawn_point_size:
		var chance = randi_range(0, 100)
		if (chance <= (chance_increase * (n + 1))):
			spawn_platform(spawn_points[spawn_order[n]])

func spawn_platform(spawn_point):
	var new_platform = PLATFORM.instantiate()
	spawned_platforms.push_back(new_platform)
	new_platform.global_position = spawn_point.global_position
	add_child(new_platform)
	
func stop_spawned_platforms():
	for n in spawned_platforms.size():
		spawned_platforms[n].stop_flip_and_move()

func _on_player_platform_reached(platform):
	for n in spawned_platforms.size():
		if(platform != spawned_platforms[n]):
			spawned_platforms[n].remove()
	spawned_platforms.clear()
	if platform.flipped:
		game_over()
	else:
		spawn_rnd_platform()

func check_game_over():
	if($Player.position.y < -5):
		game_over()

func game_over():
	get_tree().reload_current_scene()


func _on_player_jump():
	stop_spawned_platforms()
