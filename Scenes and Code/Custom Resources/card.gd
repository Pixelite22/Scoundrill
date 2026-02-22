extends Resource
class_name Card

enum Effect {NONE, STRONG, WEAK, FIRE, ICE, POISON} #Define possible effect names for the future

@export_group("Card Attributes")
@export var effects : Effect
@export var value : int

#Function for assigning values, taken care of in other card resources
func value_assign():
	pass

#function to resolve card effects and damage
func resolve(card : Card, player, use_weapon : bool):
	print("Base Resolved")

#Function for applying the effect of a card, currently handled in individiual card resources
func apply_effect(card : Card):
	pass

#Function asking permssion for use of weapon if weapon is equipped
func permission(want_to_use):
	pass
	
