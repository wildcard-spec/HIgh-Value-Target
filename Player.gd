extends KinematicBody

var MOVE_SPEED = 10
var WALK_SPEED = 3
var velocity = Vector3()
const ACCELERATION = 5
const DE_ACCELERATION = 5
var gravity = -9.8
const MAX_FALL_SPEED = 30
const JUMP_FORCE = 150
var character
var camera


onready var anim = $player_model/AnimationPlayer
onready var animTree = $AnimationTree
#onready var animNode = animTree.get("parameters/playback")

var y_velo = 0

func _ready():
#	anim.get_animation("Armature|Walk").set_loop(true)
#	anim.get_animation("Armature|Run").set_loop(true)
	character = get_node(".")
	camera = get_node("Camera").get_global_transform()
#	animTree.set("Active", true)

func _physics_process(delta):
	var is_moving = false
	var is_inertia = false
	if (velocity.z != 0 and velocity.x != 0 and is_moving == false):
		is_inertia = true
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec -= camera.basis[2]
		is_moving = true
	if Input.is_action_pressed("move_backwards"):
		move_vec += camera.basis[2]
		is_moving = true
	if Input.is_action_pressed("move_left"):
		move_vec -= camera.basis[0]
		is_moving = true
	if Input.is_action_pressed("move_right"):
		move_vec += camera.basis[0]
		is_moving = true
	
	move_vec = move_vec.normalized()
	
	velocity.y = gravity * delta
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	var new_move = move_vec * MOVE_SPEED
	var accel = DE_ACCELERATION
	
	if (move_vec.dot(horizontal_velocity)>0):
		accel = ACCELERATION
		
	horizontal_velocity = horizontal_velocity.linear_interpolate(new_move, accel * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	#velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	var grounded = is_on_floor()
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("jump"):
		just_jumped = true
		velocity.y = JUMP_FORCE*100
	if grounded and velocity.y <= 0:
		velocity.y = -0.1
	if velocity.y <- MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	var speed = horizontal_velocity.length() / MOVE_SPEED
	print(speed)
	
	
	#animTree["parameters/Run/blend_amount"] = speed
	animTree.set("parameters/Run/blend_amount", speed)
	
	if is_moving:
		var angle = atan2(move_vec.x,move_vec.z)
		var char_rotation = character.get_rotation()
		
		char_rotation.y = angle
		character.set_rotation(char_rotation)




func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)









