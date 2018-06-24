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
return function(formationDef)
	
	local newFormation = {}
	local limit = #formationDef
		
	for i=1,limit do
		table.insert(newFormation, formationDef[i]*25)
	end
	
	return newFormation
end