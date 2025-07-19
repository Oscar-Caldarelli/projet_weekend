extends CharacterBody2D
@onready var ray_cast_right: RayCast2D = $CharacterBody2D/RayCastRight
@onready var ray_cast_left: RayCast2D = $CharacterBody2D/RayCastLeft


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WALL_JUMP_VELOCITY_Y = -300.0
const WALL_JUMP_VELOCITY_X = -200.0
const DASH_SPEED = 900.0
var dashing = false
var canDash = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_wall_only()):
		if is_on_wall_only():
			print(ray_cast_right)
			print(ray_cast_left)
			if ray_cast_right.is_colliding(): 
				velocity.y = WALL_JUMP_VELOCITY_Y
				velocity.x = WALL_JUMP_VELOCITY_X * -1
			elif ray_cast_left.is_colliding() :
				velocity.y = WALL_JUMP_VELOCITY_Y
				velocity.x = WALL_JUMP_VELOCITY_X 
		else : 
			velocity.y = JUMP_VELOCITY
			
	if Input.is_action_just_pressed("dash") and canDash :
		dashing = true
		canDash = false
		$dashTimer.start()
		$canDashTimer.start()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _on_dash_timer_timeout() -> void:
	dashing = false
	

func _on_can_dash_timer_timeout() -> void:
	canDash = true
	
