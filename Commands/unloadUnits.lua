function getInfo()
	return {
		onNoUnits = FAILURE, -- immediately fail
		tooltip = "Load units to rescue",
		parameterDefs = {
			{ 
				name = "safeArea", 
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			},
			{ 
				name = "unitsToRescue", 
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "",
			}
		}
	}
end

-- speedups
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGetUnitTransporter = Spring.GetUnitTransporter
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGetUnitRadius = Spring.GetUnitRadius

function Run(self, units, parameter)
	
	local safeArea = parameter.safeArea
	local unitsToRescue =  parameter.unitsToRescue
	
	local unloadID = CMD.UNLOAD_UNITS
	local currUnitToRescue = unitsToRescue[1]
		
	local safeAreaCenter = safeArea.center
	local safeAreaRadius = safeArea.radius

	local transporterID = units[1]
	
	local pointX, pointY, pointZ = SpringGetUnitPosition(transporterID)

	local unitRadius = SpringGetUnitRadius(currUnitToRescue.id)
	
	SpringGiveOrderToUnit(transporterID, CMD.TIMEWAIT, {1000}, CMD.OPT_SHIFT)
	SpringGiveOrderToUnit(transporterID, unloadID, {pointX, pointY, pointZ, unitRadius}, {"shift"})
			
	if (SpringGetUnitTransporter(currUnitToRescue.id) == nil) then
		return SUCCESS
	end
	
	return RUNNING
	
end
