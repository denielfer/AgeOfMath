extends Node2D

func _ready():
	get_node("Node/ColorRect/Button").grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_button1_pressed():
	on_b(1,10)

func _on_button_2_pressed():
	on_b(2,60)


func _on_button_3_pressed():
	on_b(3,100)


func _on_button_4_pressed():
	on_b(4,400)


func _on_button_5_pressed():
	on_b(5,500)

func on_b(n:int,life):
	get_node('Node').queue_free()
	get_node('game').set_up(n,life)

