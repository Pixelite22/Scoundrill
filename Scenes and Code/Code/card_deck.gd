extends Node2D

signal card_needs_to_be_added(needed_cards)

@export var deck_res : Deck #Var to connect the deck resource to this code
@onready var main: Node2D = $".."


#ready function
func _ready() -> void:
	#print("Deck Detected")
	randomize_deck() #Call the randomize function

#Randomize function
func randomize_deck():
	deck_res.cards.shuffle() #Call the shuffle function on the card resources contained in the deck resource

func empty_room(card_arr : Array):
	print("Empty_Room Reached")
	
	return (4-card_arr.size())


#Function to deal a room worth of cards
func deal_room(room_cards):
	#Define variables for drawn cards and dealt out cards
	var drawn_card : Card
	var dealt_cards : Array[Card] = []
	var needed_cards : int = empty_room(room_cards)
	
	print("Cards Needed for this room: ", needed_cards)
	
	if needed_cards > 0:
		card_needs_to_be_added.emit(needed_cards)
		await main.cards_added
	
	for playing_card in room_cards: #For a playing_card node within the room_card array
		drawn_card = deck_res.draw() #set drawn_card to a card drawn used by the draw function in deck_res
		print(drawn_card, " has a value of ", drawn_card.value)
		dealt_cards.append(drawn_card) #Append the card to the dealt cards array
		if not is_instance_valid(playing_card):
			continue
		playing_card.card_res = drawn_card #Set the card resource on the playing card node to the resource stored in drawn card
		playing_card.card_assign() #use the card_assign() function in the playing card node to actually apply the data from the resource
	
	
	return dealt_cards #Return the dealt card array to whatever called the function

func ran_away(cards_replaced): #if the player ran away
	for playing_card in cards_replaced: #for a playing card node in the cards replaced array
		deck_res.add_card(playing_card) #Call the add_card function in the playing_card node
