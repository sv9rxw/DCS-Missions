if not Group.getByName(red_predator_group_name) then
    if red_predator_respawn_times_i < red_predator_respawn_times_max then
        mist.respawnGroup(red_predator_group_name, true)
        red_predator_respawn_times_i = red_predator_respawn_times_i + 1
        trigger.action.outText("SKYKING, SKYKING. INFO MESSAGE: AFAC Predator is airborne. " .. red_predator_respawn_times_max - red_predator_respawn_times_max .. " units remaining. Skyking, Skyking. Out.", 30)
    end
end