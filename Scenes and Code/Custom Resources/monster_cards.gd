extends Card
class_name monsterCard

func resolve(card : Card, player):
	if player.active_weapon and card.value >= player.active_weapon.value: #If the player has a weapon and the selected card's value is greater then the player's weapon's value
		player.health -= (card.value - player.active_weapon.value) #Subtract the weapon value from the card value, and subtract that from the players health
	else: #otherwise
		pass #pass the statement
	super.resolve(card, player)
