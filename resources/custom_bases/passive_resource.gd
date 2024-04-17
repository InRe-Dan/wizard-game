class_name PassiveResource extends LootResource

# Overrides the Effect's name
@export var passive_name : String = "Unnamed Passive Effect"
# Real description is maintained by the Effect
@export_multiline var passive_menu_description : String = "Unknown Behaviour"
# Overrides the effect's icon
@export var icon : Texture2D = PlaceholderTexture2D.new()
# Used for items and for the inventory
@export var glow : Color = Color.WHITE

# Script must be of type Effect
@export var _effect_script : Script

var effect_giver_resource : EntityResource = load("res://resources/entities/passive_pickup.tres")

func make_effect() -> Effect:
	if _effect_script:
		var effect : Node = Node.new()
		effect.set_script(_effect_script)
		if effect is Effect:
			var typed_effect : Effect = effect as Effect
			typed_effect.set_resource(self)
			return typed_effect
	push_error("Failed to generate effect.")
	return null
	
# I'm thinking that unifying effects and items as Loot could help in the long run, since I
# can then define the Loot of an enemy, to just drop whatever this function spits out.
func make_item_pickup() -> Entity:
	var pickup : EffectPickupEntity = effect_giver_resource.make_entity()
	pickup.item_to_give = make_effect()
	return pickup
	
