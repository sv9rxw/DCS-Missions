
_unitName = "DEBUG-Blue-Viper-1-1"
_unit = ctld.getTransportUnit(_unitName)

if _unit == nil then
    trigger.action.outText("_unit for " .. _unitName .. "is NULL", 30)    
else

    _groupId = ctld.getGroupId(_unit)

    if _groupId == nil then
        trigger.action.outText("_groupId for " .. _unitName .. "is NULL", 30)
    else
        trigger.action.outText("_groupId for " .. _unitName .. "is " .. _groupId, 30)
    end
end