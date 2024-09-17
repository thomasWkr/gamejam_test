extends RigidBody2D

var is_colliding = false
var is_carried = false

var size = 2
var parent = ""
var pc = ""
var last_direction = "left"

const this: PackedScene = preload("res://Scenes/Objects/square.tscn")
@onready var collision_body = %CollisionBox
@onready var collision_check = %DetectionBox
@onready var sprite = %Sprite2D

const CHECK_EXTRA_WIDTH = 0.2

func _ready() -> void:
	parent = get_parent()
	pc = parent.get_child(0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		last_direction = "left"
		
	if Input.is_action_just_pressed("Right"):
		last_direction = "right"
		
	if is_carried:
		if Input.is_action_just_pressed("Carry"):
			var new_position
			if (last_direction == "left"):
				new_position = Vector2(pc.global_position.x-55, pc.global_position.y - 20)
			else:
				new_position = Vector2(pc.global_position.x+55, pc.global_position.y - 20)
			sprite.global_position = new_position
			collision_body.global_position = new_position
			collision_check.global_position = new_position
			is_carried=false
			collision_body.disabled = false
			is_colliding=true
		else:
			var new_position = Vector2(pc.global_position.x, pc.global_position.y - 50)
			sprite.global_position = new_position
			collision_body.global_position = new_position
			collision_check.global_position = new_position
		
	elif is_colliding:
		if Input.is_action_just_pressed("Grow"):
			sprite.scale *= Vector2(2,2)
			collision_body.scale *= Vector2(2,2)
			collision_check.scale = Vector2(collision_body.scale.x + CHECK_EXTRA_WIDTH,collision_body.scale.x)
			size+=1
			
		if Input.is_action_just_pressed("Shrink"):
			sprite.scale *= Vector2(0.5,0.5)
			collision_body.scale *= Vector2(0.5,0.5)
			collision_check.scale = Vector2(collision_body.scale.x + CHECK_EXTRA_WIDTH,collision_body.scale.x)
			size-=1
			
		if Input.is_action_just_pressed("Carry") and size==1:
			is_carried = true
			is_colliding = false
			collision_body.disabled = true
			
func _on_area_2d_body_entered(body: Node2D) -> void:
	is_colliding = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_colliding = false
