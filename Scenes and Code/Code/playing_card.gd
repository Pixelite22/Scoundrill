extends Control
class_name Card_Node

signal card_collected(card_to_delete, attribute, value)

@export var card_res : Card
@onready var sprite: TextureRect = $Sprite
@onready var audio_player: AudioStreamPlayer = $"Audio Player"

#Define possible card types for if ever needing to hard call them
var card_types := ["res://Resources/Cards/Health Potions/health_potion.tres", "res://Resources/Cards/Monsters/monster.tres", "res://Resources/Cards/Weapons/weapon.tres"]

#Save the path prefix so the other parts can be added on
var card_sprite_path_prefix := "res://Assets/Images/kenney_playing-cards-pack/PNG/Cards (large)/card_"
var value
var suit
var valuestr

var cards_being_dealt : bool = false

var suit_flg = false
var value_flg = false

var player_node : Control

func _process(_delta: float) -> void:
	pass

#function to assign a card a value
func card_assign() -> void:
	if card_res.value and (card_res is monsterCard or healthCard or weaponCard):
		value_assign() #call value_assign
		suit_assign() #call suit_assign
	
	sprite.texture = load(card_sprite_path_prefix + suit + valuestr) #load the texture to the sprite of the created card

func suit_assign():
	if value == 0: #If the card has no value
		suit = "empty" #call the empty card path
	else: #but if it does have a value
		if card_res is monsterCard: #if it is a monster
			suit = ["clubs_", "spades_"].pick_random() #pick randomly from clubs or spades
			#note this will be changed later
		if card_res is healthCard: #If it is a health potion
			suit = "hearts_" #call the hearts text to be added to the path
		if card_res is weaponCard: #if it is a weapon
			suit = "diamonds_" #call the suit to be diamonds


func value_assign():
	card_res.value_assign() #call the value assign function within the card resource
	value = card_res.value #set value to the card resource's value
	
	#Following code handles odd text paths and royalty cards
	if value == 10:
		valuestr = "10.png"
	elif value == 11:
		valuestr = "J.png"
	elif value == 12:
		valuestr = "Q.png"
	elif value == 13:
		valuestr = "K.png"
	elif value == 14:
		valuestr = "A.png"
	elif value == 0:
		valuestr = ".png"
	else: #otherwise
		valuestr = "0" + str(value) + ".png" #add a 0 and the value to the end

func play_click(): #NOTE: Not currently working as intended
	var audio = AudioStreamPlayer.new() #Create a new audio player node
	audio.stream = audio_player.stream #set the stream to the stored steam in the sound player
	audio.volume_db = audio_player.volume_db #Match the volumes
	add_child(audio) #Add the child to the tree
	audio.stream_paused = false #Make sure it isn't paused
	audio.stop() #Stop any of the audio currently playing
	audio.play(0.45) #Play from 0.45 seconds
	audio.finished.connect(audio.queue_free) #Connect the finished signal to the queue free function

func _gui_input(event: InputEvent) -> void:
	#As long as the card isn't marked as a display card
	if self.name != "Display Card":
		if not cards_being_dealt:
			#if a player clicks on a card
			if event is InputEventMouseButton and event.is_pressed():
				#If it was a left click
				if event.button_index == MOUSE_BUTTON_LEFT:
					play_click() #Play the click noise (not fully working yet)
					if card_res is weaponCard or card_res is monsterCard: #If the card_res is a monster or weapon
						if card_res is weaponCard: #if it is a monster
							player_node.clear_weapmons() #clear the weapon and monster array
							#if it is a weapon or it is a monster who is weaker then the active weapons max kill_ctr
						if card_res is weaponCard or (card_res is monsterCard and player_node.active_weapon and card_res.value <= player_node.active_weapon.kill_cap):
							player_node.add_weapmon_card() #add it to the top of the array and the top of the weapon stack
						else: #If it didn't fit the previous if, 
							player_node.point_handling(card_res.value, 1) #just do point calculation
							#note, we don't do elif for the first branch so it can go into point handling after
					card_res.resolve(card_res, player_node, true) #call the resolve function from the card resource
			
				#If it was a right click
				if event.button_index == MOUSE_BUTTON_RIGHT:
					play_click() #play sound effect
					if card_res is weaponCard or card_res is monsterCard: #If they clicked on a non health potion
						player_node.point_handling(card_res.value, 1) #go into point handling
					card_res.resolve(card_res, player_node, false) #call the resolve function from the card resource
				
				card_collected.emit(self, card_res, value) #emit a signal showing a card was collected
