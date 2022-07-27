extends KinematicBody2D

#coyotetime is set to only play once aka one shot and is set to 0.1 secounds 
onready var coyote_timer = $CoyoteTimer
var speed = 200
var gravity = 30
var ground_acc = 20
var friction = 0.2

#--------------------------------------------# Jump Varible 
var jump_speed = -600
var jump_count = 0
export var extra_jumps = 1
#--------------------------------------------# 

var vel : Vector2 = Vector2() 

func _physics_process(delta):
	
	vel.y += gravity 
	
	if Input.is_action_pressed("right"):
		vel.x = min(vel.x + ground_acc,speed)
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("left"):
		vel.x = max(vel.x - ground_acc,-speed)
		$AnimatedSprite.flip_h = true 
		$AnimatedSprite.play("run")
	else :
		vel.x = lerp(vel.x,0, friction)
		$AnimatedSprite.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		
		if jump_count < extra_jumps:
			vel.y = jump_speed
			jump_count += 1
		if  !coyote_timer.is_stopped():
			vel.y = jump_speed
			jump_count = 0
	
	var was_on_floor = is_on_floor()
	
	
	if was_on_floor == true :
		jump_count = 0
	
	if !is_on_floor():
		if vel.y > 0:
			$AnimatedSprite.play("falling")
		else :
			$AnimatedSprite.play("jump")
	
	
	vel = move_and_slide(vel, Vector2.UP)
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()

