--control.lua

-- list of all shield generators
local shieldGenerators = {}
-- this list is needed to determine, if a damager dealer with area damage(artilerry..) is already considered. Artileryy shells only 
-- deal 1000 damage to the shield and not 1000 * buildings in radius
local projectiles_in_tick = {}
-- leftDamage of a area projectile if the shield can not absorb all damage
local leftDamage = {}
-- lastHealth of building. Needed to determine health after shield absorb damage.
local lastHealth = {}

script.on_event(defines.events.on_script_trigger_effect,
	function(event)
		local player = game.get_player(1)
		local position = event.target_position 
		for k,v in pairs(shieldGenerators) do
			local distance = ((position.x - v.shield_entity.position.x)^2 + (position.y - v.shield_entity.position.y)^2)^(1/2)
			if (distance <= v.radius) then
				--v.current_shield = v.current_shield - 1000
				--player.print(v.current_shield)
			end		
		end
		
		--player.print(event.target_entity)
		--player.print(event.source_entity.name)
		--player.print(event.target_position)
	end
)

script.on_event(defines.events.on_entity_damaged,
	function(event)
		local player = game.get_player(1)
		local position = event.entity.position
		local source = event.cause
		local damage = event.original_damage_amount
		local entity = event.entity
		player.print(source.name .. " " .. entity.name)
		player.print(event.original_damage_amount .. " " .. entity.name)
		player.print(event.damage_type.name)
		player.print(position)
		for k,v in pairs(shieldGenerators) do
			local distance = ((position.x - v.shield_entity.position.x)^2 + (position.y - v.shield_entity.position.y)^2)^(1/2)
			if (distance <= v.radius) then
					player.print(tostring(projectiles_in_tick[source.unit_number]) .. " " .. entity.name)
				if (projectiles_in_tick[source.unit_number]) then
					player.print("projectile gemerkt")
					entity.health = lastHealth[entity.unit_number] - leftDamage[source.unit_number] * event.final_damage_amount
				else 
					projectiles_in_tick[source.unit_number] = true
					player.print(tostring(projectiles_in_tick[source.unit_number]) .. " " .. entity.name)
					if (v.current_shield >= 1000) then 
						v.current_shield = v.current_shield - 1000
						leftDamage[source.unit_number] = 0
						entity.health = lastHealth[entity.unit_number]
					else 
						leftDamage[source.unit_number] = (1000 - v.current_shield) / 1000
						v.current_shield = 0
						entity.health = lastHealth[entity.unit_number] - leftDamage[source.unit_number] * event.final_damage_amount
					end
				end
				player.print(v.current_shield .. " " .. entity.name)
			end	
		end
	end
)		

script.on_event(defines.events.on_trigger_fired_artillery,
	function(event)
		local player = game.get_player(1)
		player.print('hi')
	end
)

script.on_event(defines.events.on_entity_destroyed,
	function(event)
		for k,v in pairs(shieldGenerators) do 
			if (v.entity_id == event.unit_number) then
				shieldGenerators[k] = nil
			end
		end
	end
)

script.on_event(defines.events.on_built_entity,
	function(event)
		local position = event.created_entity.position
		for k,v in pairs(shieldGenerators) do
			local distance = ((position.x - v.shield_entity.position.x)^2 + (position.y - v.shield_entity.position.y)^2)^(1/2)
			if (distance <= v.radius) then
				lastHealth[event.created_entity.unit_number] = event.created_entity.health
				break
			end		
		end
			
		if (event.created_entity.name == 'shield-generator') then
			script.register_on_entity_destroyed(event.created_entity)
		
			w, heigth = determineDimensions(event.created_entity)
			
			id1 = rendering.draw_rectangle({
				color = {r = 0.2, g = 0, b = 0, a = 0},
				filled = true,
				surface = event.created_entity.surface,
				left_top = event.created_entity,
				left_top_offset = {-w * 0.9, heigth*0.6},
				right_bottom = event.created_entity,
				right_bottom_offset = {w * 0.9, heigth*0.7}})

			id2 = rendering.draw_rectangle({
				color = {r = 1, g = 0, b = 0, a = 0},
				filled = true,
				surface = event.created_entity.surface,
				left_top = event.created_entity,
				left_top_offset = {-w * 0.9, heigth*0.6},
				right_bottom = event.created_entity,
				right_bottom_offset = {-w * 0.9, heigth*0.7}})
		
		
		
			local shield_data = {
				shield_entity = event.created_entity,
				entity_id = event.created_entity.unit_number,
				max_shield = 5000,
				current_shield = 0,
				radius = 20,
				width = w,
				bar_background_id = id1,
				bar_id = id2,
				render_object_id = rendering.draw_circle({color = {r = 0, g = 0, b = 0, a = 0}, radius = 20, 
					filled = true, target = event.created_entity, surface = event.created_entity.surface})
			}
			table.insert(shieldGenerators,shield_data)
			
			local found = event.created_entity.surface.find_entities_filtered({
			position = event.created_entity.position,
			radius = 21
			})
			for k,v in pairs(found) do
				-- trees have nil number
				if (v.unit_number == not nil) then
					lastHealth[v.unit_number] = v.health
				end
			end
		end
	end
)

script.on_event(defines.events.on_tick,
	function(event)
		clearProjectiles()
		chargeShieldGenerators()
	end
)

function clearProjectiles()
	local player = game.get_player(1)
	for k,v in pairs (projectiles_in_tick) do
		projectiles_in_tick[k] = nil
		player.print("clear projectiles")
	end
end

function chargeShieldGenerators()
	for k,v in pairs(shieldGenerators) do
		local entity = v.shield_entity
		if (entity.valid) then
			local needed_shield = v.max_shield - v.current_shield
			local energy = entity.energy
			if (energy / 20000 >= needed_shield) then
				entity.energy = energy - needed_shield * 20000
				v.current_shield = v.max_shield
			end
			if (energy / 20000 < needed_shield) then
				v.current_shield = v.current_shield + energy / 20000
				entity.energy = 0
			end
			
			rendering.set_color(v.render_object_id, {r = 0, g = 0, b = (v.current_shield / v.max_shield), a = 0})
			rendering.set_right_bottom(v.bar_id, v.shield_entity, {-v.width * 0.9 + 1.8 * v.width * v.current_shield / v.max_shield , heigth*0.7})
		end	
	end
end


function determineDimensions(entity)
	local width, height

	if entity.prototype.selection_box then
		if entity.direction == defines.direction.east or entity.direction == defines.direction.west then
			width = math.abs(entity.prototype.selection_box.left_top.y - entity.prototype.selection_box.right_bottom.y)
			height = math.abs(entity.prototype.selection_box.right_bottom.x)
		else
			width = math.abs(entity.prototype.selection_box.left_top.x - entity.prototype.selection_box.right_bottom.x)
			height = math.abs(entity.prototype.selection_box.right_bottom.y)
		end
	else
		width = 1
		height = 0
	end

	if width < 1 then
		width = 1
	end

	height = height + 0.4
	width = width / 2

	return width, height
end
