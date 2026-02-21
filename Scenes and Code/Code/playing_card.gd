extends Control

signal card_collected(card_to_delete, attribute, value)

@export var card_res : Card
@onready var sprite: TextureRect = $Sprite

#Define possible card types for if ever needing to hard call them
var card_types := ["res://Resources/Cards/Health Potions/health_potion.tres", "res://Resources/Cards/Monsters/monster.tres", "res://Resources/Cards/Weapons/weapon.tres"]

#Save the path prefix so the other parts can be added on
var card_sprite_path_prefix := "res://Assets/kenney_playing-cards-pack/PNG/Cards (large)/card_"
var value
var suit
var valuestr

var suit_flg = false
var value_flg = false

var player_node : Control

func _process(_delta: float) -> void:
	pass

#function to assign a card a value
func card_assign() -> void:
	value_assign() #call value_assign
	suit_assign() #call suit_assign
	
	sprite.texture = load(card_sprite_path_prefix + suit + valuestr) #load the texture to the sprite of the created card

func suit_assign():
	if value == 0: #If the card has no value
		suit = "empty" #call the empty card path
	else: #but if it does have a value
		if card_res is monsterCard: #if it is a monster
			suit = ["clubs_", "spades_"].pick_random() #pick randomly from clubs or spades
			#note this will be changed later
		if card_res is healthCard: #If it is a health potion
			suit = "hearts_" #call the hearts text to be added to the path
		if card_res is weaponCard: #if it is a weapon
			suit = "diamonds_" #call the suit to be diamonds


func value_assign():
	card_res.value_assign() #call the value assign function within the card resource
	value = card_res.value #set value to the card resource's value
	
	#Following code handles odd text paths and royalty cards
	if value == 10:
		valuestr = "10.png"
	elif value == 11:
		valuestr = "J.png"
	elif value == 12:
		valuestr = "Q.png"
	elif value == 13:
		valuestr = "K.png"
	elif value == 14:
		valuestr = "A.png"
	elif value == 0:
		valuestr = ".png"
	else: #otherwise
		valuestr = "0" + str(value) + ".png" #add a 0 and the value to the end


#This handles the actual clicking on the card
#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
#	#if a player clicks on a card with the left mouse button
#	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
#		card_res.resolve(card_res, player_node) #call the resolve function from the card resource
#		card_collected.emit(self, card_res, value) #emit a signal showing a card was collected
#		print(player_node.health) #Print the players current health

func _gui_input(event: InputEvent) -> void:
	#if a player clicks on a card with the left mouse button
	if self.name != "Display Card":
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if card_res is weaponCard or card_res is monsterCard:
				if card_res is weaponCard:
					player_node.clear_weapmons()
				if card_res is weaponCard or (card_res is monsterCard and player_node.active_weapon and card_res.value <= player_node.active_weapon.kill_cap):
					player_node.add_weapmon_card()
				else:
					player_node.point_handling(card_res.value, 1)
			card_res.resolve(card_res, player_node) #call the resolve function from the card resource
			card_collected.emit(self, card_res, value) #emit a signal showing a card was collected
			print(player_node.health) #Print the players current health
