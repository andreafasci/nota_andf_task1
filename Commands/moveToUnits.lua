function getInfo()
	return {
		onNoUnits = FAILURE, -- immediately fail
		tooltip = "Move to units to rescue",
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

function distance (a,b)
	return math.sqrt( (a.x-b.x)^2 + (a.z-b.z)^2 )
end

-- speedups
local SpringGiveOrderToUnit = Spring.GiveOrderToUnit
local SpringGiveOrderToUnitArray = Spring.GiveOrderToUnitArray
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGetUnitDefID = Spring.GetUnitDefID
local SpringGetUnitNearestEnemy = Spring.GetUnitNearestEnemy

function Run(self, units, parameter)
	
	local unitsToRescue = parameter.unitsToRescue
	local currUnitToRescue = unitsToRescue[1]
	local comeHere = currUnitToRescue.position
	
	local moveID = CMD.MOVE
	local transporterID = units[1]
	local pointX, pointY, pointZ = SpringGetUnitPosition(transporterID)
	local transporterPosition = Vec3(pointX, pointY, pointZ)
	
	-- if far from destination, give command to move
	if (distance(transporterPosition, comeHere) > 30) then
		local nearestEnemyID = SpringGetUnitNearestEnemy(transporterID)
		local nearestEnemyDef = SpringGetUnitDefID(nearestEnemyID)
		
		-- if there's an enemy nearby try to avoid it
		if ((nearestEnemyID ~= nil) and (nearestEnemyDef ~= nil)) then
			local enemyX, enemyY, enemyZ = SpringGetUnitPosition(nearestEnemyID)
			local enemyPos = Vec3(enemyX, enemyY, enemyZ)
			local unitRange = UnitDefs[nearestEnemyDef].maxWeaponRange
						
			if ( (unitRange ~= nil) and 
			( distance(transporterPosition, enemyPos) < unitRange+100)) then
				
				-- but if destination is near, don't care about the enemy and go on anyway
				if (distance(transporterPosition, comeHere) > 700) then
					local comeHere = transporterPosition - enemyPos
					if (comeHere.x < 0) then comeHere.x = 0	end
					if (comeHere.y < 0) then comeHere.y = 0	end
					if (comeHere.z < 0) then comeHere.z = 0	end	
					SpringGiveOrderToUnit(transporterID, moveID, comeHere:AsSpringVector(), {})
					return RUNNING
				else
					SpringGiveOrderToUnit(transporterID, moveID, comeHere:AsSpringVector(), {})
					return RUNNING
				end
			end
		end
		
		-- if no enemy simply move to destination
		SpringGiveOrderToUnit(transporterID, moveID, comeHere:AsSpringVector(), {})
		return RUNNING
	end
	
	-- if near to destination return success
	return SUCCESS
	
end
