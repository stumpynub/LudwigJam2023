extends Node2D

@onready var yarn = preload("res://scenes/yarn.tscn")
var spawned = false 
var till_spawn = 10 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().points >= till_spawn: 
		if get_parent().points > 0 and get_parent().points % till_spawn == 0 and !spawned: 
			var y: RigidBody2D = yarn.instantiate()
			get_parent().add_child(y)
			y.global_position = self.global_position
			y.apply_central_impulse(global_transform.basis_xform(Vector2.UP) * 1000)
			spawned = true 
			get_parent().yarn_list.append(y)
			
			till_spawn += (get_parent().points / 2)
			print(till_spawn)
			
		elif spawned and get_parent().points > 0 and get_parent().points % till_spawn != 0: 
			spawned = false
