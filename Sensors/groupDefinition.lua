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
		
	local myUnits = {}
	
	local limit = units.length
	
	local group1 = {}
	local group2 = {}
	local group3 = {}
	local group4 = {}
	
	local singleUnitGroups = 0
	local numElemInGroup4 = 0
	
	for i=1,limit do
		local unitId = units[i]
		local unitDefId = SpringGetUnitDefID(unitId)
		
		-- if curr unit is tank, put it in group4
		-- else create three groups with only one unit, and the other units will be in group4 
		-- group4 will be designed to go to the hill with enemy
		
		if (UnitDefs[unitDefId].name == "armthovr") then
			numElemInGroup4 =  numElemInGroup4 + 1
			group4[unitId] = numElemInGroup4
		else 
			if singleUnitGroups == 0 then
				group1[unitId] = 1
				singleUnitGroups = singleUnitGroups + 1
			elseif singleUnitGroups == 1 then
				group2[unitId] = 1
				singleUnitGroups = singleUnitGroups + 1
			elseif singleUnitGroups == 2 then
				group3[unitId] = 1
				singleUnitGroups = singleUnitGroups + 1
			else
				numElemInGroup4 =  numElemInGroup4 + 1
				group4[unitId] = numElemInGroup4 
			end
		end
	end
		
	return {
		group1 = group1,
		group2 = group2,
		group3 = group3,
		group4 = group4
	}
end