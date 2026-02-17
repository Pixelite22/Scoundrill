extends Node2D

signal cards_added

@onready var player: Control = $Player
@onready var deck: Node2D = $Deck
@onready var discard_pile: Node2D = $"Discard Pile"
@onready var room: HBoxContainer = $Room

var card_ctr : int
var room_cards : Array[Control] = []
var active_cards : Array[Card] = []
var chosen_cards : Array[Control] = []

const card_path = preload("res://Scenes and Code/Scenes/playing_card.tscn")

func _ready() -> void:
	fill_room()
	await refresh_room()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Run Away"): #If there is an input linked to Run Away pressed
		deck.ran_away(active_cards) #Call the run away function on the deck
		refresh_room() #Due to await in deck_card, need to put a buffer function here to prevent async
	
	if card_ctr <= 1:
		while card_ctr < 4:
			deck.deal_room(room_cards)

func refresh_room():
	active_cards = await deck.deal_room(room_cards) #Set the active cards to the room cards, which are dealt by the deck node function

#function to resolve card affects
func discard(card_type): 
	discard_pile.deck_res.add_card(card_type) #Add card_resource to the discard pile to keep track of
	#print("Discard Pile now includes: ")
	for card in discard_pile.deck_res.cards: 
		print(card)

#called when a card is collected
func _on_card_collected(card_to_delete: Control, attribute: Variant, value: Variant) -> void:
	#print("card collected function reached")
	var i = 0 #Establish a counter variable
	
	for card in room_cards:
		if card == card_to_delete: #If a card within the array is marked for deletion
#			chosen_cards.append(card.card_res) #append that card to the chosen_card array
			card.queue_free() #free the card_node array
			room_cards.remove_at(i) #remove the card_node from the room
			discard(attribute) #call the discard function, passing the attribute along
#			print(chosen_cards)
			print(room_cards)
			card_ctr -= 1
		i += 1 #increment the counter
	

#When the deck emits the signal that a card needs to be added to the room, as a card was chosen
func _on_deck_card_needs_to_be_added(needed_cards: Variant) -> void:
	for new in range(needed_cards): #loop through the range of needed cards
		var card_instance = card_path.instantiate() #set a var and instantiate a card from the card_path
		room.add_child(card_instance) #add the child to the room node
		connect_cards(card_instance) #call the connect function to connect the signal and assure it is placed in the correct arrays
	print("Room_Cards size is: ", room_cards.size())
	print("These cards are: ", room_cards)

#fill the room function
func fill_room():
	for child in room.get_children(): #For child nodes in the children of the main node
		connect_cards(child) #Call the connect_cards, passing child into the function to connect
	print("Room_Cards size is: ", room_cards.size())
	print("These cards are: ", room_cards)
	cards_added.emit() #emit the card added signal

func connect_cards(card):
	room_cards.append(card) #Add that node into the room_card array
	card.player_node = player #set the player_node on the room_cards to player
	if not card.card_collected.is_connected(_on_card_collected): #loop to connect signals
		card.card_collected.connect(_on_card_collected)
	refresh_card_nodes(card) #call the refresh function

#Function to refresh card nodes
func refresh_card_nodes(card_refreshed):
	card_refreshed.card_res = deck.deck_res.draw() #sets the card resource to the next card in the deck
	card_refreshed.card_assign() #call the card assign function to actually let the card assign itself
	card_ctr += 1
