extends Node2D

signal cards_added

@onready var player: Control = $Player
@onready var deck: Node2D = $Deck
@onready var discard_pile: Node2D = $"Discard Pile"
@onready var room: HBoxContainer = $Room

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

func refresh_room():
	active_cards = await deck.deal_room(room_cards) #Set the active cards to the room cards, which are dealt by the deck node function

#function to resolve card affects
func discard(card_type):
	discard_pile.deck_res.add_card(card_type)
	#print("Discard Pile now includes: ")
	for card in discard_pile.deck_res.cards:
		print(card)


func _on_card_collected(card_to_delete: Control, attribute: Variant, value: Variant) -> void:
	#print("card collected function reached")
	var i = 0
	
	for card in room_cards:
		if card == card_to_delete:
			chosen_cards.append(card)
			card.queue_free()
			room_cards.remove_at(i)
			discard(attribute)
			print(chosen_cards)
			print(room_cards)
		i += 1

func refresh_card_nodes(card_refreshed):
	card_refreshed.card_res = deck.deck_res.draw()
	card_refreshed.card_assign()


func _on_deck_card_needs_to_be_added(needed_cards: Variant) -> void:
	for new in range(needed_cards):
		var card_instance = card_path.instantiate()
		room.add_child(card_instance)
		connect_cards(card_instance)
	print("Room_Cards size is: ", room_cards.size())
	print("These cards are: ", room_cards)

func fill_room():
	for child in room.get_children(): #For child nodes in the children of the main node
		connect_cards(child)
	print("Room_Cards size is: ", room_cards.size())
	print("These cards are: ", room_cards)
	cards_added.emit()

func connect_cards(card):
	room_cards.append(card) #Add that node into the room_card array
	card.player_node = player #set the player_node on the room_cards to player
	if not card.card_collected.is_connected(_on_card_collected):
		card.card_collected.connect(_on_card_collected)
	refresh_card_nodes(card)
