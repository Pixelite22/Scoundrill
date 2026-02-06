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
		if card.value - player.active_weapon.value >= 0:
			player.health -= (card.value - player.active_weapon.value)
		else:
			pass
	if card is weaponCard:
		player.active_weapon = card
	if card is healthCard:
		player.health += card.value

func apply_effect(card : Card):
	pass
