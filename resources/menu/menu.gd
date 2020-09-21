extends Control

onready var videoPlayer = get_node("VideoPlayer")
onready var buttonClickSound = get_node("AudioStreamPlayer")
var chosenOption = 0
onready var menuMusic = get_node("MenuMusic")


func _ready():
	menuMusic.play()


func _process(_delta):
	if not videoPlayer.is_playing():  #loop background video
		videoPlayer.play()
	if Input.is_key_pressed(16777217) && not buttonClickSound.is_playing():
		buttonClickSound.play()
		chosenOption = 2


func _on_AudioStreamPlayer_finished():
	if chosenOption == 1:
		startGame()
	elif chosenOption == 2:
		exitGame()


func _on_exitButton_pressed():
	buttonClickSound.play()
	chosenOption = 2


func exitGame():
	get_tree().quit()


func _on_startButton_pressed():
	buttonClickSound.play()
	chosenOption = 1


func startGame():
	get_tree().change_scene("res://resources/levels/Level.tscn")
	GLOBAL.level = 1
