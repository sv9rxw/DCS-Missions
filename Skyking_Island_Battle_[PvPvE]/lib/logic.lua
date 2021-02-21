

----- Unit Respawn logic --------------------------------------------------
if not Group.getByName(BLUE_PREDATOR_GROUP_NAME) then
    if BLUE_PREDATOR_RESPAWN_TIMES_I < BLUE_PREDATOR_RESPAWN_TIMES_MAX then
        mist.respawnGroup(BLUE_PREDATOR_GROUP_NAME, true)
        BLUE_PREDATOR_RESPAWN_TIMES_I = BLUE_PREDATOR_RESPAWN_TIMES_I + 1        
        msg = "SKYKING, SKYKING. INFO MESSAGE: AFAC Predator is has been taken down. New UAV Predator is airborne. " .. BLUE_PREDATOR_RESPAWN_TIMES_MAX - BLUE_PREDATOR_RESPAWN_TIMES_I .. " units remaining. Skyking, Skyking. Out."
        trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 30 , false)
    end
end

if not Group.getByName(RED_PREDATOR_GROUP_NAME) then
    if RED_PRDATOR_RESPAWN_TIMES_I < RED_PREDATOR_RESPAWN_TIMES_MAX then
        mist.respawnGroup(RED_PREDATOR_GROUP_NAME, true)
        RED_PRDATOR_RESPAWN_TIMES_I = RED_PRDATOR_RESPAWN_TIMES_I + 1        
        msg = "SKYKING, SKYKING. INFO MESSAGE: AFAC Predator is has been taken down. New UAV Predator is airborne. " .. RED_PREDATOR_RESPAWN_TIMES_MAX - RED_PRDATOR_RESPAWN_TIMES_I .. " units remaining. Skyking, Skyking. Out."
        trigger.action.outTextForCoalition(coalition.side.RED, msg, 30 , false)
    end
end
---------------------------------------------------------------------------