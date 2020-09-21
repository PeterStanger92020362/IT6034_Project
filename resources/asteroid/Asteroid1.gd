extends RigidBody2D

var speed
signal hitBullet
signal hitPlanet
signal hitMoon


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func set_velocity(turretLocation):
	speed = rand_range(50,((GLOBAL.level*1.5)*50))
	var vector = self.position.direction_to(turretLocation)
	self.set_linear_velocity(Vector2(speed * vector.x, speed * vector.y))


func set_random_spin():
	#set random rotation of sprite
	match randi() % 2:
		0:
			$"AnimatedSprite".scale.x = -1
		1:
			$"AnimatedSprite".scale.x = 1
	match randi() % 2:
		0:
			$"AnimatedSprite".scale.y = -1
		1:
			$"AnimatedSprite".scale.y = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func despawn():
	GLOBAL.asteroidsRemaining -= 1
	queue_free()


func _on_Asteroid_body_entered(body):
	var nodeImpactedWith = (str(body.get_name())).split("@",false,1)
	
	match nodeImpactedWith[0]:
		"Bullet":
			emit_signal("hitBullet",self)
		"Planet":
			emit_signal("hitPlanet")
		"Moon":
			emit_signal("hitMoon",self)
