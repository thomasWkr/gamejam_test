extends RigidBody2D

var is_colliding = false
var is_carried = false

const this: PackedScene = preload("res://Scenes/Objects/square.tscn")
@onready var collision_body = %CollisionBox
@onready var collision_check = %DetectionBox
@onready var sprite = %Sprite2D

const CHECK_EXTRA_WIDTH = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_colliding:
		if Input.is_action_just_pressed("Grow"):
			sprite.scale *= Vector2(2,2)
			collision_body.scale *= Vector2(2,2)
			collision_check.scale = Vector2(collision_body.scale.x + CHECK_EXTRA_WIDTH,collision_body.scale.x)
			
		if Input.is_action_just_pressed("Shrink"):
			sprite.scale *= Vector2(0.5,0.5)
			collision_body.scale *= Vector2(0.5,0.5)
			collision_check.scale = Vector2(collision_body.scale.x + CHECK_EXTRA_WIDTH,collision_body.scale.x)
			
		if Input.is_action_just_pressed("Carry"):
			pass

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_colliding = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_colliding = false
