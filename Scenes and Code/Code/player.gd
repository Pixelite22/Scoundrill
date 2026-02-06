extends Node2D

@export_group("Stats")
@export var health := 20
@export var active_effect := "NONE"
@export var active_weapon : weaponCard

@onready var health_label: RichTextLabel = $Health
@onready var weapon_power_label: RichTextLabel = $"Weapon Power"
@onready var highest_number_label: RichTextLabel = $"Highest Number"


var effect := ["NONE", "BURNT", "FROZEN", "POISON"]

func _process(delta: float) -> void:
	if health > 20:
		health = 20
	if health < 0:
		health = 0
	
	health_label.text = "Health: " + str(health)
	if active_weapon != null:
		weapon_power_label.text = "Weapon Power: " + str(active_weapon.value)
