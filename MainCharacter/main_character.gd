extends Area2D
class_name Player
#constantes y variables
const PIXEL : int = 32
var tween : Tween
var moving : bool = true
var current_idle = "idle_down"
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
var bomb : PackedScene = preload("res://Bomb/bomb.tscn")
#señales
signal portal_reached
signal player_die
#variables
@onready var valid_position = position
@onready var ray_up : RayCast2D = $RayCasts/up
@onready var ray_down : RayCast2D = $RayCasts/down
@onready var ray_right : RayCast2D = $RayCasts/right
@onready var ray_left : RayCast2D = $RayCasts/left
var death : bool = false

# en process determino el algoritmo si muero para detener todo y permitir en caso
# de no morir que el personaje pueda moverse si esta vivo
func _process(_delta):
	if death: return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction && not moving:
		move_me(direction)
	if !direction && !moving:
		animation.play(current_idle)
# capturo el evento de poner la bomba al presionar la tecla
func _input(event):
	if Input.is_action_pressed("place_bomb"):
		place_bomb()
#funcion para colocar la bomba donde esta el personaje
# tambien resta de GameStats.bombs la bomba usada.
func place_bomb():
	if GameStats.bombs > 0:
		GameStats.bombs -= 1
		var newbomb = bomb.instantiate()
		newbomb.position = self.position
		add_sibling(newbomb)
# funcion para mover el personaje e ir cambiando las animaciones 
func move_me(direction):
	var next_position : Vector2
	if direction.x < 0 && !ray_left.is_colliding():
		next_position = position + Vector2(-PIXEL, 0)
		animation.play("walk_left")
		current_idle = "idle_left"
		move_by_tween(next_position)
	elif direction.x > 0 && !ray_right.is_colliding():
		next_position = position + Vector2(PIXEL, 0)
		animation.play("walk_right")
		current_idle = "idle_right"
		move_by_tween(next_position)
	elif direction.y < 0 && !ray_up.is_colliding():
		next_position = position + Vector2(0,-PIXEL)
		animation.play("walk_up")
		current_idle = "idle_up"
		move_by_tween(next_position)
	elif direction.y > 0 && !ray_down.is_colliding():
		next_position = position + Vector2(0,PIXEL)
		animation.play("walk_down")
		current_idle = "idle_down"
		move_by_tween(next_position)
	else:
		animation.play(current_idle)
#funcion para el movimiento por tween
func move_by_tween(next_position: Vector2):
	moving = true
	valid_position = next_position
	tween = create_tween()
	tween.tween_property(self, "position", next_position, 0.2)
	tween.tween_callback(end_of_tween)
# finalizar el tween y cambio la animacion
func end_of_tween():
	moving = false
	animation.play("idle_down")
# capturo si entro en contacto con la bomba o enemigo para disparar la señal
# y si entro en contacto con otro item como portal, llave 
func _on_area_entered(area: Area2D):
	if area.is_in_group("bomb") || area.is_in_group("enemy"):
		emit_signal("player_die")
		animation.play("die")
		death = true
	elif area.is_in_group("collectable_keys"):
		Audios.play_key()
		GameStats.keys += 1
	elif area.is_in_group("collectable_bomb"):
		GameStats.bombs += 1
	elif area.is_in_group("portal"):
		if GameStats.keys > 0:
			emit_signal("portal_reached")
			GameStats.keys -= 1

func _on_ready_timer_timeout():
	moving = false
	pass # Replace with function body.
