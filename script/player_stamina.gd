extends Node

var sprinting := false
var sprint_strength := 1.8
var max_stamina := 32.0
var stamina := max_stamina
var stamina_cooldown := 0.0


# Spends stamina for a given action, then tells you if you have enough for said action
func spend_stamina(amount: float) -> bool:
	if stamina <= 0: return false # You don't have enough stamina
	stamina -= amount
	stamina_cooldown = 1
	if stamina > 0: return true  # You have more than enough stamina
	stamina = 0
	stamina_cooldown = 4
	PlayerStamina.sprinting = false
	return true # You had enough, but doing it made you run out


func regain_stamina(amount: float):
	if stamina_cooldown > 0: return
	if stamina >= max_stamina:
		stamina = max_stamina
		return
	stamina += amount


func _process(delta):
	stamina_cooldown -= delta
	regain_stamina(delta * 4)
	stamina = clampf(stamina, 0, max_stamina)


func _input(event):
	if event.is_action_pressed("sprint") and stamina > 0:
		sprinting = true
		PlayerVariables.aiming = false
	if event.is_action_released("sprint"): sprinting = false
