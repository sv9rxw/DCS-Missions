

_groupName = "Red-Qeshm-Fighter-1"
if not Group.getByName(_groupName) then
    if _respawnTimesCur < _respawnTimesMax then
        mist.respawnGroup(_groupName, true)
        _respawnTimesCur = _respawnTimesCur + 1
        trigger.action.outText("DEBUG: respawned " .. _groupName .. " times #" .. _respawnTimesCur, 30)
    else
        trigger.action.outText("DEBUG: reach MAX respawn times " .. _respawnTimesCur .. " for " .. _groupName, 30)
    end 
end