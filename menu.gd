extends Control

func _ready():
	get_node('escolhas/levels').grab_focus()


func _on_levels_pressed():
	get_tree().change_scene_to_file("res://level selection.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_controles_pressed():
	get_tree().change_scene_to_file("res://controles.tscn")
