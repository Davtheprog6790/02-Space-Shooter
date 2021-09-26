extends Node2D

var acc_amount = 0.02
var velocity = Vector2(0,0)
var min_range = Vector2(0,0)
var max_range = Vector2(0,0)

var Rocketbullet = preload("res://Rocketbullet.tscn")
var Rocketmans = null

var Boom = preload("res://Boom.tscn")
var Booms null

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
		if Bullets == null:
			Bullets = get_node_or_null("/root/Game/Bullets")
		if Bullets != null:
			var bullet = Bullet.instance()
			bullet.position = position + Vector2(0,-20).rotated(rotation)
			bullet.rotation = rotation
			Bullets.add_child(bullet)

func die():
	if Explosions == null:
		Explosions = get_node_or_null("/root/Game/Explosions")
	if Explosions != null:
		var explosion = Explosion.instance()
		explosion.position = position
		Explosions.add_child(explosion)
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
