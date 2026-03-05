extends Node2D

signal start_button_pressed


func _on_start_button_pressed() -> void:
	hide()
	start_button_pressed.emit()


func _on_end_button_pressed() -> void:
	get_tree().quit()
