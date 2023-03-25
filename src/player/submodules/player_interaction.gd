class_name interactor extends RayCast3D

@onready var interact_label:interactable_label = get_node("/root/UISingleton").INTERACT_LABEL

var highlighted_object:Node3D

func interact():
	if highlighted_object and highlighted_object.has_method("interact"):
		highlighted_object.interact()

func _process(delta):
	var col = get_collider()
	
	if col != highlighted_object:
		if col:
			interact_label.toggle_visibility(col.has_method("interact"))
		else:
			interact_label.toggle_visibility(false)
	
	if col:
		highlighted_object = col
	else:
		highlighted_object = null
	
