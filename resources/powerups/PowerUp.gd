extends RigidBody2D

signal hitByBullet

onready var firingSpeedIcon = get_node("IncreaseFiringSpeed")
onready var firePowerIcon = get_node("IncreaseFirePower")

var powerUpType

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	powerUpType = randi() % 2 + 1
	match powerUpType:
		1:  # increase firing speed
			firingSpeedIcon.show()
			firePowerIcon.hide()
		2:  #increase firepower
			firingSpeedIcon.hide()
			firePowerIcon.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func despawn():
	queue_free()


func _on_PowerUp_body_entered(body):
	var nodeImpactedWith = (str(body.get_name())).split("@",false,1)
	match nodeImpactedWith[0]:
		"Bullet":
			emit_signal("hitByBullet",self)
