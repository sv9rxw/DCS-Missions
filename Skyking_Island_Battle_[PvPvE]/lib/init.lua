function enableJTAC(arg)
    if (arg == nil) then
        trigger.action.outText("DEBUG: Internal Error: enableJTAC(): arg == nil", 10)
        return
    end    

    if (arg['JTAC'] == nil) then
        trigger.action.outText("DEBUG: Internal Error: enableJTAC(): arg['JTAC'] == nil", 10)
        return
    end

    if (arg['Code'] == nil) then
        trigger.action.outText("DEBUG: Internal Error: enableJTAC(): arg['Code'] == nil", 10)
        return           
    end

    ctld.JTACAutoLase(arg['JTAC'], arg['Code'])
end


BLUE_PREDATOR_GROUP_NAME = "Blue-Predator-1"
BLUE_PREDATOR_RESPAWN_TIMES_MAX = 10
BLUE_PREDATOR_RESPAWN_TIMES_I = 0
RED_PREDATOR_GROUP_NAME = "Red-Predator-1"
RED_PREDATOR_RESPAWN_TIMES_MAX = 10
RED_PRDATOR_RESPAWN_TIMES_I = 0

trigger.action.outText("DEBUG: declared gloval vars", 10)

-- Radio items for JTAC
-- NOT USED: menuJTAC = missionCommands.addSubMenu('JTAC SOF...')
-- JTAC radio items will be adedd directly under 'F10 Other' radio menu

--- Blue JTAC
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Enable JTAC on Tunb Island', nil, enableJTAC, {['JTAC'] = 'Blue-TunbIsland-JTAC-1', ['Code'] = 1688} )
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Enable JTAC on Tunb Kochak', nil, enableJTAC, {['JTAC'] = 'Blue-TunbKochak-JTAC-1', ['Code'] = 1688} )

--- Red JTAC
missionCommands.addCommandForCoalition(coalition.side.RED, 'Enable JTAC on Abu Musa', nil, enableJTAC, {['JTAC'] = 'Red-AbuMusa-JTAC-1', ['Code'] = 1688} )
missionCommands.addCommandForCoalition(coalition.side.RED, 'Enable JTAC on Sirri', nil, enableJTAC, {['JTAC'] = 'Red-Sirri-JTAC-1', ['Code'] = 1688} )
