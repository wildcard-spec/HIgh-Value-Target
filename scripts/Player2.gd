extends KinematicBody
class_name PlayerKinematicBody, "res://icons/KinematicBodyPlayer.svg"

export var max_speed = 12
export var dodge_speed = 55
export var gravity = 70
export var jump_impulse = 15


onready var anim = get_node("player_model_root/player_model/AnimationPlayer")
onready var IK = get_node("IK_Control")
onready var camera = get_node("Pivot/Camera")
onready var model = get_node("player_model_root")
onready var laser = preload("res://resources/Laser_projectile.tscn")
onready var muzzleRight = get_node("player_model_root/player_model/Armature/Skeleton/hand_right/gunRight/muzzleRight")
onready var muzzleLeft = get_node("player_model_root/player_model/Armature/Skeleton/hand_left/gunLeft/muzzleLeft")
onready var pivotPoint = get_node("Pivot")
onready var laserSound = get_node("laserSound")
onready var tween = get_node("Jump")
onready var smokeParticles = get_node("player_model_root/Smoke_Particles/Particles")
onready var fireParticlesL = get_node("player_model_root/Particles/Particles")
onready var fireParticlesR =  get_node("player_model_root/Particles2/Particles")


var in_combat
var targetLeft
var targetRight
var targetLeftHealth
var targetRightHealth
var is_moving = false
var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var runAim = "Run-Aim"
var run = "Run"
var defaultPose = "Aim_Pose"
var rayOrigin
var rayEnd
var is_hovering = false
var health = 100
var is_sliding = false
var viewRotation

func _ready():
	smokeParticles.get_child(0).emitting = false
	fireParticlesL.emitting = false
	fireParticlesR.emitting = false

func _physics_process(delta):
	viewRotation = pivotPoint.rotation_degrees+camera.rotation_degrees
	in_combat = IK.in_combat
	targetLeft = IK.get("targetLeft")
	targetRight = IK.get("targetRight")
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
		print(in_combat)
	
	if(!is_on_floor()):
		fireParticlesL.emitting = true
		fireParticlesR.emitting = true
	else:
		fireParticlesL.emitting = false
		fireParticlesR.emitting = false
	
	#get direction
	if(movementPressed()):
			direction.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
			direction.z = Input.get_action_strength("move_backwards")-Input.get_action_strength("move_forwards")
			direction = direction.rotated(Vector3.UP, deg2rad(viewRotation[1]))
			direction = direction.normalized()
			is_moving = true
#			if not intersection.empty():
#				direction = global_transform.origin.direction_to(intersection.position)
#				direction.y = 0
	else:
		is_moving = false
		direction = Vector3.ZERO
	#apply that to velocity
	if(is_moving):
		velocity = lerp(velocity, direction * max_speed, delta * 6)
#		velocity = lerp(velocity, direction * max_speed, delta * 6)
	else:
		velocity.x = lerp(velocity.x, 0, delta * 25)
		velocity.z = lerp(velocity.z, 0, delta * 25)
	if(is_moving and in_combat):
			play_anim(runAim)
	elif(is_moving):
		play_anim(run)
	else:
		play_anim(defaultPose)
	#add gravity
	velocity.y -= gravity * delta
	
	if(Input.is_action_just_pressed("dodge")):
		velocity.x = lerp(velocity.x, direction.x * 2 * dodge_speed, delta * 10)
		velocity.z = lerp(velocity.z, direction.z * 2 * dodge_speed, delta * 10)

	
	if(is_on_floor() and Input.is_action_just_pressed("jump")):
		tween.interpolate_property(self, "translation:y",self.translation[1],self.translation[1]+jump_impulse, 1, Tween.TRANS_QUART,Tween.EASE_OUT)
		tween.start()
		smokeParticles.get_child(0).emitting = true
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
				l.passParameters(targetLeft)
				muzzleLeft.add_child(l)
				l.look_at(targetLeft.global_transform.origin+Vector3(0,2,0),Vector3.UP)
				l.shoot = true
				laserSound.play()
		else:
			pass
	if(Input.is_action_just_pressed("fire_secondary")):
		if(targetRight!=null):
			if(targetRight.is_in_group("Enemy")):
				var la = laser.instance()
				muzzleRight.add_child(la)
				la.look_at(targetRight.global_transform.origin+Vector3(0,2,0),Vector3.UP)
				la.shoot = true
				laserSound.play()
		else:
			pass

	if(health==0):
		print("game over")
	if(Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene()
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene("res://MainMenu.tscn")

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



	
	



func _on_Jump_tween_completed(object, key):
	smokeParticles.get_child(0).emitting = false
