extends KinematicBody2D

var VP := Vector2.ZERO
var velocity := Vector2.ZERO
var acceleration := 0.1
var rotation_accel := 0.075
var max_speed := 10

var push := 400
var reflect := 2

var Rocketbullet = preload("res://Rocketbullet.tscn")
var Rocketbullets = null

var Boom = preload("res://Boom.tscn")
var Booms = null

func _ready():
	VP = get_viewport().size

func _physics_process(_delta):
	position.x = wrapf(position.x,0,VP.x)
	position.y = wrapf(position.y,0,VP.y)
	rotation += get_rotation()*rotation_accel
	velocity += get_input()*acceleration
	velocity = velocity.normalized() * clamp(velocity.length(),0,max_speed)
	var collision = move_and_collide(velocity,false)
	if collision != null and collision.collider is RigidBody2D:
		collision.collider.apply_central_impulse(-collision.normal * push)
		velocity = velocity + collision.normal*reflect
	elif collision != null:
		die()

	if Input.is_action_just_pressed("shoot"):
		if Rocketbullets == null:
			Rocketbullet = get_node_or_null("/root/Game/Rocketbullets")
		if Rocketbullets != null:
# warning-ignore:shadowed_variable
			var Rocketbullet = Rocketbullet.instance()
			Rocketbullet.position = position + Vector2(0,-20).rotated(rotation)
			Rocketbullet.rotation = rotation
			Rocketbullets.add_child(Rocketbullet)

func die():
	if Booms == null:
		Booms = get_node_or_null("/root/Game/Booms")
	if Booms != null:
# warning-ignore:shadowed_variable
		var Boom = Boom.instance()
		Booms.position = position
		Booms.add_child(Boom)
	queue_free()

func get_input():
	var toReturn := Vector2.ZERO
	if Input.is_action_pressed("forward"):
		toReturn.y -= 1
		$Thrust.show()
	else:
		$Thrust.hide()
	return toReturn.rotated(rotation)

func get_rotation():
	var toReturn := 0.0
	if Input.is_action_pressed("right"):
		toReturn += 1.0
	if Input.is_action_pressed("left"):
		toReturn -= 1.0
	return toReturn
