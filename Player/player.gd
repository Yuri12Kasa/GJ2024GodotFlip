extends CharacterBody3D

@export var jump_destination_speed : float = 1
@export var jump_duration : float = 0.5
@export var jump_height : float = 5

@export var default_target_sprite : Texture 
@export var on_focus_target_sprite : Texture

signal platform_reached(flipped)
signal jump()

var gravity = 0

var mouse_pressed : bool
var destination_point_up : bool = true
var start_position : Vector3
var destination : Vector3
var is_jumping : bool

var target_platform
var reaching_platform : bool

var timer : float = 0

func _ready():
	%"Jump Timer".wait_time = jump_duration
	reset_jump_destination()

func _process(delta):
	if(mouse_pressed && !is_jumping):
		lerp_jump_destination(delta)
	
	if(is_jumping): 
		lerp_jump()
	
	velocity.y += delta * gravity
	move_and_slide()

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
	reaching_platform = false
	target_platform = null
	$"Jump Destination".position = $"Min Jump".position
	timer = 0
	destination_point_up = true
	%"Jump Destination".hide()
	%"Target Sprite".texture = default_target_sprite

func start_lerp_player_to_destination():
	jump.emit()
	%"Jump Timer".start()
	is_jumping = true
	start_position = global_position
	if(target_platform):
		target_platform.stop_flip_and_move()
		destination = target_platform.global_position
		reaching_platform = true
	else:
		destination = %"Jump Destination".global_position
		gravity = -10

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
	var y = -jump_height * pow(t, 2) + (jump_height * t)
	#destination.y = y
	global_position = start_position.lerp(destination, t)
	global_position.y = y
	if(t >= 1):
		is_jumping = false
		if reaching_platform:
			platform_reached.emit(target_platform.flipped)
		reset_jump_destination()

func _on_jump_destination_body_entered(body):
	if(body.has_method("is_platform")):
		%"Target Sprite".texture = on_focus_target_sprite
		target_platform = body

func _on_jump_destination_body_exited(body):
	if(body.has_method("is_platform") && body == target_platform && !reaching_platform):
		%"Target Sprite".texture = default_target_sprite
		target_platform = null
