extends Node2D

onready var asteroidScene = preload("res://resources/asteroid/Asteroid1.tscn")
onready var asteroidSpawnArea = get_node("AsteroidSpawnArea")
onready var turretLocation = Vector2(get_node("Turret").global_position)

onready var powerUpScene = preload("res://resources/powerups/PowerUp.tscn")

onready var keyPressedSound = get_node("KeyPressedSound")
onready var levelBGM = get_node("LevelBGM")
onready var welcomePopUp = get_node("WelcomePopUp")

onready var outcomeDialogBox = get_node("OutcomeDialogBox")

onready var powerUpTimer = get_node("PowerUpTimer")

var chosenOption = 0
signal levelStarted

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("PowerUpLabel").hide()
	displayWelcomePopUp()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_key_pressed(16777217) && not keyPressedSound.is_playing():  #ESC key exits level
		exitToMenu()
	
	# chance of powerup spawning??
	
	if get_tree().get_nodes_in_group("asteroids").size() == 0:
		print("asteroids group equals zero")
		youWin()
	
	if get_node("PowerUpLabel/PowerUpTimer").is_stopped():
		get_node("PowerUpLabel").hide()


func spawnAsteroid():

	var asteroid = asteroidScene.instance()

	asteroid.set_random_spin()
	asteroid.position = asteroidRandomSpawn()
	asteroid.set_velocity(turretLocation)
	
	asteroid.connect("hitBullet",self,"_on_Asteroid_hitBullet")
	asteroid.connect("hitPlanet",self,"_on_Asteroid_hitPlanet")
	asteroid.connect("hitMoon",self,"_on_Asteroid_hitMoon")
	
	asteroid.add_to_group("asteroids")
	add_child(asteroid)


func asteroidRandomSpawn():
	#need to randomize between the 3 spawn locations
	var spawnArea
	
	var spawnLocation = randi() % 10 + 1
	match spawnLocation:
		1:
			spawnArea = get_node("AsteroidSpawnArea/SpawnLeft")
		2:
			spawnArea = get_node("AsteroidSpawnArea/SpawnRight")
		_:
			spawnArea = get_node("AsteroidSpawnArea/SpawnTop")
	
	var spawnAreaSize = spawnArea.shape.extents
	var spawnAreaPos = spawnArea.position
	
	var positionInArea = Vector2(0,0)
	positionInArea.x = ((spawnAreaPos.x - spawnAreaSize.x/2) + rand_range(0,1) * spawnAreaSize.x)
	positionInArea.y = ((spawnAreaPos.y - spawnAreaSize.x/2) + rand_range(0,1) * spawnAreaSize.y)
	
	return positionInArea


func exitToMenu():
	keyPressedSound.play()
	chosenOption = 2


func _on_KeyPressedSound_finished():
	if chosenOption == 1:
		pass
	elif chosenOption == 2:
		get_tree().change_scene("res://resources/menu/menu.tscn")



func _on_WelcomePopUp_popUpDismissed():
	welcomePopUp.hide()
	get_tree().paused = false
	if get_tree().get_nodes_in_group("asteroids").size() == 0:
		startLevel()


func startLevel():
	levelBGM.play()
	emit_signal("levelStarted")

	GLOBAL.asteroidsRemaining = GLOBAL.asteroidCount * GLOBAL.level
	print("starting new level")


	for _i in range(GLOBAL.asteroidsRemaining):
		spawnAsteroid()
	print(get_tree().get_nodes_in_group("asteroids").size())
	
	powerUpTimer.start()


func displayWelcomePopUp():
	welcomePopUp.show()
	$WelcomePopUp/AlertSound.play()
	get_tree().paused = true


func _on_Clock_timerStopped():
	youWin()


func _on_Asteroid_hitBullet(hitAsteroid):
	destroyAsteroid(hitAsteroid)


func _on_Asteroid_hitPlanet():
	youLose()


func _on_Asteroid_hitMoon():
#	print("an asteroid hit the moon!")
	pass


func youLose():
	GLOBAL.turretFirepower = 1
	GLOBAL.turretFiringSpeed = 1
	outcomeDialogBox.lose()


func youWin():
	GLOBAL.level += 1
	outcomeDialogBox.win()


func destroyAsteroid(hitAsteroid):
	
	#despawn destroyed asteroid
	hitAsteroid.despawn()


func spawnPowerUp():
	var powerUp = powerUpScene.instance()
	var powerUpPosX = rand_range(300,1620)
	var powerUpPosY = rand_range(200,880)
	powerUp.position = Vector2(powerUpPosX,powerUpPosY)
	powerUp.connect("hitByBullet",self,"_on_PowerUp_hitByBullet")
	add_child(powerUp)


func _on_PowerUp_hitByBullet(PowerUp):
	get_node("PowerUpLabel").set_position(Vector2(PowerUp.position.x-40,PowerUp.position.y))
	match PowerUp.powerUpType:
		1:
			GLOBAL.turretFiringSpeed += 1
			get_node("PowerUpLabel").text = "Firing Speed \nIncreased!"
			print("firing speed increased!")
		2:
			GLOBAL.turretFirepower += 1
			get_node("PowerUpLabel").text = "Firepower \nIncreased!"
			print("fire power increased!")
	get_node("PowerUpLabel/PowerUpTimer").start()
	get_node("PowerUpLabel").show()
	PowerUp.despawn()


func _on_PowerUpTimer_timeout():
	spawnPowerUp()
	powerUpTimer.start()
