class_name CameraRig extends Node3D

@export var sensitivity := 0.2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if(event is InputEventMouseMotion):
		var mouse = event as InputEventMouseMotion
		var mouse_velocity = ((-mouse.relative)) * sensitivity
		var new_rotation : float = rotation_degrees.x + mouse_velocity.y
		if new_rotation <= -90:
			rotation_degrees.x = -90
			return
		if new_rotation >= 90:
			rotation_degrees.x = 90
			return
		rotation_degrees.x = new_rotation
