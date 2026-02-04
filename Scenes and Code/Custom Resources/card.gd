extends Resource
class_name Card

enum Effect {NONE, STRONG, WEAK, FIRE, ICE, POISON}

@export_group("Card Attributes")
@export var effects : Effect
@export var value : int

func value_assign():
	value = randi_range(2, 14)

func resolve(card : Card, player):
	pass

func apply_effect(card : Card):
	pass
