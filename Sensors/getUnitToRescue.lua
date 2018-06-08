local sensorInfo = {
	name = "GetUnitToRescue",
	desc = "Return unitId and positions of units to rescue",
	author = "AndF",
	date = "2018-05-03",
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
local SpringGetUnitPosition = Spring.GetUnitPosition
local SpringGetTeamUnits = Spring.GetTeamUnits
local SpringGetMyTeamID = Spring.GetMyTeamID

local function tableSortUnits(a, b)
	if (a.distance <= b.distance) then
		return true
	end
	return false
end

function distance (a,b)
	return math.sqrt( (a.x-b.x)^2 + (a.z-b.z)^2 )
end

-- @description return
return function(safeArea)

	-- return a table where i will have position, unitId and distance from
	-- safe zone, ordered by distance
	
	local unitsToRescue = {}
	local safeAreaCenter = safeArea.center
	local safeAreaRadius = safeArea.radius
	
	local teamID = SpringGetMyTeamID()
	local teamUnits = SpringGetTeamUnits(teamID)
			
	local limit = #teamUnits
	
	for i=1,limit do
	
		local unitId = teamUnits[i]
		local unitDefId = SpringGetUnitDefID(unitId)
		
		local tmpX, tmpY, tmpZ = SpringGetUnitPosition(unitId)
		local unitPosition = Vec3(tmpX, 0, tmpZ)
		local unitDistance = safeAreaCenter:Distance(unitPosition)
		
		if (unitDistance > 3*safeAreaRadius) and
			((UnitDefs[unitDefId].name == "armbox") or 
			(UnitDefs[unitDefId].name == "armham") or
			(UnitDefs[unitDefId].name == "armbull") or
			(UnitDefs[unitDefId].name == "armrock") or
			(UnitDefs[unitDefId].name == "armmllt")
			)
			then
			local tmp = {distance = unitDistance, id = unitId, position = unitPosition}
			
			table.insert(unitsToRescue, tmp)
		end
	end
		
	table.sort(unitsToRescue, tableSortUnits)
	
	return {
		unitsToRescue = unitsToRescue,
	}
end