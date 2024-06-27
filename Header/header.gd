extends Node2D

# variables
@onready var num_of_bombs : Label = $Bombs/NumOfBombs
@onready var score : Label = $Score/Points
@onready var key_yes : Sprite2D = $Key/Key_yes
@onready var key_no : Sprite2D = $Key/Key_no

#en ready conecto las señales y seteo el puntaje y las bombas al iniciar el nivel
func _ready():
	GameStats.bombs_value_changed.connect(act_bombs)
	GameStats.score_changed.connect(act_score)
	GameStats.key_changed.connect(act_key)
	num_of_bombs.text = "x " + str(GameStats.bombs)
	score.text = str(GameStats.score)
	
# capturo el evento del boton y disparo la escena principal
func _on_exit_button_pressed():
	Audios.play_click()
	get_tree().change_scene_to_file("res://MainScene/main_scene.tscn")

#seteo la cantidad de bombas
func act_bombs(new_value):
	num_of_bombs.text = "x " + str(new_value)

# seteo el puntaje
func act_score(new_score):
	score.text = str(new_score)

# Funcion para hacer o no visible cuando se recolecta la llave
func act_key(new_key_count):
	if new_key_count > 0:
		key_no.visible = false
		key_yes.visible = true
	else:
		key_no.visible = true
		key_yes.visible = false
