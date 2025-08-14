class_name PlayerCamera extends Camera3D


var target_fov := fov


func set_target_fov():
	if PlayerVariables.aiming:
		target_fov = PlayerVariables.fov * 0.5
		return
	match PlayerStamina.sprinting:
		true:
			target_fov = PlayerVariables.fov * 1.25
		
		false:
			target_fov = PlayerVariables.fov


func _process(delta):
	set_target_fov()
	fov = lerpf(fov, target_fov, 0.2)


func _input(event):
	if event.is_action_pressed("aim") and not PlayerVariables.rolling:
		PlayerVariables.aiming = true
		PlayerStamina.sprinting = false
	if event.is_action_released("aim"): PlayerVariables.aiming = false
