extends Node


func _input(event):
	if event is not InputEventKey: return
	event = event as InputEventKey
	if event.keycode == 4194305: get_tree().quit()
