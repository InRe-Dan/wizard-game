class_name PassiveResource extends Resource

@export var passive_name : String = "Unnamed Passive Effect"
@export var passive_description : String = "Unknown Behaviour"
@export var icon : Texture2D = PlaceholderTexture2D.new()
@export var glow : Color = Color.WHITE

@export var _effect_script : Script

var effect_giver_scene : PackedScene

func make_effect() -> Effect:
	if _effect_script:
		var effect : Node = Node.new()
		effect.set_script(_effect_script)
		if effect is Effect:
			var typed_effect : Effect = effect as Effect
			typed_effect.resource = self
			typed_effect.effect_name = passive_name
			typed_effect.effect_description = passive_description
			typed_effect.icon = icon
			return typed_effect
	push_error("Failed to generate effect.")
	return null
