extends Card
class_name weaponCard

var kill_cap : int = 15

func resolve(card : Card, player):
	player.active_weapon = card #Set the players active weapon to the weapon card
	super.resolve(card, player)
