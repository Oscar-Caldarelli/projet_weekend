extends Node2D
@onready var ray_cast_right: RayCast2D = $CharacterBody2D/RayCastRight
@onready var ray_cast_left: RayCast2D = $CharacterBody2D/RayCastLeft
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var dash_timer: Timer = $CharacterBody2D/dashTimer
@onready var can_dash_timer: Timer = $CharacterBody2D/canDashTimer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY_Y = -300.0
const WALL_JUMP_VELOCITY_X = 1900.0
const DASH_SPEED = 900.0
var dashing = false
var canDash = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not character_body_2d.is_on_floor():
		character_body_2d.velocity += character_body_2d.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (character_body_2d.is_on_floor() or character_body_2d.is_on_wall_only()):
		if character_body_2d.is_on_wall_only():
			print(ray_cast_right.is_colliding())
			print(ray_cast_left.is_colliding())
			if ray_cast_right.is_colliding(): 
				character_body_2d.velocity.y = WALL_JUMP_VELOCITY_Y
				character_body_2d.velocity.x = WALL_JUMP_VELOCITY_X * -1
			elif ray_cast_left.is_colliding() :
				character_body_2d.velocity.y = WALL_JUMP_VELOCITY_Y
				character_body_2d.velocity.x = WALL_JUMP_VELOCITY_X 
		else : 
			character_body_2d.velocity.y = JUMP_VELOCITY
			
	if Input.is_action_just_pressed("dash") and canDash :
		dashing = true
		canDash = false
		dash_timer.start()
		can_dash_timer.start()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if dashing:
			character_body_2d.velocity.x = direction * DASH_SPEED
		else:
			if character_body_2d.is_on_floor():
				character_body_2d.velocity.x = direction * SPEED
			else:
				character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, direction * SPEED, SPEED * 0.1)
	else:
		character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, SPEED)
		
	character_body_2d.move_and_slide()



func _on_dash_timer_timeout() -> void:
	dashing = false
	

func _on_can_dash_timer_timeout() -> void:
	canDash = true
	
