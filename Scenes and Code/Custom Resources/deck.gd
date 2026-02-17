extends Resource
class_name Deck

#Base resource for all decks

signal deck_size_changed(amt)

@export var cards : Array[Card] = []

#function for when the deck is empty
func empty():
	return cards.is_empty() #return whether or not the deck is empty to the line that called it

#Function used to draw a card from any deck
func draw():
	var card_drawn = cards.pop_front() #set card_drawn to the top card of the deck, and pop that card
	deck_size_changed.emit(cards.size()) #emit the deck size changed signal
	return card_drawn #return the drawn card

#function used to add cards back into the deck
func add_card(card : Card):
	cards.append(card) #append the card being put back into the deck into the deck array
	deck_size_changed.emit(cards.size()) #emit the size change

#function to shuffle the deck
func shuffle():
	cards.shuffle() #Do I really need to comment this?

#function to clear the deck
func clear():
	cards.clear() #clear the deck array
	deck_size_changed.emit(cards.size()) #you know what this does by now
