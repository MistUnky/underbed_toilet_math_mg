--cloud stone ice
minetest.register_node("underbed_toilet_mg:cloud", {
	description = "Cloud",
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1},
	drop = "default:cloud", ---how lol
	--paramtype = "light",
	--light_source = 14,
	sunlight_propagates = true,
})

minetest.register_node("underbed_toilet_mg:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:cobble",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
	drop = "default:stone",
	--paramtype = "light",
	--light_source = 14,
	sunlight_propagates = true,
})

minetest.register_node("underbed_toilet_mg:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_ice_defaults(),
	drop = "default:ice",
	--light_source = 14,
	sunlight_propagates = true,
})


function mandelbox(x,y,z,d,nn)
	local s = 7
	x = x * s
	y = y * s
	z = z * s
	d = d * s
	local posX = x
	local posY = y
	local posZ = z
	local dr = 1.0
	local r = 0.0
	local scale = 2
	local minRadius2 = 0.25
	local fixedRadius2 = 1
	for n=0, nn do
		--Reflect
		if x > 1.0 then
			x = 2.0 - x
		elseif x < -1.0 then
			x = -2.0 - x
		end
		if y > 1.0 then
			y = 2.0 - y
		elseif y < -1.0 then
			y = -2.0 - y
		end
		if z > 1.0 then
			z = 2.0 - z
		elseif z < -1.0 then
			z = -2.0 - z
		end
		--Sphere Inversion
		local r2 = (x * x) + (y * y) + (z * z)
		if r2 < minRadius2 then
			x = x * (fixedRadius2 / minRadius2)
			y = y * (fixedRadius2 / minRadius2)
			z = z * (fixedRadius2 / minRadius2)
			dr = dr * (fixedRadius2 / minRadius2)
		elseif r2 < fixedRadius2 then
			x = x * (fixedRadius2 / r2)
			y = y * (fixedRadius2 / r2)
			z = z * (fixedRadius2 / r2)
			fixedRadius2 = fixedRadius2 * (fixedRadius2 / r2)
		end
		x = (x * scale) + posX
		y = (y * scale) + posY
		z = (z * scale) + posZ
		dr = dr * scale
	end
	r = math.sqrt((x*x)+(y*y)+(z*z))
	return ((r / math.abs(dr)) < d)
end


















---orly
minetest.register_on_generated(function(minp, maxp, seed)
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local data = vm:get_data()
    local a = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
    local csize = vector.add(vector.subtract(maxp, minp), 1)
    local write = false
	for z = minp.z, maxp.z do
	for y = minp.y, maxp.y do
	for x = minp.x, maxp.x do
		local ivm = a:index(x, y, z)
		--if y < -20000 and y > -20047 then
		if y < -20000 and y > -20011 then
			if math.random(1,17) == 1 then
				if y > -20008 then
					if math.random(1,69) == 1 then
						data[ivm] = minetest.get_content_id("default:meselamp")
					else
						data[ivm] = minetest.get_content_id("air")
					end
				else
					data[ivm] = minetest.get_content_id("default:obsidianbrick")
				end
			else
				data[ivm] = minetest.get_content_id("air")
			end
			write = true
		elseif y <= -20011 and y > -20023 then
			data[ivm] = minetest.get_content_id("air")
			write = true
		elseif y <= -20023 and y > -20025 then
			if math.random(1,17) == 1 then
				data[ivm] = minetest.get_content_id("default:obsidianbrick")
			else
				data[ivm] = minetest.get_content_id("air")
			end
			write = true
		elseif y <= -20025 then
			local choice = math.random(1,3)
			if choice == 1 then
				data[ivm] = minetest.get_content_id("default:obsidian")
			elseif choice == 2 then
				data[ivm] = minetest.get_content_id("default:lava_source")
			else
				data[ivm] = minetest.get_content_id("air")
			end
			write = true
		elseif y >= -20000 and y < -18000 then
			data[ivm] = minetest.get_content_id("default:obsidian")
			write = true
		elseif y > 20000 and y < 31000 then
			if math.random(1,3) == 1 then
				data[ivm] = minetest.get_content_id("underbed_toilet_mg:cloud")
			else
				data[ivm] = minetest.get_content_id("default:water_source")
			end
			write = true
		else
			local size = 1000
			local distance = 0.01
			local invert = 0
			local center = vector.new(size*0.3, -size*0.6, size*0.5)
			local iterations = 10
			local scale = 1/size
			local vec = vector.multiply(vector.subtract(vector.new(x,y,z),center),scale)
			local d = mandelbox(vec.x,vec.y,vec.z,distance,iterations)
			if d then
				data[ivm] = minetest.get_content_id("underbed_toilet_mg:stone") -- or ice my favorite version of the old math mapgen mandelbox
			elseif y <= 0 then
				data[ivm] = minetest.get_content_id("default:water_source")
			else
				data[ivm] = minetest.get_content_id("air")
			end
			write = true
		end
	end
	end
	end
	
    if write then
        vm:set_data(data)
        vm:set_lighting({day = 0, night = 0})
        vm:calc_lighting()
        vm:update_liquids()
        vm:write_to_map()
    end

end)

minetest.register_chatcommand("warp_math", {
	description = "Warp to Mandelbox",
	func = function(name, pname)
		local player = minetest.get_player_by_name(name)
		player:setpos({x=player:getpos().x,y=100,z=player:getpos().z})
		player:set_sky(nil, "regular")
	end
})
minetest.register_chatcommand("warp_toilet", {
	description = "Warp to The Sky Toilet",
	func = function(name, pname)
		local player = minetest.get_player_by_name(name)
		player:setpos({x=player:getpos().x,y=28000,z=player:getpos().z})
		player:set_sky({r=255, g=255, b=255}, "plain")
	end
})
minetest.register_chatcommand("warp_bed", {
	description = "Warp to Under The Bedrock",
	func = function(name, pname)
		local player = minetest.get_player_by_name(name)
		player:setpos({x=player:getpos().x,y=-20000,z=player:getpos().z})
		player:set_sky({r=15, g=0, b=0}, "plain")
	end
})
