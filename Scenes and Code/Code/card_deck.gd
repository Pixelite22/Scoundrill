extends Node2D

@export var deck_res : Deck #Var to connect the deck resource to this code

#ready function
func _ready() -> void:
	print("Deck Detected")
	randomize_deck() #Call the randomize function

#Randomize function
func randomize_deck():
	print("Randomize Deck hit")
	deck_res.cards.shuffle() #Call the shuffle function on the card resources contained in the deck resource

#Function to deal a room worth of cards
func deal_room(room_cards):
	#Define variables for drawn cards and dealt out cards
	var drawn_card : Card
	var dealt_cards : Array[Card] = []
	
	
	for playing_card in room_cards: #For a playing_card node within the room_card array
		drawn_card = deck_res.draw() #set drawn_card to a card drawn used by the draw function in deck_res
		print(drawn_card, " has a value of ", drawn_card.value)
		dealt_cards.append(drawn_card) #Append the card to the dealt cards array
		playing_card.card_res = drawn_card #Set the card resource on the playing card node to the resource stored in drawn card
		playing_card.card_assign() #use the card_assign() function in the playing card node to actually apply the data from the resource
	
	
	return dealt_cards #Return the dealt card array to whatever called the function

func ran_away(cards_replaced): #if the player ran away
	for playing_card in cards_replaced: #for a playing card node in the cards replaced array
		deck_res.add_card(playing_card) #Call the add_card function in the playing_card node
