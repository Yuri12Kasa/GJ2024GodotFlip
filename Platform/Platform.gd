extends CharacterBody3D

@export var flip_time : float = 2.5 # time between one flip and another
@export var min_flip_time : float = 1
@export var max_flip_time : float = 4
var flipping_time : float = 0.2 # time to flip the platform upside down

@export var horizontal_move_time : float = 2
@export var horizontal_max_distance : float = 4
#@export var vertical_move_time : float = 2
#@export var vertical_max_distance : float = 4

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
#var moving_up : bool = true

#var can_move_vertical = true

func is_platform():
	return true

func _ready():
	%"Flip Timer".wait_time = flip_time
	%"Flipping Timer".wait_time = flipping_time
	%"Horizontal Move Timer".wait_time = horizontal_move_time
	#%"Vertical Move Timer".wait_time = vertical_move_time
	start_position = global_position;
	start_lerp_position = global_position
	end_horizontal_lerp_position = start_position + Vector3(0,0,horizontal_max_distance)
	#end_vertical_lerp_position = start_position + Vector3(vertical_max_distance, 0, 0)
	
func _process(delta):
	flipping_animation()
	if can_move:
		move_horizontal(delta)
		"""
		if can_move_vertical:
			move_vertical(delta)
		"""

func flip():
	flipping = true
	%"Flipping Timer".start()
	if(flipped):
		start_rotation = quaternion
		end_rotation = Quaternion(Vector3(1,0,0), deg_to_rad(0))
	else:
		start_rotation = quaternion
		end_rotation = Quaternion(Vector3(1,0,0), deg_to_rad(180))

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

func stop_flip_and_move():
	%"Flip Timer".stop()
	can_move = false
	%"Horizontal Move Timer".stop()
	#%"Vertical Move Timer".stop()

func _on_flip_timer_timeout():
	flip()

func move_horizontal(delta):
	var t = (horizontal_move_time - %"Horizontal Move Timer".time_left) / horizontal_move_time
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

"""
func move_vertical(delta):
	var t = (vertical_move_time - %"Vertical Move Timer".time_left) / vertical_move_time
	global_position = start_lerp_position.lerp(end_vertical_lerp_position, t)

func _on_vertical_move_timer_timeout():
	if(!can_move_vertical):
		return
	global_position = end_vertical_lerp_position
	if(moving_up):
		moving_up = false
		start_lerp_position = global_position
		end_vertical_lerp_position = start_position
	else:
		moving_up = true
		start_lerp_position = global_position
		end_vertical_lerp_position = start_position + Vector3(vertical_max_distance,0,0)
"""
