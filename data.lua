require("technologies")

local beacon = data.raw.beacon.beacon

local shield_generator = {
	type = 'electric-energy-interface',
	name = 'shield-generator',

	flags = {
		'player-creation',
	},

	icon = '__base__/graphics/icons/beacon.png',
	-- icon = '__base__/graphics/icons/energy-shield-equipment.png',
	icon_size = 64,
	icon_mipmaps = 4,

	energy_production = '0W',
	energy_usage = '0W',

	collision_box = beacon.collision_box,
	selection_box = beacon.selection_box,
	drawing_box = beacon.drawing_box,
	damaged_trigger_effect = beacon.damaged_trigger_effect,
	flags = beacon.flags,
	graphics_set = beacon.graphics_set,
	water_reflection = beacon.water_reflection,
	corpse = beacon.corpse,
	dying_explosion = beacon.dying_explosion,
	working_sound = beacon.working_sound,
	max_health = 600,

	vehicle_impact_sound = beacon.generic_impact,
	open_sound = beacon.machine_open,
	close_sound = beacon.machine_close,

	minable = {mining_time = 0.2, result = 'shield-generator'},

	energy_source = {
		type = 'electric',
		buffer_capacity = '60MJ',
		usage_priority = 'secondary-input',
		input_flow_limit = '4MW',
		output_flow_limit = '0W',
		drain = '0W',
	},

	picture = {
		layers = {
			{
				filename = '__base__/graphics/entity/beacon/beacon-bottom.png',
				width = 106,
				height = 96,
				shift = util.by_pixel(0, 1),
				hr_version = {
					filename = '__base__/graphics/entity/beacon/hr-beacon-bottom.png',
					width = 212,
					height = 192,
					scale = 0.5,
					shift = util.by_pixel(0.5, 1)
				}
			},

			{
				filename = '__base__/graphics/entity/beacon/beacon-shadow.png',
				width = 122,
				height = 90,
				draw_as_shadow = true,
				shift = util.by_pixel(12, 1),
				hr_version = {
					filename = '__base__/graphics/entity/beacon/hr-beacon-shadow.png',
					width = 244,
					height = 176,
					scale = 0.5,
					draw_as_shadow = true,
					shift = util.by_pixel(12.5, 0.5)
				}
			},

			{
				filename = '__base__/graphics/entity/beacon/beacon-top.png',
				width = 48,
				height = 70,
				repeat_count = 45,
				animation_speed = 0.5,
				shift = util.by_pixel(3, -19),
				hr_version = {
					filename = '__base__/graphics/entity/beacon/hr-beacon-top.png',
					width = 96,
					height = 140,
					scale = 0.5,
					repeat_count = 45,
					animation_speed = 0.5,
					shift = util.by_pixel(3, -19)
				}
			},
		},
	},
}

local item = {
		type = 'item',
		name = 'shield-generator',
		icon = '__base__/graphics/icons/beacon.png',
		icon_size = 64,
		icon_mipmaps = 4,
		subgroup = 'defensive-structure',
		order = 'b[turret]-n[shield-generator-a]',
		place_result = 'shield-generator',
		stack_size = 10
	}

local recipe = table.deepcopy(data.raw["recipe"]["heavy-armor"])
recipe.enabled = true
recipe.name = "shield-generator"
recipe.ingredients = {{"copper-plate",200},{"steel-plate",50}}
recipe.result = "shield-generator"

local prototypes = {
	shield_generator, 
	item,
	recipe
}

data:extend(prototypes)

table.insert(data.raw["artillery-projectile"]["artillery-projectile"].action.action_delivery.target_effects,1,
{
	type = "script",
	effect_id = "shield_explosion_artillery"
})

table.insert(data.raw["projectile"]["grenade"].action[2].action_delivery.target_effects,1,
{
	type = "script",
	effect_id = "shield_explosion_grenade"
})

table.insert(data.raw["projectile"]["explosive-rocket"].action.action_delivery.target_effects,1,
{
	type = "script",
	effect_id = "shield_explosion_rocket"
})

table.insert(data.raw["projectile"]["explosive-cannon-projectile"].action.action_delivery.target_effects,1,
{
	type = "script",
	effect_id = "shield_explosion_cannon"
})

table.insert(data.raw["projectile"]["explosive-uranium-cannon-projectile"].action.action_delivery.target_effects,1,
{
	type = "script",
	effect_id = "shield_explosion_urnaium_cannon"
})






