extends Resource
class_name Card

enum Effect {NONE, STRONG, WEAK, FIRE, ICE, POISON}

@export_group("Card Attributes")
@export var effects : Effect
@export var value : int

func value_assign():
	pass

func resolve(card : Card, player):
	if card is monsterCard:
		player.health -= card.value
	if card is weaponCard:
		pass
	if card is healthCard:
		player.health += card.value

func apply_effect(card : Card):
	pass
