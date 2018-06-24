local sensorInfo = {
	name = "GroupDefinition",
	desc = "Define table with group to be used with formation.moveCustomGroup() ",
	author = "AndF",
	date = "2018-05-15",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

-- speedups
local SpringGetUnitDefID = Spring.GetUnitDefID

-- @description return
return function(listOfUnits, startingIterateUnit, endIterateUnit)
				
	local group1 = {}
	local unitAmount = 1
	
	for i=startingIterateUnit,#listOfUnits do
		local unitId = listOfUnits[i]
		local unitDefID = Spring.GetUnitDefID(unitId)

		if ((UnitDefs[unitDefID] ~= nil) and
			((UnitDefs[unitDefID].name == "armspy") or 
			(UnitDefs[unitDefID].name == "armseer") or
			(UnitDefs[unitDefID].name == "armzeus") or	
			(UnitDefs[unitDefID].name == "armmart") or
			(UnitDefs[unitDefID].name == "armmav") or
			(UnitDefs[unitDefID].name == "armfark") or
			(UnitDefs[unitDefID].name == "cmercdrag"))) then
			
			group1[unitId] = unitAmount
			unitAmount = unitAmount+1
			if (unitAmount > 29) then break end
			
		end
	end
		
	return {
		group = group1,
		groupDim = unitAmount
	}
end