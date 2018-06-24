local sensorInfo = {
	name = "GroupDefinition",
	desc = "Define table with group to be used with formation.moveCustomGroup() ",
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

-- speedups
local SpringGetUnitDefID = Spring.GetUnitDefID

-- @description return
return function()
		
	local allyUnits = {}
	local myTeamID = Spring.GetMyTeamID()
	local teamUnits = Spring.GetTeamUnits(myTeamID)
		
	return {
		newUnits = teamUnits,
		unitsAmount = #teamUnits
	}
end