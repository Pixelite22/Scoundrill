extends Card
class_name healthCard

func resolve(card : Card, player):
	player.health += card.value #Add the value to the players health
	super.resolve(card, player)
