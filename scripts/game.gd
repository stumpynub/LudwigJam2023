extends Node2D

## This script is poopoo

var points = 0 
var yarn_list = []

@onready var left_paw = $LeftPaw
@onready var right_paw = $RightPaw
@onready var start_left = left_paw.global_position
@onready var start_right = right_paw.global_position
@onready var hit_player = $HitPlayer
@onready var left_foot = $LeftFoot
@onready var right_foot = $RightFoot

@onready var start_left_foot_y = left_foot.global_position.y
@onready var start_right_foot_y = right_foot.global_position.y


var lowest_yarn = null 
var left_kicked = false 
var right_kicked = false 
var end = false 
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("yarn"): 
		yarn_list.append(node)
	
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if Input.is_action_just_pressed("click"): 
		$ClickLabel.hide()
		get_tree().paused = false 
	
	if yarn_list.size() >= 1: 
		lowest_yarn = yarn_list[0] 
		
		for yarn in yarn_list:
			if yarn.global_position.y > lowest_yarn.global_position.y: 
				lowest_yarn = yarn
			
	if lowest_yarn.global_position.y >= get_viewport_rect().size.y: 
		if !end:
			$AnimationPlayer.play("end")
			$Meow.play()
			end = true
	# paw hitting
	if Input.is_action_just_pressed("click"): 
		if get_global_mouse_position().x < get_viewport_rect().size.x / 2: 
			left_paw.global_position = get_global_mouse_position()
			left_paw.look_at(get_global_mouse_position().normalized()) 
		else: 
			right_paw.global_position = get_global_mouse_position()
			right_paw.look_at(get_global_mouse_position().normalized()) 
			right_paw.rotation_degrees = -right_paw.rotation_degrees
		
		hit_check()
		
	left_paw.global_position = lerp(left_paw.global_position, start_left, delta * 5)
	right_paw.global_position = lerp(right_paw.global_position, start_right, delta * 5)
	
	left_paw.rotation = lerp(left_paw.rotation, 0.0, delta * 5)
	right_paw.rotation = lerp(right_paw.rotation, 0.0, delta * 5)
	
	# yuckyness
	# foot kick return 
	left_foot.global_position.y = lerp(left_foot.global_position.y, start_left_foot_y, delta * 5)
	right_foot.global_position.y = lerp(right_foot.global_position.y, start_right_foot_y, delta * 5)
	
	left_foot.global_position.x = clamp(left_foot.global_position.x, 0, get_viewport_rect().size.x)
	right_foot.global_position.x = clamp(right_foot.global_position.x, 0, get_viewport_rect().size.x)
	
	if !end:
		if is_ball_left(): 
			left_foot.global_position.x = lerp(left_foot.global_position.x, lowest_yarn.global_position.x, delta * 3)
			
			var d = left_foot.global_position.distance_to(lowest_yarn.global_position)
			
			if d < 50 and !left_kicked: 
				left_kicked = true 
				left_foot.global_position.y -= 15
				lowest_yarn.linear_velocity.y = 5
				points += 1
				lowest_yarn.apply_central_impulse((Vector2.UP * 100) + (Vector2.RIGHT * randf_range(-100, 100)))
				hit_player.play()
			elif d > 50: 
				left_kicked = false 
		else: 
			right_foot.global_position.x = lerp(right_foot.global_position.x, lowest_yarn.global_position.x, delta * 3)
			
			var d = right_foot.global_position.distance_to(lowest_yarn.global_position)
			if d < 50 and !right_kicked:
				right_kicked = true  
				points += 1
				right_foot.global_position.y -= 15
				lowest_yarn.linear_velocity.y = 5
				lowest_yarn.apply_central_impulse((Vector2.UP * 100) + (Vector2.RIGHT * randf_range(-100, 100)))
				hit_player.play()
			elif d > 50: 
				right_kicked = false



	$PointsLabel.text = str(points)
func apply_force(paw, yarn): 

	var dir = (yarn.global_position - paw.global_position).normalized()
	var rot_dir = Vector2.ZERO.direction_to(get_global_mouse_position())
	
	yarn.apply_central_force(dir * 5000)
	yarn.apply_torque_impulse(1000)
	yarn.hit()

func hit_check(): 
	for yarn in yarn_list: 
		var left_dist = left_paw.global_position.distance_to(yarn.global_position)
		var right_dist = right_paw.global_position.distance_to(yarn.global_position)
			
		if left_dist < 100: 
			apply_force(left_paw, yarn)
			hit_player.play()
			points += 1
		if right_dist < 100: 
			apply_force(right_paw, yarn)
			hit_player.play()
			points += 1 
		

func auto_hit():  
	var rand = Vector2(randf_range(-10, 10) , 20)
	for yarn in yarn_list: 
		if yarn.global_position.x < get_viewport_rect().size.x / 2: 
				left_paw.global_position = yarn.global_position + rand
				left_paw.look_at(yarn.global_position.normalized()) 
		else: 
			right_paw.global_position = yarn.global_position + rand
			right_paw.look_at(yarn.global_position.normalized()) 
			right_paw.rotation_degrees = -right_paw.rotation_degrees
	
	hit_check()
	
func _on_timer_timeout():
	auto_hit()

func is_ball_left() -> bool: 
	if is_instance_valid(lowest_yarn): 
		return lowest_yarn.global_position.x < get_viewport_rect().size.x / 2
	else: 
		return false




func _on_texture_button_pressed():
	get_tree().reload_current_scene()
