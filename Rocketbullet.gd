extends Area2D

var VP := Vector2.ZERO
var velocity := Vector2(0,-10)

var Booms = null
var Boom = preload("res://Boom.tscn")

func _ready():
	VP = get_viewport().size

func _physics_process(_delta):
	position += velocity.rotated(rotation)
	position.x = wrapf(position.x,0,VP.x)
	position.y = wrapf(position.y,0,VP.y)

func _on_Timer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	if Booms == null:
		Booms = get_node_or_null("/root/Game/Booms")
	if Booms != null:
# warning-ignore:shadowed_variable
		var Boom = Boom.instance()
		Boom.position = position
		Booms.add_child(Boom)
	if body.has_method("die"):
		body.die()
	queue_free()
