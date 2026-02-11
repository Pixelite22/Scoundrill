extends Node2D

@onready var player: Node2D = $Player
@onready var deck: Node2D = $Deck
@onready var discard_pile: Node2D = $"Discard Pile"
var room_cards : Array[Area2D] = []
var active_cards : Array[Card] = []
var chosen_cards : Array[Area2D] = []

func _ready() -> void:
	for child in get_children(): #For child nodes in the children of the main node
		if child is Area2D: #if the child is an Area2D node
			room_cards.append(child) #Add that node into the room_card array
			child.player_node = player #set the player_node on the room_cards to player
	print(room_cards.size())
	
	#deck.deck_res.shuffle()
	active_cards = deck.deal_room(room_cards) #Set the active cards to the room cards, which are dealt by the deck node function

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Run Away"): #If there is an input linked to Run Away pressed
		deck.ran_away(active_cards) #Call the run away function on the deck
		active_cards = deck.deal_room(room_cards) #reset the active cards on the room cards

#function to resolve card affects
func discard(card_type, value):
	discard_pile.deck_res.add_card(card_type)
	print("Discard Pile now includes: ")
	for card in discard_pile.deck_res.cards:
		print(card)


func _on_card_collected(card_to_delete: Area2D, attribute: Variant, value: Variant) -> void:
	for card in room_cards:
		if card == card_to_delete:
			chosen_cards.append(card)
			card.queue_free()
			discard(attribute, value)
			print(chosen_cards)
