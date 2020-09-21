extends RigidBody2D

var speed = 200

onready var explosionSound = get_node("ExplosionSound")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$AnimatedSprite.rotate(1)  # spin the bullets and explosion for a cool effect
	
	if position.y < 10 || position.y > 1090:
		despawn()
	if position.x < 10 || position.x > 1930:
		despawn()


func set_velocity(vector):
	speed *= GLOBAL.turretFirepower
	self.set_linear_velocity(Vector2(speed * vector.x, speed * vector.y))


func despawn():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	despawn()


# if bullet collides with another physics body = explode!
func _on_Bullet_body_entered(_body):
	
#	var nodeImpactedWith = (str(body.get_name())).split("@",false,1)
#	print("a bullet hit the " + nodeImpactedWith[0])
	
#	set_deferred(str($"CollisionShape2D".disabled), true)
	
	if !$"AnimatedSprite".playing:  #makes it so explosion is only processed once
		explosionSound.play()
		$"AnimatedSprite".play("explosion")
		set_velocity(Vector2(0,0))


func setBulletFirePower():
	get_node("AnimatedSprite").scale *= GLOBAL.turretFirepower
	get_node("CollisionShape2D").shape.radius = 3 * GLOBAL.turretFirepower
