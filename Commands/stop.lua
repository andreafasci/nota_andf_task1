function getInfo()
	return {
		onNoUnits = FAILURE, -- immediately fail
		tooltip = "Move to units to rescue",
		parameterDefs = {}
	}
end

function distance (a,b)
	return math.sqrt( (a.x-b.x)^2 + (a.z-b.z)^2 )
end

-- speedups
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGiveOrderToUnitArray = Spring.GiveOrderToUnitArray
local SpringGetUnitTransporter = Spring.GetUnitTransporter
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGetUnitDefID = Spring.GetUnitDefID
local SpringGetUnitNearestAlly = Spring.GetUnitNearestAlly
local SpringGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local SpringGetUnitMaxRange = Spring.GetUnitMaxRange
local SpringGetUnitDirection = Spring.GetUnitDirection

function Run(self, units, parameter)
		
	local transporterID = units[1]
	SpringGiveOrderToUnit(transporterID, CMD.IDLEMODE, {0}, {})
	return SUCCESS
end
