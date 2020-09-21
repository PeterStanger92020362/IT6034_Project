extends Control

onready var youLoseSound = get_node("YouLoseSound")
onready var youWinSound = get_node("YouWinSound")

onready var keyPressSound = get_parent().get_node("KeyPressedSound")

var haveLost = false
var haveWon = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	get_node("Sprite/YouLose").hide()
	get_node("Sprite/YouWin").hide()
	get_node("YouLoseBackGround").hide()
	get_node("YouWinBackGround").hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func win():
	haveWon = true
	youWinSound.play()
	get_node("YouWinBackGround").show()
	self.show()
	get_node("Sprite/YouWin").show()
	get_tree().paused = true


func lose():
	haveLost = true
	youLoseSound.play()
	get_node("YouLoseBackGround").show()
	self.show()
	get_node("Sprite/YouLose").show()
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("mouse1_clicked") && haveLost == true:
		print("returning to menu")
		keyPressSound.play()
		get_tree().change_scene("res://resources/menu/menu.tscn")
		get_tree().paused = false
		haveLost = false
	elif event.is_action_pressed("mouse1_clicked") && haveWon == true:
		print("starting the next level")
		keyPressSound.play()
		get_tree().reload_current_scene()
		get_tree().paused = false
		haveWon = false

