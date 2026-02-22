extends Card
class_name weaponCard

var kill_cap : int = 15

func resolve(card : Card, player, use_weapon : bool):
	player.active_weapon = card #Set the players active weapon to the weapon card
	player.weapmon_arr[0].card_res = self
	player.weapmon_arr[0].card_assign()
	
	super.resolve(card, player, use_weapon)
