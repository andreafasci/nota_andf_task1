local sensorInfo = {
	name = "HillPositions",
	desc = "Return positions of hills",
	author = "AndF",
	date = "2018-05-11",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

-- @description return
return function()
	local offset = 128	
	local getGroundHeight = Spring.GetGroundHeight
	local mapX = Game.mapSizeX
	local mapZ= Game.mapSizeZ 
	
	local maxHeight1 = 0
	local maxHeight2 = 0
	local maxHeight3 = 0
	local maxHeight4 = 0
	local h1_x = 0
	local h1_z = 0
	local h2_x = 0
	local h2_z = 0
	local h3_x = 0
	local h3_z = 0
	local h4_x = 0
	local h4_z = 0
	
	for tmp_x = 0, mapX, offset do
		for tmp_z = 0, mapZ, offset do
			
			tmp_height = (getGroundHeight(tmp_x, tmp_z))
			
			if (tmp_height >= maxHeight1) then
				-- 4th val = 3rd val
				maxHeight4 = maxHeight3
				h4_x = h3_x
				h4_z = h3_z
				
				-- 3rd val = 2nd val
				maxHeight3 = maxHeight2
				h3_x = h2_x
				h3_z = h2_z
				
				-- 2nd val = 1st val
				maxHeight2 = maxHeight1
				h2_x = h1_x
				h2_z = h1_z
				
				-- 1st val = cur
				maxHeight1 = tmp_height
				h1_x = tmp_x
				h1_z = tmp_z
			
			elseif (tmp_height >= maxHeight2) then
				-- 4th val = 3rd val
				maxHeight4 = maxHeight3
				h4_x = h3_x
				h4_z = h3_z
				
				-- 3rd val = 2nd val
				maxHeight3 = maxHeight2
				h3_x = h2_x
				h3_z = h2_z
				
				-- 2nd val = cur
				maxHeight2 = tmp_height
				h2_x = tmp_x
				h2_z = tmp_z
			
			elseif (tmp_height >= maxHeight3) then
				-- 4th val = 3rd val
				maxHeight4 = maxHeight3
				h4_x = h3_x
				h4_z = h3_z
				
				-- 3rd val = cur
				maxHeight3 = tmp_height
				h3_x = tmp_x
				h3_z = tmp_z	
				
			elseif (tmp_height >= maxHeight4) then
				--4rd val = cur
				maxHeight4 = tmp_height
				h4_x = tmp_x
				h4_z = tmp_z
			
			end
		end
	end
	
	return {
		h1_x = h1_x,
		h1_z = h1_z,
		h2_x = h2_x,
		h2_z = h2_z,
		h3_x = h3_x,
		h3_z = h3_z,
		h4_x = h4_x,
		h4_z = h4_z,
	}
end