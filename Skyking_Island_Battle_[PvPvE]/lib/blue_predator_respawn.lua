if not Group.getByName(blue_predator_group_name) then
    if blue_predator_respawn_times_i < blue_predator_respawn_times_max then
        mist.respawnGroup(blue_predator_group_name, true)
        blue_predator_respawn_times_i = blue_predator_respawn_times_i + 1
        trigger.action.outText("SKYKING, SKYKING. INFO MESSAGE: AFAC Predator is airborne. " .. blue_predator_respawn_times_max - blue_predator_respawn_times_max .. " units remaining. Skyking, Skyking. Out.", 30)
    end
end