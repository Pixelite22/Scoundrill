extends Node2D

signal cards_added

var game_started := false
var game_over := false
var paused := false
var can_run := true

@onready var player: Control = $Player
@onready var deck: Node2D = $Deck
@onready var discard_pile: Node2D = $"Discard Pile"
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var room: HBoxContainer = $CanvasLayer/Room
@onready var game_win_screen: Control = $"Game Win Screen"
@onready var game_loss_screen: Control = $game_loss_screen
@onready var menu: Node2D = $Menu

var card_ctr : int
var room_cards : Array[Control] = []
var active_cards : Array[Card] = []
var chosen_cards : Array[Control] = []

var discard_pile_normal_pos = Vector2(81, 366)

const card_path = preload("res://Scenes and Code/Scenes/playing_card.tscn")

func _ready() -> void:
	$"Game Win Screen/Retry Button".pressed.connect(fill_deck)
	$"game_loss_screen/Retry Button".pressed.connect(fill_deck)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"): #If the pause button is pressed
		await get_tree().create_timer(0.5).timeout
		if not paused: #if the pause flag is false
			paused = true #set it to true
			discard_pile.background.show() #show the menu background
			discard_pile.position = Vector2(0,0) #Change the coordinates so it appears correctly
			discard_pile.fill_menu() #fill the menu
		elif paused: #However, if it isn't paused
			paused = false #set the flag to false
			discard_pile.background.hide() #hide the menu background
			discard_pile.position = discard_pile_normal_pos #Change the position back to normal
			discard_pile.empty_menu() #Empty the menu so it doesn't overload later
	
	#This if statement checks for game ending conditions
	if player.health <= 0 or deck.deck_res.empty(): #If the player loses all health or the deck is empty NOTE: might need to add to the winstate to wait till the room is out of cards
		deck.game_over = true #Set the game over flag on the deck
		game_over = true #Set the game over flag on the main.
		canvas_layer.hide()
		if deck.deck_res.empty(): #if the deck being empty caused this if statement to start
			$"game_win_screen/Point Label".text = "Points: " + str(player.point_value)
			game_win_screen.show() #They won the game and get the game win screen
		else: #Otherwise
			$"game_loss_screen/Point Label".text = "Points: " + str(player.point_value)
			game_loss_screen.show() #They lose
		get_tree().paused = true #pause the game so they don't accidentally keep clicking cards under the screen
	else: #As long as one of the two conditions to check for an ended game aren't true
		if Input.is_action_just_pressed("Run Away") and can_run: #If there is an input linked to Run Away pressed
			deck.ran_away(active_cards) #Call the run away function on the deck
			refresh_room() #Due to await in deck_card, need to put a buffer function here to prevent async
			can_run = false
		
		if game_started:
			if card_ctr <= 1 and not game_over: #if there is 1 or less cards in the room
				while card_ctr < 4: #while card counter is less then 4
					deck.deal_room(room_cards) #refill that room my guy... or girl... not sure who will read this
				can_run = true
	
	player.deck_info(deck.deck_res) #update the (currently) debug menu

func refresh_room():
	active_cards = await deck.deal_room(room_cards) #Set the active cards to the room cards, which are dealt by the deck node function

#function to resolve card affects
func discard(card_type): 
	discard_pile.deck_res.add_card(card_type) #Add card_resource to the discard pile to keep track of
	#print("Discard Pile now includes: ")
	for card in discard_pile.deck_res.cards: 
		print(card)

func fill_deck():
	for card in discard_pile.deck_res.cards:
		deck.deck_res.add_card(card)
	deck.deck_res.shuffle()
	_on_menu_start_button_pressed()

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


func _on_menu_start_button_pressed() -> void:
	canvas_layer.show()
	if game_loss_screen.is_visible_in_tree():
		game_loss_screen.hide()
	if game_win_screen.is_visible_in_tree():
		game_win_screen.hide()
	game_started = true #Set the game start flag to true
	fill_room() #Fill the room with function
	await refresh_room() #await the room refresh
