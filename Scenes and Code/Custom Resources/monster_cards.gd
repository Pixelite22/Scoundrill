extends Card
class_name monsterCard

func resolve(card : Card, player, use_weapon : bool):
	if use_weapon: #If the player uses a weapon to attack a monster card
		if player.active_weapon and player.active_weapon.kill_cap >= card.value and use_weapon: #If the player has a weapon and the selected card's value is greater then the player's weapon's value
			player.active_weapon.kill_cap = card.value - 1 #the player's weapon's kill cap goes down to one less then the monster they killed with it
			player.weapmon_arr[-1].card_res = self #Set the last card in the weapon and monster array to this card
			player.weapmon_arr[-1].card_assign() #and call the card_assign function on it so it makes itself appear on the weapon and monster combo
			if card.value >= player.active_weapon.value: #if the strength of the monster is more then or equal to the weapon's value
				player.health -= (card.value - player.active_weapon.value) #Subtract the weapon value from the card value, and subtract that from the players health
		else: #otherwise
			player.health -= card.value #subtract from the player's health directly
	elif not use_weapon: #And if the decide not to use a weapon, or don't have one
		player.health -= card.value #Subtract from the health directly again
	
	super.resolve(card, player, use_weapon) #then resolve anything in the original resolve function
