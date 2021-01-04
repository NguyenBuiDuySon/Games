extends KinematicBody2D

var Velocity = Vector2()
var Max_speed = 200
var Gravity = 2000
const Slope_stop = 16 # ko bi truoc khi dung o doc
const Up = Vector2(0,-1) # tro choi tu tren xuong  
var Jump_velocity = -480
var Is_grounded 
#var is_jumping = false
#var is_wall_sliding = false
var jump_count = 0
var extraJump = 1

#const Wall_slide_acceleration = 10
#const Max_wall_slide_speed = 120

onready var animationPlayer = $Sprite/AnimationPlayer
onready var Raycasts = $Raycasts

func _physics_process(delta: float) -> void:
	Velocity.y += Gravity * delta 
	movement_loop()
	jump_loop()
	Velocity = move_and_slide(Velocity,Up,Slope_stop)
	Is_grounded =  is_on_floor()  # tren san hay ko 
	_assign_animation()
	
func movement_loop():
	var right_dir = Input.get_action_strength('ui_right')
	var left_dir  = Input.get_action_strength('ui_left')
	
	var move_direction = right_dir - left_dir
	
	Velocity.x = lerp(Velocity.x,Max_speed*move_direction,_get_h_weight())
	# lerp : ham noi suy giup player giam toc dan dan => player chuyen dong muot hon
	if move_direction == 0:# khong de player tu dong di lui
		if(Velocity.x <0 && Velocity.x >-1) || (Velocity.x >0 && Velocity.x<1):
			Velocity.x = 0
	
	
func jump_loop():

	if Input.is_action_just_pressed("ui_up") && jump_count < extraJump:
		Velocity.y = Jump_velocity
		jump_count +=1
#		if Is_grounded && Input.is_action_pressed("ui_right"):
#			Velocity.x = - Max_speed
#		elif Is_grounded && Input.is_action_pressed("ui_left"):
#			Velocity.x = Max_speed
	
	if Is_grounded:
		jump_count = 0
	
#	if Is_grounded && ( Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")):
#		if Velocity.y >= 0:
#			Velocity.y = min(Velocity.y + Wall_slide_acceleration, Max_wall_slide_speed)
#			animationPlayer.play("Wall_slide")
#		else:
#			Velocity.y += Gravity*delta
#	else: 
#		Velocity.y += Gravity*delta

func _get_h_weight(): # dieu chinh do tron cua ham lerp
	return 0.2 if Is_grounded else  0.1

func _check_is_grounded():
	for raycast in Raycasts.get_child():
		if raycast.is_colliding():
			return true

func _assign_animation():

	if !Is_grounded:
		animationPlayer.play('Jump')
		if Velocity.x < 0:
			get_node('Sprite').flip_h = true
		
		elif Velocity.x > 0:
			get_node('Sprite').flip_h = false
	
	if !Is_grounded && jump_count > 0 :
		animationPlayer.play("Double_jump")
		if Velocity.x < 0:
			get_node('Sprite').flip_h = true
		
		elif Velocity.x > 0:
			get_node('Sprite').flip_h = false
	
	elif Velocity.x != 0:
		animationPlayer.play('Run')
		if Velocity.x > 0:
			get_node('Sprite').flip_h = false
			
		else:
			get_node('Sprite').flip_h = true
			
	else:
		animationPlayer.play('Idle')


func _on_Hitbox_body_entered(body):
	pass # Replace with function body.
