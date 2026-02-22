extends Card
class_name healthCard

func resolve(card : Card, player, use_weapon : bool):
	player.health += card.value #Add the value to the players health
	super.resolve(card, player, use_weapon)
