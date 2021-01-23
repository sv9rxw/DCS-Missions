
----- Check contraints satisfaction ---------------------------------------
_unitName = 'Thunder-1'
_unit = Unit.getByName('Thunder-1')

if (_unit == nil) then
    trigger.action.outText('DEBUG: Internal Error: _unit \'' .. _unitName .. '\' is nil', 10)
else
    _unitPoint = _unit:getPoint() -- returns Vec3 object
    _unitAltMeters = _unitPoint.y        
    _unitAltFeet = mist.utils.metersToFeet(_unitAltMeters)    
        

    if (_unitAltFeet > ALT_MAX) then
        msg = 'WARNING: ' .. _unitName .. ' is above ' .. tostring(ALT_MAX) .. ' feet'
        trigger.action.outText(msg, 1)
    elseif (_unitAltFeet < ALT_MIN) then
        msg = 'WARNING: ' .. _unitName .. ' is below ' .. tostring(ALT_MIN) .. ' feet'
        trigger.action.outText(msg, 1)
    end
end
---------------------------------------------------------------------------