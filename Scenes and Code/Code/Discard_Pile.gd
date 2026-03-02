extends Node2D

@export var deck_res : Deck #Var to connect the deck resource to this code
@onready var available_cards: BoxContainer = $"Available Cards"
@onready var available_cards_2: BoxContainer = $"Available Cards2"
@onready var available_cards_3: BoxContainer = $"Available Cards3"
@onready var available_cards_4: BoxContainer = $"Available Cards4"
@onready var background: ColorRect = $"ColorRect"
var container_array := [available_cards, available_cards_2, available_cards_3, available_cards_4]

const card_path = preload("res://Scenes and Code/Scenes/playing_card.tscn")

#ready function
func _ready() -> void:
	print("Discard_pile node Detected")

func fill_menu():
	for cards in deck_res.cards: #For the cards within the deck
		var card_instance = card_path.instantiate() #create the nodes
		for container in container_array: #And for each container
			if container.get_child_count() < 11: #If the container has less then 11 cards
				container.add_child(card_instance) #Add a card to the container

func empty_menu():
	for container in container_array: #for a container in the container
		if container.get_children(): #if the container has child nodes
			for card in container.get_children(): #For a card in the container nodes
				card.queue_free() #Free the node
