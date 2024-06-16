extends CharacterBody3D

@export var min_flip_time : float = 1
@export var max_flip_time : float = 4
var flipping_time : float = 0.2 # time to flip the platform upside down

@export var horizontal_min_move_time : float = 2
@export var horizontal_max_move_time : float = 4
@export var horizontal_max_distance : float = 4

var flipping : bool
var flipped : bool #if flipped kills the player

var start_position
var start_lerp_position
var end_horizontal_lerp_position
var end_vertical_lerp_position

var start_rotation
var end_rotation

var can_move : bool = true
var moving_right : bool = true

func is_platform():
	return true

func _ready():
	init_flip_stats()
	init_move_stats()
	start_flip_timer()


func init_flip_stats():
	flipped = randi_range(0,1)
	if(!flipped):
		quaternion = Quaternion(Vector3(1,0,0), deg_to_rad(0))
	else:
		quaternion = Quaternion(Vector3(1,0,0), deg_to_rad(180))
	%"Flip Timer".wait_time = randf_range(min_flip_time, max_flip_time)
	%"Flip Timer".start()
	%"Flipping Timer".wait_time = flipping_time

func init_move_stats():
	start_position = global_position;
	
	moving_right = randi_range(0,1)
	if(!moving_right):
		start_lerp_position = global_position
		end_horizontal_lerp_position = start_position - Vector3(0,0,horizontal_max_distance)
	else:
		start_lerp_position = global_position
		end_horizontal_lerp_position = start_position + Vector3(0,0,horizontal_max_distance)
	
	%"Horizontal Move Timer".wait_time = randf_range(horizontal_min_move_time, horizontal_max_move_time)
	%"Horizontal Move Timer".start()
func start_flip_timer():
	%"Up Flip Timer Feedback".speed_scale = 16 / %"Flip Timer".wait_time
	%"Down Flip Timer Feedback".speed_scale = 16 / %"Flip Timer".wait_time
	if(flipped):
		%"Down Flip Timer Feedback".visible = false
		%"Up Flip Timer Feedback".play("Progress")
	else:
		%"Up Flip Timer Feedback".visible = false
		%"Down Flip Timer Feedback".play("Progress")

func _process(delta):
	flipping_animation()
	if can_move:
		move_horizontal(delta)

func flip():
	flipping = true
	%"Flipping Timer".start()
	if(flipped):
		start_rotation = quaternion
		end_rotation = Quaternion(Vector3(1,0,0), deg_to_rad(0))
	else:
		start_rotation = quaternion
		end_rotation = Quaternion(Vector3(1,0,0), deg_to_rad(180))
	reset_flip_timer_feedback()

func flipping_animation():
	if(flipping):
		var t = (flipping_time - %"Flipping Timer".time_left) / flipping_time
		if(t >= 1):
			flipping = false
			if(flipped):
				flipped = false
			else:
				flipped = true
			quaternion = end_rotation
		else:
			quaternion = start_rotation.slerp(end_rotation, t)

func reset_flip_timer_feedback():
	if(flipped):
		%"Up Flip Timer Feedback".visible = false
		%"Up Flip Timer Feedback".stop()
		%"Down Flip Timer Feedback".visible = true
		%"Down Flip Timer Feedback".play("Progress")
	else:
		%"Down Flip Timer Feedback".visible = false
		%"Down Flip Timer Feedback".stop()
		%"Up Flip Timer Feedback".visible = true
		%"Up Flip Timer Feedback".play("Progress")

func stop_flip_and_move():
	%"Flip Timer".stop()
	can_move = false
	%"Horizontal Move Timer".stop()
	%"Up Flip Timer Feedback".visible = false
	%"Down Flip Timer Feedback".visible = false
	%"Up Flip Timer Feedback".stop()
	%"Down Flip Timer Feedback".stop()

func _on_flip_timer_timeout():
	flip()

func move_horizontal(_delta):
	var t = (%"Horizontal Move Timer".wait_time - %"Horizontal Move Timer".time_left) / %"Horizontal Move Timer".wait_time
	global_position = start_lerp_position.lerp(end_horizontal_lerp_position, t)

func _on_horizontal_move_timer_timeout():
	global_position = end_horizontal_lerp_position
	if(moving_right):
		moving_right = false
		start_lerp_position = global_position
		end_horizontal_lerp_position = start_position - Vector3(0,0,horizontal_max_distance)
	else:
		moving_right = true
		start_lerp_position = global_position
		end_horizontal_lerp_position = start_position + Vector3(0,0,horizontal_max_distance)
