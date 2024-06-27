extends Node2D

@onready var score : Label = $ColorRect/Info/Score

func _ready():
	score.text = str(GameStats.score)

func _on_button_pressed():
	Audios.play_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainScene/main_scene.tscn")
