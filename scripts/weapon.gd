class_name Weapon
extends Node2D
var projectileData : ProjectileData
var weaponData : WeaponData
signal shotProjectile(projectile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = weaponData.image

func setResource(res : WeaponData) -> Weapon:
	weaponData = res.duplicate()
	projectileData = weaponData.projectileShot
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(character) -> void:
	var proj = preload("res://scenes/projectile.tscn").instantiate().setResource(projectileData)
	proj.position = character.position
	proj.setVelocity(character.aim)
	character.get_tree().call_group("main", "_create_new_projectile", proj)
