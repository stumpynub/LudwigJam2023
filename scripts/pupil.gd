extends Sprite2D

@onready var game = get_parent()
@onready var start_pos = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !game.end: 
		global_position.x = clamp(global_position.x, start_pos.x - 10, start_pos.x + 10)
		global_position = lerp(global_position, game.lowest_yarn.global_position, delta)
		global_position.y = clamp(global_position.y, start_pos.y - 10, start_pos.y + 10)
