extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var animation : AnimationPlayer = $AnimationPlayer
var tween = Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	init_tween()


func init_tween():
	tween = create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1, 3)
	tween.tween_callback(detonate)

func detonate():
	Audios.play_bomb()
	animation.play("detonate")
	
	

