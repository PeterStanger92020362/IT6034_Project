extends Control

onready var WelcomePopUp = get_node("AlertSound")

signal popUpDismissed

onready var backStory = get_node("Sprite/BackStory")
onready var howToPlay = get_node("Sprite/HowToPlay")
onready var levelNumber = get_node("Sprite/LevelNumber")
var popUpStatus = 0


func _ready():
	pass


func _process(_delta):
	levelNumber.text = "Level " + str(GLOBAL.level)
	if GLOBAL.level > 1 && popUpStatus <= 2:
		popUpStatus = 2
	else:
		match popUpStatus:
			0:
				showBackStory()
			1:
				showHowToPlay()
			2:
				showLevelNumber()
			3:
				dismissPopUp()
				popUpStatus = 0


func showBackStory():
	backStory.show()
	howToPlay.hide()
	levelNumber.hide()


func showHowToPlay():
	backStory.hide()
	levelNumber.hide()
	howToPlay.show()


func showLevelNumber():
	backStory.hide()
	howToPlay.hide()
	levelNumber.show()


func dismissPopUp():
	emit_signal("popUpDismissed")


func _input(event):
	if event.is_action_pressed("mouse1_clicked") && self.is_visible_in_tree():
		popUpStatus += 1
