extends Node2D

@export var deck_res : Deck

func _ready() -> void:
	print("Deck Detected")
	randomize_deck()
	deal_room()

func randomize_deck():
	print("Randomize Deck hit")
	deck_res.cards.shuffle()

func deal_room():
	print("Deal Room Hit")
	for i in range(4):
		print("card " + str(i) + " is " + deck_res.cards[i].resource_path)
