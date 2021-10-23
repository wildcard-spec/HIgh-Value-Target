tool
extends Spatial
export(NodePath) var skeleton_path setget _set_skeleton_path
onready var skeleton_to_use: Skeleton = get_parent().get_node("player_model/Armature/Skeleton")
onready var skeleton = get_parent().get_node("player_model/Armature/Skeleton")
export(int, "_process", "_physics_process", "_notification", "none") var update_mode = 0 setget _set_update
export(int, "X-up", "Y-up", "Z-up") var look_at_axis = 1
export(float, 0.0, 1.0, 0.001) var interpolation = 1
export(Vector3) var additional_rotation_left = Vector3()
export(Vector3) var additional_rotation_right = Vector3()
export(bool) var debug_messages = false
var lefthand = "upper_arm_l"
var righthand = "upper_arm_r"
var leftHandArray = []
var rightHandArray = []
var akimboArray = []
onready var Player = get_parent()
onready var leftHandle = Player.get_node("player_model/leftHandle")
onready var rightHandle = Player.get_node("player_model/rightHandle")
onready var targetLeft = leftHandle
onready var targetRight = rightHandle
var in_combat = false
var boneLeft: int
var restLeft
var target_pos_left
var rest_euler_left
var self_euler_left
var boneRight: int
var restRight
var target_pos_right
var rest_euler_right
var self_euler_right
var default_left
var default_right
var first_call: bool = true
var second_call = false

func _ready():
	set_process(false)
	set_physics_process(false)
	set_notify_transform(false)
	default_right = skeleton_to_use.get_bone_global_pose(skeleton_to_use.find_bone(righthand))
	default_left = skeleton_to_use.get_bone_global_pose(skeleton_to_use.find_bone(lefthand))
	if update_mode == 0:
		set_process(true)
	elif update_mode == 1:
		set_physics_process(true)
	elif update_mode == 2:
		set_notify_transform(true)
	else:
		if debug_messages:
			print(name, " - IK_LookAt: Unknown update mode. NOT updating skeleton")




func _process(_delta):
	
	change_aim()
	update_skeleton()

func _physics_process(_delta):
	if(!in_combat):
		clear()
	else:
		change_aim()
		update_skeleton()
		if(Input.is_action_just_pressed("debug")):
			print(targetLeft)
			print(targetRight)
			print(leftHandArray)
			print(rightHandArray)
	
func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		update_skeleton()


func update_skeleton():
	
#	if(targetLeft!=null):
	update_left()
#	else:
#		skeleton_to_use.set_bone_global_pose_override(boneLeft, default_left, 1)

	
	update_right()
	
	
	# If we do not have a skeleton and/or we're not supposed to update, then return.
	if skeleton_to_use == null:
		return
	if update_mode >= 3:
		return


func _set_update(new_value):
	update_mode = new_value

	# Set all of our processes to false.
	set_process(false)
	set_physics_process(false)
	set_notify_transform(false)

	# Based on the value of passed to update, enable the correct process.
	if update_mode == 0:
		set_process(true)
		if debug_messages:
			print(name, " - IK_LookAt: updating skeleton using _process...")
	elif update_mode == 1:
		set_physics_process(true)
		if debug_messages:
			print(name, " - IK_LookAt: updating skeleton using _physics_process...")
	elif update_mode == 2:
		set_notify_transform(true)
		if debug_messages:
			print(name, " - IK_LookAt: updating skeleton using _notification...")
	else:
		if debug_messages:
			print(name, " - IK_LookAt: NOT updating skeleton due to unknown update method...")




func _on_Left_Hand_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		leftHandArray.append(body)
		leftHandArray.sort_custom(self,"distance_sort")
		in_combat = true

func _on_Akimbo_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		akimboArray.append(body)
		akimboArray.sort_custom(self,"distance_sort")
		in_combat = true

func _on_Right_Hand_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		rightHandArray.append(body)
		rightHandArray.sort_custom(self,"distance_sort")
		in_combat = true

func _on_Left_Hand_Area_body_exited(body):
	if body.is_in_group("Enemy"):
		leftHandArray.erase(body)
		if(leftHandArray.empty()):
			in_combat = combat_check()
		

func _on_Right_Hand_Area_body_exited(body):
	if body.is_in_group("Enemy"):
		rightHandArray.erase(body)
		if(rightHandArray.empty()):
			in_combat = combat_check()


func _on_Akimbo_Area_body_exited(body):
	if body.is_in_group("Enemy"):
		akimboArray.erase(body)
		if(akimboArray.empty()):
			in_combat = combat_check()


func distance_sort(a,b):
	if a.global_transform.origin.distance_to(Player.global_transform.origin)<b.global_transform.origin.distance_to(Player.global_transform.origin):
		return true
	return false

func change_aim() -> void:
	if(!combat_check()):
		targetLeft = leftHandle
		targetRight = rightHandle
		in_combat = false
		return
	if(!leftHandArray.empty()):
		
		targetLeft = leftHandArray[0]
	else:
		targetLeft = leftHandle
	if(!rightHandArray.empty()):
		targetRight = rightHandArray[0]
	else:
		targetRight = rightHandle
	if(!akimboArray.empty()):
		targetLeft = akimboArray[0]
		targetRight = akimboArray[0]

func update_left() ->void:
	if(skeleton_to_use!=null):
		boneLeft = skeleton_to_use.find_bone(lefthand)
		restLeft = skeleton_to_use.get_bone_global_pose(boneLeft)
		if(targetLeft.is_in_group("Enemy")):
			target_pos_left = skeleton_to_use.global_transform.xform_inv(targetLeft.global_transform.origin+Vector3(0,1.5,0))
		else:
			target_pos_left = skeleton_to_use.global_transform.xform_inv(targetLeft.global_transform.origin)
		restLeft = restLeft.looking_at(target_pos_left, Vector3.UP)
		rest_euler_left = restLeft.basis.get_euler()
		self_euler_left = targetLeft.global_transform.basis.orthonormalized().get_euler()
		restLeft.basis = Basis(rest_euler_left)
		if additional_rotation_left != Vector3.ZERO:
			restLeft.basis = restLeft.basis.rotated(restLeft.basis.x, deg2rad(additional_rotation_left.x))
			restLeft.basis = restLeft.basis.rotated(restLeft.basis.y, deg2rad(additional_rotation_left.y))
			restLeft.basis = restLeft.basis.rotated(restLeft.basis.z, deg2rad(additional_rotation_left.z))
		skeleton_to_use.set_bone_global_pose_override(boneLeft, restLeft, interpolation, true)
			
	if(Input.is_action_just_pressed("debug")):
		print("lefthandArray = " + str(leftHandArray))
		print("rightHandArray = " + str(rightHandArray))
		print("akimboArray = " + str(akimboArray))
	

func update_right() ->void:
	if(skeleton_to_use!=null):
		boneRight = skeleton_to_use.find_bone(righthand)
		restRight = skeleton_to_use.get_bone_global_pose(boneRight)
		if(targetRight.is_in_group("Enemy")):
			target_pos_right = skeleton_to_use.global_transform.xform_inv(targetRight.global_transform.origin+Vector3(0,1.5,0))
		else:
			target_pos_right = skeleton_to_use.global_transform.xform_inv(targetRight.global_transform.origin)
		restRight = restRight.looking_at(target_pos_right, Vector3.UP)
		rest_euler_right = restRight.basis.get_euler()
		self_euler_right = targetRight.global_transform.basis.orthonormalized().get_euler()
		restRight.basis = Basis(rest_euler_right)
		if additional_rotation_right != Vector3.ZERO:
			restRight.basis = restRight.basis.rotated(restRight.basis.x, deg2rad(additional_rotation_right.x))
			restRight.basis = restRight.basis.rotated(restRight.basis.y, deg2rad(additional_rotation_right.y))
			restRight.basis = restRight.basis.rotated(restRight.basis.z, deg2rad(additional_rotation_right.z))
		skeleton_to_use.set_bone_global_pose_override(boneRight, restRight, interpolation, true)
	
	if(Input.is_action_just_pressed("debug")):
			print(target_pos_right)
			print(Player.global_transform.origin)

func combat_check():
	if(!akimboArray.empty() or !leftHandArray.empty() or !rightHandArray.empty()):
		return true
	else:
		return false

func _set_skeleton_path(new_value):
	# Because get_node doesn't work in the first call, we just want to assign instead.
	# This is to get around a issue with NodePaths exposed to the editor.
	if first_call:
		skeleton_path = new_value
		return

	# Assign skeleton_path to whatever value is passed.
	skeleton_path = new_value

	if skeleton_path == null:
		if debug_messages:
			print(name, " - IK_LookAt: No Nodepath selected for skeleton_path!")
		return

	# Get the node at that location, if there is one.
	var temp = get_node(skeleton_path)
	if temp != null:
		if temp is Skeleton:
			skeleton_to_use = temp
			if debug_messages:
				print(name, " - IK_LookAt: attached to (new) skeleton")
		else:
			skeleton_to_use = null
			if debug_messages:
				print(name, " - IK_LookAt: skeleton_path does not point to a skeleton!")
	else:
		if debug_messages:
			print(name, " - IK_LookAt: No Nodepath selected for skeleton_path!")

func clear():
	if(skeleton_to_use!=null):
		skeleton_to_use.clear_bones_global_pose_override()





