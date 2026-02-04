extends Resource
class_name Deck

signal deck_size_changed(amt)

@export var cards : Array[Card] = []

func empty():
	return cards.is_empty()

func draw():
	var card_drawn = cards.pop_front()
	deck_size_changed.emit(cards.size())
	return card_drawn

func add_card(card : Card):
	cards.append(card)
	deck_size_changed.emit(cards.size())

func shuffle():
	cards.shuffle()

func clear():
	cards.clear()
	deck_size_changed.emit(cards.size())

#func _to_string() -> String:
#	var _card_strings : PackedStringArray = []
#	for i in range(cards.size()):
#		_card_strings.append("%s: %s" % [i+1, cards[i].id])
#	return "\n".join(_card_strings)
