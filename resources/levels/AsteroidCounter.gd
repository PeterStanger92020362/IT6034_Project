extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_node("AsteroidCount").text = str(get_tree().get_nodes_in_group("asteroids").size()) + " Left"
