extends Area2D
class_name ItemCollectable

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("bounce")
	self.area_entered.connect(on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_area_entered(area: Area2D):
	if area.is_in_group("player"):
		queue_free()
