extends CharacterBody3D

@export var flip_time : float = 2.5 # time between one flip and another
@export var flipping_time : float = 0.2 # time to flip the platform upside down
var flipping : bool
var flipped : bool #if flipped kills the player

var start_rotation
var end_rotation

func _ready():
	%"Flip Timer".wait_time = flip_time
	%"Flipping Timer".wait_time = flipping_time
	
func _process(delta):
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

func flip():
	flipping = true
	%"Flipping Timer".start()
	if(flipped):
		start_rotation = quaternion
		end_rotation = Quaternion(Vector3(1,0,0), deg_to_rad(0))
	else:
		start_rotation = quaternion
		end_rotation = Quaternion(Vector3(1,0,0), deg_to_rad(180))

func is_platform():
	return true

func _on_flip_timer_timeout():
	flip()
