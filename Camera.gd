extends Camera

var camera = self
var rayOrigin
var rayEnd
var last_collider
var last_collider_material
var last_colliderMesh

onready var outline = preload("res://outline_material.material")

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos)*2000
	var intersection = space_state.intersect_ray(rayOrigin,rayEnd, [self])

	if not intersection.empty():
		var collider = intersection.collider
		var colliderMesh = collider.get_node("MeshInstance")
#		
#		
		if(collider.is_in_group("Selectable")):
			var material = colliderMesh.get_surface_material(0)
			material.set_next_pass(outline)
			last_collider = collider
			last_colliderMesh = last_collider.get_node("MeshInstance")
			last_collider_material = last_colliderMesh.get_surface_material(0)
			if(Input.is_action_pressed("fire")):
				var dialog = Dialogic.start("First encounter", false)
				add_child(dialog)
		if(last_collider!=collider and last_collider!=null):
			last_collider_material.set_next_pass(null)
