extends RigidBody2D

var ta_colidindo = false
var ta_pego = false
@onready var collisionbody = %ColisãoBody
@onready var collisioncheck = %ColisãoCheck
@onready var sprite = %Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if ta_colidindo == true:
		if Input.is_action_just_pressed("Muda Tamanho +") == true:
			sprite.scale *= Vector2(2,2)
			collisionbody.scale *= Vector2(2,2)
			collisioncheck.scale *= Vector2(2,2)
		if Input.is_action_just_pressed("Muda Tamanho -") == true:
			sprite.scale *= Vector2(0.5,0.5)
			collisionbody.scale *= Vector2(0.5,0.5)
			collisioncheck.scale *= Vector2(0.5,0.5)
		if Input.is_action_just_pressed("Pega") == true:
			pass
	
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	ta_colidindo = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	ta_colidindo = false
