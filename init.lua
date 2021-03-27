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
				data[ivm] = minetest.get_content_id("default:meselamp")
			else
				data[ivm] = minetest.get_content_id("default:water_source")
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

minetest.register_chatcommand("warp_earth", {
	description = "Warp to Pseudo Earth",
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
