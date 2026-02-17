extends Control

@export_group("Stats")
@export var health := 20
@export var active_effect := "NONE"
var active_weapon : weaponCard = null

@onready var health_label: RichTextLabel = $Health
@onready var weapon_power_label: RichTextLabel = $"Weapon Power"
@onready var highest_number_label: RichTextLabel = $"Highest Number"


var effect := ["NONE", "BURNT", "FROZEN", "POISON"]

func _process(_delta: float) -> void:
	if health > 20: #If health ever goes above 20
		health = 20 #Set it to 20
	if health < 0: #If health ever goes below 0
		health = 0 #Set it to 0
	
	health_label.text = "Health: " + str(health) #Set the Text showing health on the screen to health and the value
	if active_weapon != null: #If there is an active weapon
		weapon_power_label.text = "Weapon Power: " + str(active_weapon.value)#Display it's strength
		highest_number_label.text = "The highest number card you can attack with your weapon is: " + str(active_weapon.kill_cap)
