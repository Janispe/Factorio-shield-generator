

technologies =  {
	{
		type = 'technology',
		name = 'shield-generator',

		icon_size = 64,
		icon_mipmaps = 4,
		-- icon = '__base__/graphics/technology/energy-shield-equipment.png',
		icon = '__base__/graphics/icons/beacon.png',

		effects = {
			{
				type = 'unlock-recipe',
				recipe = 'shield-generator'
			}
		},

		prerequisites = {
			'effectivity-module-3',
		},

		unit = {
			count = 1000,

			ingredients = {
				{'automation-science-pack', 1},
				{'logistic-science-pack', 1},
				{'military-science-pack', 1},
				{'chemical-science-pack', 1},
				{'utility-science-pack', 1},
			},

			time = 60
		},
	},
}

data:extend(technologies)