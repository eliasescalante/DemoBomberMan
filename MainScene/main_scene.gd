extends Node2D
# seteo del puntaje, bombas y el nivel
#variables:
@onready var master : HSlider = $AudioSliders/Master
@onready var music : HSlider = $AudioSliders/Music
@onready var effects : HSlider = $AudioSliders/Effects

func _ready():
	get_volums()
	GameStats.current_level = 0
	GameStats.score = 0
	GameStats.bombs = 20
# evento para el boton start
func _on_start_game_pressed():
	Audios.play_click()
	var i : int = GameStats.current_level
	get_tree().change_scene_to_file(GameStats.array_of_levels[i])
# evento para el boton quit
func _on_quit_game_pressed():
	Audios.play_click()
	get_tree().quit()
	
#Control del volumen:
func _on_master_value_changed(value):
	print(value)
	AudioServer.set_bus_volume_db(0, value)
func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
func _on_effects_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)

func get_volums():
	master.value = AudioServer.get_bus_volume_db(0)
	music.value = AudioServer.get_bus_volume_db(1)
	effects.value = AudioServer.get_bus_volume_db(2)
