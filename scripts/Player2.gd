extends KinematicBody
class_name PlayerKinematicBody, "res://icons/KinematicBodyPlayer.svg"

export var max_speed = 12
export var dodge_speed = 55
export var gravity = 70
export var jump_impulse = 100
export var surf_speed = 25

onready var playerGraphics = get_node("player_model")

onready var anim = get_node("player_model/AnimationPlayer")
onready var IK = get_node("IK_Control")
onready var camera = $Pivot/Camera
onready var model = $player_model
onready var laser = preload("res://resources/Laser_projectile.tscn")
onready var muzzleRight = get_node("player_model/Armature/Skeleton/hand_right/gunRight/muzzleRight")
onready var muzzleLeft = get_node("player_model/Armature/Skeleton/hand_left/gunLeft/muzzleLeft")
onready var surf_wave = get_node("player_model/Sufr_wave")
onready var pivotPoint = get_node("Pivot")

var in_combat
var targetLeft
var targetRight
var targetLeftHealth
var targetRightHealth
var is_moving = false
var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var lastRot
var runAim = "Run-Aim"
var run = "Run"
var surf = "Surf"
var rayOrigin
var rayEnd
var is_hovering = false
var health = 100
var is_sliding = false
var viewRotation


func _physics_process(delta):
	viewRotation = pivotPoint.rotation_degrees+camera.rotation_degrees
	in_combat = IK.in_combat
	targetLeft = IK.get("targetLeft")
	targetRight = IK.get("targetRight")
	if(targetLeft!=null):
		if(targetLeft.is_in_group("Enemy")):
			targetLeftHealth = targetLeft.get("health")
	if(targetRight!=null):
		if(targetRight.is_in_group("Enemy") and targetLeft!=null):
			targetRightHealth = targetRight.health
	#raycasting setup to get the mouse position
	var space_state = get_world().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos)*2000
	var intersection = space_state.intersect_ray(rayOrigin,rayEnd, [self])
	#rotation to mouse position
	if not intersection.empty():
		var pos = intersection.position
		model.look_at(Vector3(pos.x,translation.y,pos.z),Vector3.UP)
	
	if(Input.is_action_just_pressed("debug")):
		print("gay")
	
	#get direction
	if(movementPressed()):
		if(!is_sliding):
			direction.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
			direction.z = Input.get_action_strength("move_backwards")-Input.get_action_strength("move_forwards")
			direction = direction.rotated(Vector3.UP, deg2rad(viewRotation[1]))
			direction = direction.normalized()
		else:
			if not intersection.empty():
				direction = global_transform.origin.direction_to(intersection.position)
				direction.y = 0
	if direction != Vector3.ZERO:
		is_moving = true
	#apply that to velocity
	if(movementPressed()):
		if(!is_sliding):
			velocity = lerp(velocity, direction * max_speed, delta * 6)
		else:
			velocity = lerp(velocity, direction * surf_speed, delta * 6)
	lastRot = playerGraphics.rotation.y
	if(is_moving and in_combat):
		if(is_sliding):
			play_anim(surf)
		else:	
			play_anim(runAim)
	elif(is_moving and !is_sliding):
		play_anim(run)
	#add gravity
	velocity.y -= gravity * delta
	
	if(Input.is_action_just_pressed("dodge")):
		if(!is_sliding):
#			velocity = direction*dodge_speed
			is_sliding = true
			play_anim(surf)
			surf_wave.set_emitting(true)
		else:
			play_anim(run)
			is_sliding = false
			surf_wave.set_emitting(false)
			
	
	if(is_on_floor() and Input.is_action_just_pressed("jump")):
#		velocity.y = jump_impulse
		pass
	velocity = move_and_slide(velocity,Vector3.UP)
	if(!is_on_floor()):
		play_anim("Aim_Pose")
	if(!is_on_floor() and Input.is_action_just_pressed("jump")):
		if(is_hovering == false):
			gravity = 0
			is_hovering = true
		else:
			gravity = 70
			is_hovering = false
			
	if(Input.is_action_just_pressed("fire")):
		if(targetLeft!=null):
			if(targetLeft.is_in_group("Enemy")):
				var l = laser.instance()
				muzzleLeft.add_child(l)
				l.look_at(targetLeft.global_transform.origin+Vector3(0,1.5,0),Vector3.UP)
				l.shoot = true
	if(Input.is_action_just_pressed("fire_secondary")):
		if(targetRight!=null):
			if(targetRight.is_in_group("Enemy")):
				var la = laser.instance()
				muzzleRight.add_child(la)
				la.look_at(targetRight.global_transform.origin+Vector3(0,1.5,0),Vector3.UP)
				la.shoot = true

	if(health==0):
		print("game over")


func play_anim(name):
#	var anim_name = name.resource_path.get_file().trim_suffix('.tres')
	if anim.current_animation == name:
		return
	anim.play(name)
#	print(name)

func movementPressed():
	if(Input.is_action_pressed("move_backwards") || Input.is_action_pressed("move_forwards") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")):
		return true
	else:
		return false




func _on_proximityArea_body_entered(body):
	if(body.is_in_group("Enemy") and body.is_in_group("MeleeEnemy")):
		health-=25




	
	

