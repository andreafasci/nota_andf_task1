function getInfo()
	return {
		onNoUnits = FAILURE, -- immediately fail
		tooltip = "Load units to rescue",
		parameterDefs = {
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

function Run(self, units, parameter)
	
	local unitsToRescue = parameter.unitsToRescue
	local loadID = CMD.LOAD_UNITS
	
	local transporterID = units[1]
	local currUnitToRescue = unitsToRescue[1]
	
	SpringGiveOrderToUnit(transporterID, loadID, {currUnitToRescue.id}, {})
	
	if (SpringGetUnitTransporter(currUnitToRescue.id) == nil) then
		return RUNNING
	else
		return SUCCESS
	end
	
end
