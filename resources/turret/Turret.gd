extends Node2D

onready var bullet_scene = preload("res://resources/bullet/Bullet.tscn")
onready var shootSound = get_node("ShootSound")

var distanceFromTurret = 25 # to spawn in front of turret
onready var turret = get_node("AnimatedSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	processInput()
	turret.speed_scale = GLOBAL.turretFiringSpeed


func processInput():
	rotateTurret()
	
	if Input.is_mouse_button_pressed(1) && $AnimatedSprite.animation == "idle":  #only lets you fire as fast as the animation
#		print("turret fired a bullet!")
		$AnimatedSprite.play("shoot")
		shootSound.play()
		spawnBullet()


func rotateTurret():
	var mousePosition = get_local_mouse_position()
	
	
	global_rotation += mousePosition.angle()*.1


func spawnBullet():
	var bullet = bullet_scene.instance()
	
	var turretDirection = Vector2(cos(self.global_rotation), sin(self.global_rotation)) #get the current direction of the turret
	bullet.set_velocity(turretDirection)
	
	var bulletSpawnPoint = self.global_position + turretDirection * distanceFromTurret
	bullet.global_position = bulletSpawnPoint
	
	bullet.setBulletFirePower()
	
	get_tree().get_root().add_child(bullet)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation != "idle":   #reset the animation back to the idle pose
		$AnimatedSprite.play("idle")
