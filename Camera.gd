extends Camera3D

@onready var player = $"../Player"
var start_pos_offset

func _ready():
	start_pos_offset = global_position

func _process(_delta):
	compute_position()

func compute_position():
	var new_position = player.position + start_pos_offset
	new_position.y = start_pos_offset.y
	global_position = new_position
