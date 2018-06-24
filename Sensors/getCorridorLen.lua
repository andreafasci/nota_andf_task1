local sensorInfo = {
	name = "GetMetal",
	desc = "Return quantity of metal",
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

-- @speedups
SpringGetMyTeamID = Spring.GetMyTeamID
SpringGetTeamResources = Spring.GetTeamResources

-- @description return
return function(corridor)	
	local corridorLen = #(corridor.points)
	return {
		corridorLen = corridorLen
	}
end