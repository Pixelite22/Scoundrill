extends Control

@export_group("Stats")
@export var health := 20
@export var active_effect := "NONE"
var active_weapon : weaponCard = null
var point_value : int = 0

@onready var health_label: RichTextLabel = $Health
@onready var health_Bar: ProgressBar = $Health/Bar
@onready var health_value: RichTextLabel = $Health/Value

@onready var weapon_power_label: RichTextLabel = $"Weapon Power"
@onready var container: HBoxContainer = $"Weapon Power/Container"
#@onready var weapon_card: Control = $"Weapon Power/Container/Weapon Card"
var weapmon_arr : Array[Control] = []

@onready var highest_number_label: RichTextLabel = $"Highest Number"
@onready var deck_remaining: RichTextLabel = $"Deck Remaining"

@onready var points_label: RichTextLabel = $"Points Label"

const card_path = preload("res://Scenes and Code/Scenes/playing_card.tscn")

var effect := ["NONE", "BURNT", "FROZEN", "POISON"]

func _process(_delta: float) -> void:
	handle_health()
	handle_weapon()
	
	points_label.text = "Points: " + str(point_value)

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

func add_weapmon_card():
	print("Adding a weapmon")
	var card_instance = card_path.instantiate() #set a var and instantiate a card from the card_path
	card_instance.name = "Display Card"
	container.add_child(card_instance) #add the child to the room node
	weapmon_arr.append(card_instance)

func clear_weapmons():
	print("Clearing Weapmons")
	var card_values = 0
	var card_cnt = 0
	for child in container.get_children():
		if child.card_res is monsterCard:
			card_values += child.card_res.value #Collect the points
			card_cnt += 1 #collect the amount of cards in the stack to multiply points
		child.queue_free() #remove card
	
	weapmon_arr.clear()
	active_weapon = null
	point_handling(card_values, card_cnt)

func point_handling(card_values, card_cnt):
	point_value += (card_values * card_cnt)
	

func deck_info(deck_resource):
	deck_remaining.text = "Cards left in deck: " + str(deck_resource.cards.size())
