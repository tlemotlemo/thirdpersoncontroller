class_name StaminaBar extends ProgressBar


func _ready():
	max_value = PlayerStamina.max_stamina


func _process(delta):
	value = PlayerStamina.stamina
