extends RigidBody2D

var is_colliding = false
var is_carried = false
@export var is_door = false
@export var is_key = false
@export var is_mushroom = false
@export var is_carriable = true
@export var size = 1
@export var scale_x = 1
@export var scale_y = 1

var level = ""
var pc = ""
var last_direction = "left"

const this: PackedScene = preload("res://Scenes/Objects/square.tscn")
@onready var collision_body = %CollisionBox
@onready var collision_check = %DetectionBox
@onready var sprite = %Sprite2D
@onready var normal_vector: RayCast2D = $Normal
var pc_normal

const CHECK_EXTRA_WIDTH = 0.2
const POSITION_OFFSET_1 = 75
const POSITION_OFFSET_2 = 20

func _ready() -> void:
	sprite.scale *= Vector2(size,size) * Vector2(scale_x,scale_y)
	collision_body.scale *= Vector2(size,size) * Vector2(scale_x,scale_y)
	collision_check.scale *= Vector2(size,size) * Vector2(scale_x,scale_y)
	normal_vector.scale *= Vector2(size,size) * Vector2(scale_x,scale_y)
	normal_vector.global_position.y = collision_body.global_position.y - ((collision_body.shape.extents.y * size) / 2)
	level = get_parent()
	pc = level.get_child(0)
	pc_normal = pc.get_child(3)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		last_direction = "left"
		
	if Input.is_action_just_pressed("Right"):
		last_direction = "right"
		
	if is_carried:
		if Input.is_action_just_pressed("Carry"):
			drop()
		else:
			carry()
		
	elif is_colliding and not(normal_vector.is_colliding()) and pc.is_on_floor():
		if Input.is_action_just_pressed("Grow"):
			grow()
			
		if Input.is_action_just_pressed("Shrink") and size > 1:
			shrink()
			
		if Input.is_action_just_pressed("Carry") and (size == 1) and (level.entropy == 0) and (not(pc_normal.is_colliding())):
			start_carrying()
			
func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "Boneco"):
		if(body.is_carrying_key and is_door and size == 2):
			print("cu")
		is_colliding = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.name == "Boneco"):
		is_colliding = false
	
func grow():
	size += 1
	var scaler = float(size) / (float(size) - 1.0) 
	sprite.scale *= Vector2(scaler,scaler)
	collision_body.scale *= Vector2(scaler,scaler)
	collision_check.scale = Vector2(collision_body.scale.x + CHECK_EXTRA_WIDTH,collision_body.scale.x)
	normal_vector.scale *= Vector2(scaler,scaler)
	level.entropy += 1
	normal_vector.global_position.y = collision_body.global_position.y - ((collision_body.shape.extents.y * size) / 2)
	
func shrink():
	var scaler = float(size) / (float(size) - 1.0) 
	sprite.scale /= Vector2(scaler,scaler)
	collision_body.scale /= Vector2(scaler,scaler)
	collision_check.scale = Vector2(collision_body.scale.x + CHECK_EXTRA_WIDTH,collision_body.scale.x)
	normal_vector.scale /= Vector2(scaler,scaler)
	size -= 1
	level.entropy -= 1
	normal_vector.global_position.y = collision_body.global_position.y - ((collision_body.shape.extents.y * size) / 2)
	
func start_carrying():
	if(is_key):
		pc.is_carrying_key = true
	is_carried = true
	is_colliding = false
	collision_body.disabled = true
	
func carry():
	var new_position = Vector2(pc.global_position.x, pc.global_position.y - POSITION_OFFSET_1)
	sprite.global_position = new_position
	collision_body.global_position = new_position
	collision_check.global_position = new_position
	normal_vector.global_position = new_position
	normal_vector.global_position.y = collision_body.global_position.y - ((collision_body.shape.extents.y * size) / 2)
	
func drop():
	var new_position
	if (last_direction == "left"):
		new_position = Vector2(pc.global_position.x - POSITION_OFFSET_1, pc.global_position.y - POSITION_OFFSET_2)
	else:
		new_position = Vector2(pc.global_position.x + POSITION_OFFSET_1, pc.global_position.y - POSITION_OFFSET_2)
	sprite.global_position = new_position
	collision_body.global_position = new_position
	collision_check.global_position = new_position
	normal_vector.global_position = new_position
	normal_vector.global_position.y = collision_body.global_position.y - ((collision_body.shape.extents.y * size) / 2)
	is_carried=false
	collision_body.disabled = false
	is_colliding=true
