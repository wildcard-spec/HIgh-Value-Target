extends CenterContainer

onready var Arena = get_node("MarginContainer/HBoxContainer/CanvasLayer/Menu Options/Arena")






func _on_Arena_pressed():
	get_tree().change_scene("res://scenes/playground.tscn")


func _on_Customizer_button_pressed():
	get_tree().change_scene("res://Customizer.tscn")
