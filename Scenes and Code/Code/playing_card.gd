extends Sprite2D

@export var card_res : Card

var card_types := ["res://Resources/Cards/Health Potions/health_potion.tres", "res://Resources/Cards/Monsters/monster.tres", "res://Resources/Cards/Weapons/weapon.tres"]

var card_sprite_path_prefix := "res://Assets/kenney_playing-cards-pack/PNG/Cards (large)/card_"
var value
var suit
var valuestr


func _ready() -> void:
	value_assign()
	suit_assign()
	
	texture = load(card_sprite_path_prefix + suit + valuestr)


func suit_assign():
	card_res = load(card_types.pick_random())
	
	if value == 0:
		suit = "empty"
	else:
		if card_res is monsterCard:
			suit = ["clubs_", "spades_"].pick_random()
		if card_res is healthCard:
			suit = "hearts_"
		if card_res is weaponCard:
			suit = "diamonds_"
	


func value_assign():
	card_res.value_assign()
	value = card_res.value
	
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
	else:
		valuestr = "0" + str(value) + ".png"
