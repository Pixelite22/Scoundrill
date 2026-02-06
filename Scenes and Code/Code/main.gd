extends Node2D

@onready var player: Node2D = $Player
@onready var deck: Node2D = $Deck
var room_cards : Array[Area2D] = []
var active_cards : Array[Card] = []

func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			room_cards.append(child)
			child.player_node = player
#			child.connect(card_collected, resolve_card)
	print(room_cards.size())
	
	#deck.deck_res.shuffle()
	active_cards = deck.deal_room(room_cards)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Run Away"):
		deck.ran_away(active_cards)
		active_cards = deck.deal_room(room_cards)

func resolve_card(card_type, value):
	pass

#func set_card_value():
#	deck.deal_room(room_cards)
