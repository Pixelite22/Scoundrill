extends Node2D

@export_group("Stats")
@export var health := 20
@export var active_effect := "NONE"

var effect := ["NONE", "BURNT", "FROZEN", "POISON"]

func _process(delta: float) -> void:
	if health > 20:
		health = 20
	if health < 0:
		health = 0
