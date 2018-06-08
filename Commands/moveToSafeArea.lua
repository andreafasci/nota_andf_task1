function getInfo()
	return {
		onNoUnits = FAILURE, -- immediately fail
		tooltip = "Move to safe area",
		parameterDefs = {
			{ 
				name = "safeArea", 
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
local SpringGetGroundBlocked = Spring.GetGroundBlocked

function Run(self, units, parameter)
	
	local moveID = CMD.MOVE
	local comeHere = parameter.safeArea.center
	local safeAreaRadius = parameter.safeArea.radius - 50
	
	local transporterID = units[1]
	
	local pointX, pointY, pointZ = SpringGetUnitPosition(transporterID)
	local transporterPosition = Vec3(pointX, pointY, pointZ)
	
	-- if distance is "big" move to the unit and return RUNNING
	if (distance(transporterPosition, comeHere) > safeAreaRadius) then
		
		local nearestEnemyID = SpringGetUnitNearestEnemy(transporterID)
		local nearestEnemyDef = SpringGetUnitDefID(nearestEnemyID)
		
		-- if enemy nearby try to avoid it
		if ((nearestEnemyID ~= nil) and (nearestEnemyDef ~= nil)) then
			local enemyX, enemyY, enemyZ = SpringGetUnitPosition(nearestEnemyID)
			local enemyPos = Vec3(enemyX, enemyY, enemyZ)
			local unitRange = UnitDefs[nearestEnemyDef].maxWeaponRange
						
			-- if destination is near don't care about enemy and go on
			if ( (unitRange ~= nil) and 
				( distance(transporterPosition, enemyPos) < unitRange+50)) then
				local comeHere = transporterPosition - enemyPos
				if (comeHere.x < 0) then comeHere.x = 0	end
				if (comeHere.y < 0) then comeHere.y = 0	end
				if (comeHere.z < 0) then comeHere.z = 0	end
				
				SpringGiveOrderToUnit(transporterID, moveID, comeHere:AsSpringVector(), {})
				return RUNNING
			end
		end
		
		-- if no enemy keep going to destination
		SpringGiveOrderToUnit(transporterID, moveID, comeHere:AsSpringVector(), {})
		return RUNNING
	end	
	
	-- here we know that Atlas is near to destination
	-- detect if area is free, otherwise move
	local currUnitTransported = Spring.GetUnitIsTransporting(transporterID)[1]
	if (currUnitTransported == nil) then return FAILURE end
	local unitRadius = Spring.GetUnitRadius(currUnitTransported)

	-- if ground blocked then move randomly in area again
	if (SpringGetGroundBlocked(transporterPosition.x - (1.5*unitRadius), transporterPosition.z - (1.5*unitRadius),
	transporterPosition.x+(1.5*unitRadius), transporterPosition.z + (1.5*unitRadius))) then
		local tmp_x = comeHere.x + math.random(-safeAreaRadius/2, safeAreaRadius/2)
		local tmp_z = comeHere.z + math.random(-safeAreaRadius/2, safeAreaRadius/2)
		local tmp_dest = Vec3(tmp_x, 0, tmp_z)
		SpringGiveOrderToUnit(transporterID, moveID, tmp_dest:AsSpringVector(), {})
		return RUNNING
	else
		SpringGiveOrderToUnit(transporterID, CMD.STOP, {}, {""} )
		return SUCCESS
	end
	
	SpringGiveOrderToUnit(transporterID, CMD.STOP, {}, {""} )
	return SUCCESS
end
