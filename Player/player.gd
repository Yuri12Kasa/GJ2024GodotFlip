extends Node3D

@export var jump_destination_speed : float = 1
@export var jump_duration : float = 0.5

var mouse_pressed : bool
var destination_point_up : bool = true
var start_position : Vector3
var destination : Vector3
var is_jumping : bool

var timer : float = 0

func _ready():
	$"Jump Destination".position = $"Min Jump".position
	%"Jump Timer".wait_time = jump_duration

func _process(delta):
	if(mouse_pressed && !is_jumping):
		lerp_jump_destination(delta)
	
	if(is_jumping):
		print((jump_duration - %"Jump Timer".time_left) / jump_duration)
		position = start_position.lerp(destination, (jump_duration - %"Jump Timer".time_left) / jump_duration)

func _input(event):
	if event is InputEventMouseButton:
		if(mouse_pressed):
			mouse_pressed = false
			start_lerp_player_to_destination()
			print("Mouse released")
		else:
			print("Mouse pressed")
			mouse_pressed = true

func lerp_jump_destination(delta):
	timer += delta * 0.4
	if(destination_point_up):
		var t = timer / jump_destination_speed
		if (t >= 1):
			destination_point_up = false
			timer = 0
			return
		%"Jump Destination".position = $"Min Jump".position.lerp($"Max Jump".position,t)
	else:
		var t = 1 - (timer / jump_destination_speed)
		if (t <= 0):
			destination_point_up = true
			timer = 0
			return
		%"Jump Destination".position = $"Min Jump".position.lerp($"Max Jump".position,t)

func start_lerp_player_to_destination():
	%"Jump Timer".start()
	is_jumping = true
	start_position = position
	destination = %"Jump Destination".position
