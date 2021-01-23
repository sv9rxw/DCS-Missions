
_unit = Unit.getByName( 'My-Unit-Name-1') -- returns Unit object

_unitPoint = _unit:getPoint() -- returns Vec3 object - unit coordinates [x,y,z] reference from group plane reference point
_unitY = _unitPoint.y    -- returns integer = altitude in meters    
_unitYFeet = mist.utils.metersToFeet(_unitY) -- converts from meters to feet using MIST        
