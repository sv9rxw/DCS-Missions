
---------------------------------------------------------------------------

BLUE_DEBUG_ENABLE = false
RED_DEBUG_ENABLE = false

BLUE_COMMAND_GROUP_NAME = "Blue-Viper-JohnGuitar-1"
BLUE_COMMAND_GROUP = nil
RED_COMMAND_GROUP_NAME = "Red-Viper-JohnGuitar-1"
RED_COMMAND_GROUP = nil

BLUE_PREDATOR_GROUP_NAME = "Blue-Predator-1"
BLUE_PREDATOR_RESPAWN_TIMES_MAX = 2
BLUE_PREDATOR_RESPAWN_TIMES_I = 0
RED_PREDATOR_GROUP_NAME = "Red-Predator-1"
RED_PREDATOR_RESPAWN_TIMES_MAX = 2
RED_PRDATOR_RESPAWN_TIMES_I = 0

trigger.action.outText(" - Global variables defined", 10)
---------------------------------------------------------------------------

----- Functions -----------------------------------------------------------
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

--[[
Event_Handler = {}
function Event_Handler:onEvent(event)
    if (world.event.S_EVENT_PLAYER_ENTER_UNIT  == event.id) then
        _unit = event.initiator        
        -- trigger.action.outTextFor_unit:getCoalition(), "Player " .. _unit:getPlayerName() .. " entered unit " .. _unit:getName() .. " at " .. tostring(event.time), 10)        
        if  (_unit:getGroup():getName() == BLUE_COMMAND_GROUP_NAME) then
            BLUE_COMMAND_GROUP = _unit:getGroup()                        
        elseif (_unit:getGroup():getName() == RED_COMMAND_GROUP_NAME) then
            RED_COMMAND_GROUP = _unit:getGroup()
        else
            if _unit:getCoalition() == coalition.side.BLUE then
                if BLUE_COMMAND_GROUP ~= nil then
                    trigger.action.outTextForGroup(BLUE_COMMAND_GROUP:getID(), "Player " .. _unit:getPlayerName() .. " entered unit " .. _unit:getName() .. " at " .. tostring(event.time), 10)            
                end
            elseif _unit:getCoalition() == coalition.side.RED then
                if RED_COMMAND_GROUP ~= nil then
                    trigger.action.outTextForGroup(RED_COMMAND_GROUP:getID(), "Player " .. _unit:getPlayerName() .. " entered unit " .. _unit:getName() .. " at " .. tostring(event.time), 10)            
                end
            end                        
        end
    end
end
]]
--[[
function enableDebug(arg) then
    if (arg == nil) then
        trigger.action.outText("DEBUG: Internal Error: enableJTAC(): arg == nil", 10)
        return
    end    

    if arg['Coalition'] == coalition.side.BLUE then
        BLUE_DEBUG_ENABLE = true
        trigger.action.outTextForCoalition(coalition.side.BLUE, "Debug Mode enabled for Blue coalition." )
    elseif arg['Coalition'] == coalition.side.RED then
        RED_DEBUG_ENABLE = true
        trigger.action.outTextForCoalition(coalition.side.RED, "Debug Mode enabled for Red coalition." )
    else
        trigger.action.outText("DEBUG: Internal Error: enableDebug():  arg['Coalition'] ~= [RED, BLUE]", 10)
    end

    trigger.action.outTextForCoalition(arg['Coalition'], "Debug Mode enabled for Blue coalition." )
end
]]
trigger.action.outText(" - Functions defined", 10)
---------------------------------------------------------------------------

----- Events --------------------------------------------------------------
-- world.addEventHandler(Event_Handler)
trigger.action.outText(" - Event handlers initialized", 10)
---------------------------------------------------------------------------

----- Radio Items ---------------------------------------------------------
-- NOT USED: menuJTAC = missionCommands.addSubMenu('JTAC SOF...')
-- JTAC radio items will be adedd directly under 'F10 Other' radio menu

--- Blue JTAC
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Enable JTAC on Tunb Island', nil, enableJTAC, {['JTAC'] = 'Blue-TunbIsland-JTAC-1', ['Code'] = 1688} )
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Enable JTAC on Tunb Kochak', nil, enableJTAC, {['JTAC'] = 'Blue-TunbKochak-JTAC-1', ['Code'] = 1688} )

--- Red JTAC
missionCommands.addCommandForCoalition(coalition.side.RED, 'Enable JTAC on Abu Musa', nil, enableJTAC, {['JTAC'] = 'Red-AbuMusa-JTAC-1', ['Code'] = 1688} )
missionCommands.addCommandForCoalition(coalition.side.RED, 'Enable JTAC on Sirri', nil, enableJTAC, {['JTAC'] = 'Red-Sirri-JTAC-1', ['Code'] = 1688} )

--- Debug Menu
-- menuDebug = missionCommands.addSubMenu('Debug...')
-- missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Enable JTAC on Abu Musa', nil, menuDebug, {['Coalition'] = coalition.side.BLUE} )
-- missionCommands.addCommandForCoalition(coalition.side.RED, 'Enable JTAC on Abu Musa', nil, menuDebug, {['Coalition'] = coalition.side.RED} )

trigger.action.outText(" - Radio menus and items added", 10)
---------------------------------------------------------------------------
