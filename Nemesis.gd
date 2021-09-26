extends KinematicBody2D

var VP = Vector2.ZERO
var direction = 0.0
var dir_speed = 0.01
var velocity = Vector2(2,0)

var Rocketbullets = null
var Nemesisbullet

var Booms = null
var Boom = preload("res://Boom.tscn")


func _ready():
	VP = get_viewport().size
	randomize()

func _physics_process(_delta):
	direction += dir_speed
	while direction > 2*PI:
		direction -= 2*PI

func die():
	if Booms == null:
		Booms = get_node_or_null("/root/Game/Booms")
	if Booms != null:
		var Boom = Boom.instance()
		Boom.position = position
		Booms.add_child(Boom)
	queue_free()


func _on_Timer_timeout():
	if Rocketbullets == null:
		Rocketbullets = get_node("/root/Game/Bullets")
	if Rocketbullets != null:
		var Rocketbullets = Nemesisbullet.instance()
		Nemesisbullet.position = position
		Nemesisbullet.rotation = direction
		Rocketbullets.add_child(Nemesisbullet)
