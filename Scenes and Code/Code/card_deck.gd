extends Node2D

@export var deck_res : Deck

func _ready() -> void:
	print("Deck Detected")
	randomize_deck()

func randomize_deck():
	print("Randomize Deck hit")
	deck_res.cards.shuffle()

func deal_room(room_cards):
	var drawn_card : Card
	var dealt_cards : Array[Card] = []
	
	for playing_card in room_cards:
		drawn_card = deck_res.draw()
		print(drawn_card, " has a value of ", drawn_card.value)
		dealt_cards.append(drawn_card)
		playing_card.card_res = drawn_card
		playing_card.card_assign()
	
	
	return dealt_cards

func ran_away(cards_replaced):
	for playing_card in cards_replaced:
		deck_res.add_card(playing_card)
