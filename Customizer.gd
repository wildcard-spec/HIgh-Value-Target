extends Spatial
class_name Customizer, "res://icons/customizer_icon.svg"

onready var HelmetAndVest = get_node("MarginContainer/PanelContainer/VBoxContainer/Helmet&Vest/ColorPickerButton")
onready var PlatingAndArmor = get_node("MarginContainer/PanelContainer/VBoxContainer/Plating and armor/ColorPickerButton")
onready var Shirt = get_node("MarginContainer/PanelContainer/VBoxContainer/Shirt/ColorPickerButton")
onready var animplayer = get_node("player_model/AnimationPlayer")

onready var hvMaterial = preload("res://materials/Turquoise Material.material")
onready var paMaterial = preload("res://materials/Plate Metal.material")
onready var shirtMaterial = preload("res://materials/Shirt_material.material")
onready var shirtDefaultMaterial = preload("res://materials/Default_shirt.material")
onready var defaultHVMaterial = preload("res://materials/Default Helmet and Vest.material")
onready var defaultPAMaterial = preload("res://materials/Default Plate Metal.material")


var first_call = true

var animations: Array = ["RestPose", "Aim_Pose", "Run-Aim", "Run_2nd_iteration"]
var token:int = 0

func _process(delta):
	if(first_call):
		HelmetAndVest.color = hvMaterial.albedo_color
		PlatingAndArmor.color = paMaterial.albedo_color
		Shirt.color = shirtMaterial.albedo_color
		animplayer.play("RestPose")
		first_call = false
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
	if token==4:
		token = 0
	animplayer.play(animations[token])
	
	


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
