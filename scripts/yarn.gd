extends RigidBody2D

var health = 3 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta): 
	if get_colliding_bodies().size() > 0: 
		print("coasdf")
		$HitPlayer.play()


func hit(): 
	
	if $YarnSprite.scale.x < .2: 
		print("yarn")
