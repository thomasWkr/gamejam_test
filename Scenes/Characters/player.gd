extends CharacterBody2D

@export var is_carrying_key = false
const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var floor_vector = %Floor

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if floor_vector.is_colliding():
			var obj = floor_vector.get_collider()
			if not(obj.name.contains("Square") and obj.size == 1):
				velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
