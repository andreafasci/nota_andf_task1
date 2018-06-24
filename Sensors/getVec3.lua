local sensorInfo = {
	name = "GetVec3",
	desc = "=returns vec3 version of data given",
	author = "AndF",
	date = "2018-05-15",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

-- @description return
return function(position)
	
	local vec3_pos = Vec3(position.x, position.y, position.z)
		
	return {
		pos = vec3_pos
	}
end