extends Spatial
class_name Customizer, "res://icons/customizer_icon.svg"

onready var HelmetAndVest = get_node("MarginContainer/PanelContainer/VBoxContainer/Helmet&Vest/HVColorPickerButton")
onready var PlatingAndArmor = get_node("MarginContainer/PanelContainer/VBoxContainer/Plating and armor/PAColorPickerButton")
onready var Shirt = get_node("MarginContainer/PanelContainer/VBoxContainer/Shirt/ShirtColorPickerButton")
onready var animplayer = get_node("player_model_root/player_model/AnimationPlayer")
onready var playerModel = get_node("player_model_root")
onready var animations = animplayer.get_animation_list()
onready var scooter = get_node("player_model_root/Scooter")
onready var camera = get_node("Camera")
onready var cameraAnim = get_node("CameraPlayer")

onready var hvMaterial = preload("res://materials/Turquoise Material.material")
onready var paMaterial = preload("res://materials/Plate Metal.material")
onready var shirtMaterial = preload("res://materials/Shirt_material.material")
onready var shirtDefaultMaterial = preload("res://materials/Default_shirt.material")
onready var defaultHVMaterial = preload("res://materials/Default Helmet and Vest.material")
onready var defaultPAMaterial = preload("res://materials/Default Plate Metal.material")

var isClicked = false
var mousePos1
var mousePos2
var isColorPickerOpen = false

var first_call = true
var aboutToMount = false
var animTime = 0

var token:int = 0
var current_animation

func _input(event):
#	print(event)
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			isClicked = true
			mousePos1 = get_viewport().get_mouse_position()
			print("clicked")
#			print(mousePos1)
		elif event.button_index == 1 and not event.is_pressed():
			isClicked = false
			mousePos2 = get_viewport().get_mouse_position()
			print("released")
#			print(mousePos2)
#			print(mousePos2-mousePos1)
	if event is InputEventMouseMotion and isClicked and !isColorPickerOpen:
		playerModel.rotate_y(event.relative.x/100)
#		print(event.relative)


func _process(delta):
	if(first_call):
		HelmetAndVest.color = hvMaterial.albedo_color
		PlatingAndArmor.color = paMaterial.albedo_color
		Shirt.color = shirtMaterial.albedo_color
		animplayer.play(animations[token])
		first_call = false
		current_animation = animations[token]
	hvMaterial.albedo_color = HelmetAndVest.color
	paMaterial.albedo_color = PlatingAndArmor.color
	shirtMaterial.albedo_color = Shirt.color
	


func _on_Shirt_Save_pressed():
	shirtMaterial.set_albedo(shirtMaterial.albedo_color)
	ResourceSaver.save("res://materials/Shirt_material.material",shirtMaterial)


func _on_Shirt_Default_pressed():
	Shirt.color = shirtDefaultMaterial.albedo_color
	shirtMaterial.albedo_color = shirtDefaultMaterial.albedo_color
	ResourceSaver.save("res://materials/Shirt_material.material",shirtMaterial)


func _on_CyclePosesButton_pressed():
	
	token += 1
	if token==animations.size():
		token = 0
	animplayer.play(animations[token])
	current_animation = animations[token]
	if(current_animation == "Action"):
		scooter.visible = true
	else:
		scooter.visible = false
	animplayer.advance(0.1)
	animplayer.stop(false)
	if current_animation == "Action" and aboutToMount:
		cameraAnim.play("zoomOut")
		aboutToMount = false
	elif current_animation!= "Action" and !aboutToMount:
		cameraAnim.play_backwards("zoomOut")
		aboutToMount = true

func _on_HV_Save_pressed():
	
	ResourceSaver.save("res://materials/Turquoise Material.material",hvMaterial)

func _on_HV_Default_pressed():
	HelmetAndVest.color = defaultHVMaterial.albedo_color
	hvMaterial.albedo_color = defaultHVMaterial.albedo_color
	ResourceSaver.save("res://materials/Turquoise Material.material",hvMaterial)


func _on_PA_Save_pressed():
	ResourceSaver.save("res://materials/Plate Metal.material",paMaterial)


func _on_PA_Default_pressed():
	PlatingAndArmor.color = defaultPAMaterial.albedo_color
	paMaterial.albedo_color = defaultPAMaterial.albedo_color
	ResourceSaver.save("res://materials/Plate Metal.material",paMaterial)


func _on_PA_Cancel_pressed():
	pass # Replace with function body.


func _on_Back_to_menu_button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")


func _on_HVColorPickerButton_pressed():
	isColorPickerOpen = true


func _on_HVColorPickerButton_popup_closed():
	isColorPickerOpen = false


func _on_PAColorPickerButton_pressed():
	isColorPickerOpen = true


func _on_PAColorPickerButton_popup_closed():
	isColorPickerOpen = false


func _on_ShirtColorPickerButton_pressed():
	isColorPickerOpen = true


func _on_ShirtColorPickerButton_popup_closed():
	isColorPickerOpen = false


