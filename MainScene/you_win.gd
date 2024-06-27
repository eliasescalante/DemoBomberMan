extends Node2D

func _on_button_pressed():
	Audios.play_click()
	get_tree().change_scene_to_file("res://MainScene/main_scene.tscn")

