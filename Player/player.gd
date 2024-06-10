extends Node3D

@export var jump_destination_speed : float = 1
@export var jump_duration : float = 0.5

var mouse_pressed : bool
var destination_point_up : bool = true
var start_position : Vector3
var destination : Vector3
var is_jumping : bool

var target_platform

var timer : float = 0

func _ready():
	%"Jump Timer".wait_time = jump_duration
	reset_jump_destination()

func _process(delta):
	if(mouse_pressed && !is_jumping):
		lerp_jump_destination(delta)
	
	if(is_jumping): 
		lerp_jump()

func _input(event):
	if event is InputEventMouseButton:
		if(mouse_pressed):
			print("Mouse released")
			mouse_pressed = false
			start_lerp_player_to_destination()
			%"Jump Destination".hide()
		else:
			print("Mouse pressed")
			mouse_pressed = true
			%"Jump Destination".show()

func reset_jump_destination():
	$"Jump Destination".position = $"Min Jump".position
	timer = 0
	destination_point_up = true
	%"Jump Destination".hide()

func start_lerp_player_to_destination():
	%"Jump Timer".start()
	is_jumping = true
	start_position = global_position
	if(target_platform):
		destination = target_platform.global_position
	else:
		destination = %"Jump Destination".global_position

func lerp_jump_destination(delta):
	timer += delta * 0.4
	if(destination_point_up):
		var t = timer / jump_destination_speed
		if (t >= 1):
			destination_point_up = false
			timer = 0
			return
		%"Jump Destination".global_position = $"Min Jump".global_position.lerp($"Max Jump".global_position,t)
	else:
		var t = 1 - (timer / jump_destination_speed)
		if (t <= 0):
			destination_point_up = true
			timer = 0
			return
		%"Jump Destination".global_position = $"Min Jump".global_position.lerp($"Max Jump".global_position,t)

func lerp_jump():
	var t = (jump_duration - %"Jump Timer".time_left) / jump_duration
	global_position = start_position.lerp(destination, t)
	if(t >= 1):
		is_jumping = false
		reset_jump_destination()

func _on_jump_destination_body_entered(body):
	if(body.has_method("is_platform")):
		target_platform = body

func _on_jump_destination_body_exited(body):
	if(body.has_method("is_platform") && body == target_platform):
		target_platform = null
