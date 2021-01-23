
----- Check contraints satisfaction ---------------------------------------

_unitNameTable = {'Thunder-1', 'Thunder-2', 'Thunder-3', 'Thunder-4'}

for i=1,4 do
    _unit = Unit.getByName(_unitNameTable[i])
    if (_unit ~= nil) then
        _unitPoint = _unit:getPoint() -- returns Vec3 object
        _unitAltMeters = _unitPoint.y        
        _unitAltFeet = mist.utils.metersToFeet(_unitAltMeters)            
        _group = _unit:getGroup()
        _groupId = _group:getID()

        _name = _unit:getPlayerName()
        if (_name == nil) then
            _name = _unitNameTable[i]
        end
            
        if (_unitAltFeet > ALT_MAX) then
            msg = 'ALTITUDE: ' .. _name .. ' is ABOVE ' .. tostring(ALT_MAX) .. ' feet'
            --trigger.action.outText(msg, 1)                        
            trigger.action.outTextForGroup(_groupId, msg, 1, false)
        elseif (_unitAltFeet < ALT_MIN) then
            msg = 'ALTITUDE: ' .. _name .. ' is BELOW ' .. tostring(ALT_MIN) .. ' feet'
            --trigger.action.outText(msg, 1)
            trigger.action.outTextForGroup(_groupId, msg, 1, false)
        end
    end    
end

---------------------------------------------------------------------------