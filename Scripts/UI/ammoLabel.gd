class_name ammo_label extends Label

func init(current_ammo:int, maxAmmo:int) -> void:
	text = "%s/%s" % current_ammo % maxAmmo
