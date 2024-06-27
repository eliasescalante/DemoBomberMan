extends Area2D
#variables
@onready var ray_up : RayCast2D = $RayCasts/up
@onready var ray_down : RayCast2D = $RayCasts/down
@onready var ray_right : RayCast2D = $RayCasts/right
@onready var ray_left : RayCast2D = $RayCasts/left
@onready var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready var level : LevelClass = get_tree().get_first_node_in_group("level")
#constante
const PIXELS = 16
#variables
var moving : bool = true
var tween : Tween
var actual_direction : Callable = move_left
@onready var valid_position : Vector2 = position

# en process defino el algoritmo para lograr movimiento aleatorio en los enemigos
func _process(_delta):
	if !moving:
		if need_to_change():
			var posible_moves : Array = find_directions()
			posible_moves.shuffle()
			if posible_moves.size() > 0:
				posible_moves[0].call()
				actual_direction = posible_moves[0]
		else:
			actual_direction.call()
# funcion para determinar si cambio de direccion
func need_to_change():
	if actual_direction == move_up:
		return ray_up.is_colliding()
	elif actual_direction == move_down:
		return ray_down.is_colliding()
	elif actual_direction == move_left:
		return ray_left.is_colliding()
	elif actual_direction == move_right:
		return ray_right.is_colliding()
# funcion para encontrar la direccion a mover
func find_directions():
	var array_moves : Array[Callable] = []
	if !ray_up.is_colliding():
		array_moves.append(move_up)
	if !ray_down.is_colliding():
		array_moves.append(move_down)
	if !ray_left.is_colliding():
		array_moves.append(move_left)
	if !ray_right.is_colliding():
		array_moves.append(move_right)
	return array_moves
# para moverme arriba
func move_up():
	animations.play("up")
	move_by_tween(valid_position + (Vector2.UP * PIXELS))
# para moverme abajo
func move_down():
	animations.play("down")
	move_by_tween(valid_position + (Vector2.DOWN * PIXELS))
#para moverme izquierda
func move_left():
	animations.play("left")
	move_by_tween(valid_position + (Vector2.LEFT * PIXELS))	
#para moverme derecha
func move_right():
	animations.play("right")
	move_by_tween(valid_position + (Vector2.RIGHT * PIXELS))
# funcion para moverme por tween
func move_by_tween(next_position: Vector2):
	moving = true
	valid_position = next_position
	tween = create_tween()
	tween.tween_property(self, "position", next_position, 0.5)
	tween.tween_callback(end_of_tween)
# funcion para terminar el tween
func end_of_tween():
	moving = false
# utilizo el timer para detener por unos segundos la escena y evitar un bug
func _on_ready_timer_timeout():
	moving = false
#capturo el evento cuando el enemigo entra en contacto con la bomba
func _on_area_entered(area : Area2D):
	if area.is_in_group("bomb"):
		call_deferred("pop_bomb", position)
		GameStats.score += GameStats.enemy_kill_points
		queue_free()
# funcion para dropear una bomba cuando muere un bat
func pop_bomb(my_position):
	var new_bomb = level.collectable_bomb.instantiate()
	new_bomb.position = my_position
	level.add_child(new_bomb)

