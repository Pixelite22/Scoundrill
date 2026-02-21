extends Control

@export_group("Stats")
@export var health := 20
@export var active_effect := "NONE"
var active_weapon : weaponCard = null

@onready var health_label: RichTextLabel = $Health
@onready var health_Bar: ProgressBar = $Health/Bar
@onready var health_value: RichTextLabel = $Health/Value

@onready var weapon_power_label: RichTextLabel = $"Weapon Power"
@onready var weapon_card: Control = $"Weapon Power/Weapon Card"

@onready var highest_number_label: RichTextLabel = $"Highest Number"
@onready var deck_remaining: RichTextLabel = $"Deck Remaining"


var effect := ["NONE", "BURNT", "FROZEN", "POISON"]

func _process(_delta: float) -> void:
	handle_health()
	handle_weapon()

func handle_health():
	if health > 20: #If health ever goes above 20
		health = 20 #Set it to 20
	if health < 0: #If health ever goes below 0
		health = 0 #Set it to 0
	
	health_Bar.value = health #Set the bar showing health on the screen to health value
	health_value.text = str(health)

func handle_weapon():
	if active_weapon != null: #If there is an active weapon
#		weapon_power_label.text = "Weapon Power: " + str(active_weapon.value)#Display it's strength
		highest_number_label.text = "The Highest number your weapon can attack: " + str(active_weapon.kill_cap)


func deck_info(deck_resource):
	deck_remaining.text = "Cards left in deck: " + str(deck_resource.cards.size())
