extends Sprite

onready var levelTimer = get_node("Timer")
onready var timeLabel = get_node("TimeLabel")

signal timerStopped

# Called when the node enters the scene tree for the first time.
func _ready():
	levelTimer.wait_time = GLOBAL.levelTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	timeLabel.text = str( stepify( levelTimer.get_time_left(),0.01 ) )
	
	if levelTimer.is_stopped():
		emit_signal("timerStopped")



func _on_Level_levelStarted():
	levelTimer.start()
