extends Node
#señales
signal bombs_value_changed(value : int)
signal score_changed(value: int)
signal key_changed(value : int)
#variables
var start_num_bombs : int = 20
var current_level : int = 0
var bombs : int = start_num_bombs : set = set_bombs
var score : int = 0 : set = set_score
var keys : int = 0 : set = set_key
var wood_box_points : int = 50
var enemy_kill_points : int = 250
# arrays de escenas para determinar el orden en que se cargan
var array_of_levels : Array[String] = [
	"res://Levels/Level1/Level1.tscn",
	"res://Levels/Level2/Level2.tscn"
]
# funcion para emitir una señal cuando actualizo la cantidad de bombas
func set_bombs(value):
	bombs = value
	emit_signal("bombs_value_changed", value)
# emito señal cuando actualizo el puntaje
func set_score(value):
	score = value
	emit_signal("score_changed", value)
#emito señal cuando actualizo la cantidad de la llave
func set_key(value):
	keys = value
	emit_signal("key_changed", value)
