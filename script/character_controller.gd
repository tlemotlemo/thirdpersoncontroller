class_name ThirdPersonController extends CharacterBody3D


@export var roll_strength := 64.0

var falling_velocity := 0.0
var horizontal_velocity := Vector2.ZERO
var current_speed: float:
	get:
		if PlayerStamina.sprinting: return PlayerVariables.walk_speed * PlayerStamina.sprint_strength
		if PlayerVariables.aiming: return PlayerVariables.walk_speed * 0.5
		return PlayerVariables.walk_speed
var roll_amount := 0.0
var roll_velocity := Vector2.ZERO


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if(event is InputEventMouseMotion):
		var mouse = event as InputEventMouseMotion
		var mouse_velocity = ((-mouse.relative)) * PlayerVariables.horizontal_sensitivity
		var new_rotation : float = rotation_degrees.y + mouse_velocity.x
		rotation_degrees.y = new_rotation
	if event.is_action_pressed("roll"): roll()


func roll():
	if not PlayerStamina.spend_stamina(roll_strength / 4): return
	if PlayerVariables.rolling: return

	horizontal_velocity = Vector2.ZERO
	PlayerVariables.aiming = false
	PlayerStamina.sprinting = false
	PlayerVariables.rolling = true

	var roll_direction := velocity.normalized()
	if abs(velocity.length()) < 0.1: roll_direction = -basis.z

	roll_velocity.x = roll_direction.x
	roll_velocity.y = roll_direction.z
	roll_velocity = roll_velocity.normalized()
	roll_amount = roll_strength
	roll_velocity *= roll_amount


func fall():
	if is_on_floor():
		falling_velocity = -1
		return
	falling_velocity -= PlayerVariables.fall_speed


func move():
	if PlayerVariables.rolling: return
	horizontal_velocity.x = Input.get_axis("move_left", "move_right")
	horizontal_velocity.y = Input.get_axis("move_forwards", "move_backwards")
	horizontal_velocity *= current_speed * 100


func _physics_process(delta):
	fall()
	move()

	roll_velocity *= 0.92
	if roll_velocity.length() <= 5:
		PlayerVariables.rolling = false

	velocity = basis.x * (horizontal_velocity.x * delta) + basis.z * (horizontal_velocity.y * delta)
	if PlayerVariables.rolling:
		velocity.x += roll_velocity.x
		velocity.z += roll_velocity.y
	velocity.y = falling_velocity * delta
	if PlayerStamina.sprinting: 
		PlayerStamina.spend_stamina(delta * horizontal_velocity.length() / 100)

	move_and_slide()
