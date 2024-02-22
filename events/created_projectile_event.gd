class_name CreatedProjectileEvent extends Event

var proj : Entity

func _init(projectile : Entity) -> void:
	type = types.created_projectile
	proj = projectile
