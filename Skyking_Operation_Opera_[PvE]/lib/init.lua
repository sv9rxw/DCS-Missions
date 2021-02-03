AGL_MAX = 800  -- feet
AGL_MAX_PASSED = false
AA_ZONE_PENETRATED = false
DETECTION_DELAY = 30 -- seconds
DETECTION_USER_FLAG_NAME = '10'

BLUE_COMMAND_GROUP = nil
BLUE_COMMAND_GROUP_NAME = "Cmd"

ACTIVE_AIRCRAFTS = {} -- table of active aircrafts
ACTIVE_AIRCRAFT_NAMES = {}
AGL_THRESHOLD_ZONES = {'AGLThresholdZone'}

function __FILE__() return debug.getinfo(2, 'S').source end
function __LINE__() return debug.getinfo(2, 'l').currentline end
function __FUNC__() return debug.getinfo(2, 'n').name end

function LOG(txt) env.info("SKYKING -- " .. txt, false) end
function MSG(txt) trigger.action.outText("SKYKING -- " .. txt, 10) end

function createActiveAicraftNamesTable()
    
    if ACTIVE_AIRCRAFTS == nil then
        ACTIVE_AIRCRAFT_NAMES = {}
        return
    end

    ACTIVE_AIRCRAFT_NAMES = nil
    ACTIVE_AIRCRAFT_NAMES = {}    

    for i=1,#ACTIVE_AIRCRAFTS do
        table.insert(ACTIVE_AIRCRAFT_NAMES, ACTIVE_AIRCRAFTS[i]:getName())
    end
end

function activeRemove(u)
    local len = 0
    local temp = nil
    local res = false
    
    if ACTIVE_AIRCRAFTS ~= nil then
        len = #ACTIVE_AIRCRAFTS
        local i = 0
        for i=1,len do
            temp = ACTIVE_AIRCRAFTS[i]
            if u:getName() == temp:getName() then
                table.remove(ACTIVE_AIRCRAFTS, i)         
                res = true       
            end
        end
    end

    res = false    
    if ACTIVE_AIRCRAFT_NAMES ~= nil then
        len = #ACTIVE_AIRCRAFT_NAMES
        local i = 0
        local _name = nil
        for i=1,len do
            _name = ACTIVE_AIRCRAFT_NAMES[i]
            if u:getName() == _name then
                table.remove(ACTIVE_AIRCRAFT_NAMES, i)                
                res = true
            end
        end
    end
    return res
end

function metersToFeet(m)
    return m/0.3048
end

-- Get Unit Above Surface Level (DCS real level - close to barometric altitude)
function getUnitASLFeet(u)
    if u == nil then
        trigger.action.outText("DEBUG: Internal Error: getUnitAGL(): u == nil" , 2)
        return 0
    end

    local _unitPoint = u:getPoint() -- returns Vec3 object     

    return metersToFeet(_unitPoint.y)                        
end

-- Get Unit Above Ground Level (radar altitude) 
function getUnitAGLFeet(u) 
    if (u == nil) then
        trigger.action.outText("DEBUG: Internal Error: getUnitAGLFeet(): u == nil" , 2)
        return 0
    end

    local _unitPoint = u:getPoint() -- returns Vec3 object        
    local _unitAltFeet = metersToFeet(_unitPoint.y)            
    local _unitPointVec2 = { x = _unitPoint.x, y = _unitPoint.z } -- Convert Vec3 to Vec2, ommit height
    local _landAltMeters = land.getHeight(_unitPointVec2)  -- invoke DCS Native Scripting Engine
    local _landAltFeet = metersToFeet(_landAltMeters)

    return _unitAltFeet - _landAltFeet
end

function unitIsInZone(u, zoneName)    
    local _zone = trigger.misc.getZone(zoneName)

    if _zone == nil then
        LOG(__FUNC__() .. ": zone with name \'" .. zoneName .. "\' == nil")
        return false
    end

    if (mist.utils.get2DDist(u:getPosition().p, _zone.point) < _zone.radius) then
        return true
    end    

    return false
end

trigger.action.outText("- Gloval variables initialized", 10)

Event_Handler = {}
function Event_Handler:onEvent(event)
    local _unit = event.initiator
    if _unit == nil then
        LOG(__FUNC__() .. ": event.initiator == nil")
        return
    end

    if _unit:getCategory() ~= Object.Category.UNIT then
        LOG(__FUNC__() .. ": event.initiator category != UNIT. Omitting.")
        return
    end

    if _unit:isExist() == false then
        LOG(__FUNC__() .. ": _unit does not exist")
        return
    end

    local msg = ""
    local status = false
    if _unit:getCoalition() == coalition.side.BLUE then
        local _playerName = _unit:getPlayerName()
        if _playerName == nil then
            LOG(__FUNC__() .. ": _unit is not a human player _unit:getPlayerName() == nil. Omitting.")
            return
        end

        -- those events do not fire in multiplayer
        --[[ 
            if event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then                            
            table.insert(ACTIVE_AIRCRAFTS, _unit)
            table.insert(ACTIVE_AIRCRAFT_NAMES, _unit:getName())
            msg = "Player " .. _playerName .. " entered unit " .. _unit:getName() .. "\n"                       
        elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then            
            status = activeRemove(_unit)
            if status == true then
                msg = "Player " .. _playerName .. " left unit " .. _unit:getName() .. "\n"
            else
                LOG(__FUNC__() .. " S_EVENT_PLAYER_LEAVE_UNIT: _unit " .. _unit:getName() .. " not found in ACTIVE_AIRCRAFTS table")
            end
        ]]

        if event.id == world.event.S_EVENT_BIRTH then            
            msg = _playerName .. " entered " .. _unit:getName()
            ACTIVE_AIRCRAFTS = coalition.getPlayers(coalition.side.BLUE)        
            ACTIVE_AIRCRAFT_NAMES = createActiveAicraftNamesTable()
        elseif event.id == world.event.S_EVENT_DEAD then
            msg = _playerName .. " in " .. _unit:getName() .. " is dead"
            ACTIVE_AIRCRAFTS = coalition.getPlayers(coalition.side.BLUE)        
            ACTIVE_AIRCRAFT_NAMES = createActiveAicraftNamesTable()
        elseif event.id == world.event.S_EVENT_PILOT_DEAD then
            msg = _playerName .. " pilot in " .. _unit:getName() .. " is dead"
            ACTIVE_AIRCRAFTS = coalition.getPlayers(coalition.side.BLUE)        
            ACTIVE_AIRCRAFT_NAMES = createActiveAicraftNamesTable()                   
        elseif event.id == world.event.S_EVENT_UNIT_LOST then                         
            msg = _playerName .. " in " .. _unit:getName() .. " was lost"   
            ACTIVE_AIRCRAFTS = coalition.getPlayers(coalition.side.BLUE)        
            ACTIVE_AIRCRAFT_NAMES = createActiveAicraftNamesTable()                          
        elseif event.id == world.event.S_EVENT_CRASH then                        
            msg = "Player " .. _playerName .. " in unit " .. _unit:getName() .. " crashed.\n"                        
        else
            return
        end
        local num_active = #ACTIVE_AIRCRAFTS
        msg = msg .. tostring(num_active) .. " active aircrafts for BLUEFOR"
        trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10)                 
    end
end

function showActiveAirplanes(arg)
    
    if ACTIVE_AIRCRAFTS == nil then
        trigger.action.outText("DEBUG: Internal Error: showActiveAirplanes(): ACTIVE_AIRCRAFTS == nil" , 2)
        return
    end
    
    local idx = 0
    local len = 0
    local msg = ""

    len = #ACTIVE_AIRCRAFTS
    msg = "Active BLUE Aircrafts: " .. tostring(len) .. "\n"
    
    for idx=1,len do
        local _unit = ACTIVE_AIRCRAFTS[idx]
        if _unit == nil then
            trigger.action.outText("DEBUG: Internal Error: showActiveAirplanes(): unit == nil in ACTIVE_AIRCRAFTS at " .. tostring(idx) , 2)
        end
        msg = msg .. tostring(idx) .. ". " .. _unit:getPlayerName() .. " in " .. _unit:getName() .. "\n"        
    end 

    trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10) 
end

function setAGLThershold(arg)
    if arg == nil then
        trigger.action.outText("DEBUG: Internal Error: setAGLThershold(): arg == nil", 2)
        return
    end

    if arg['Threshold'] == nil then
        trigger.action.outText("DEBUG: Internal Error: setAGLThershold(): arg['Threshold'] == nil", 2)
        return
    end

    AGL_MAX = arg['Threshold']
    local msg = "Set new AGL threshold at " .. AGL_MAX .. " feet"
    trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10)
end

function blueDetected(arg, time)
    if AGL_MAX_PASSED == true then
        trigger.action.setUserFlag("10", true)
    end
    if AA_ZONE_PENETRATED == true then
        trigger.action.setUserFlag("10", true)
    end
end

function showDebugInfo(arg)
    if arg == nil then
        LOG(__FUNC__() .. ": Internal Error: arg == nil", 2)
        return
    end    

    if arg['Mode'] == nil then
        LOG(__FUNC__() .. ": Internal Error: arg['Mode'] == nil", 2)
        return
    end

    local msg = ""
    if arg['Mode'] == 'getUserFlag' then
        msg = "User flags: \n"
        local _flagVal = 0        
        _flagVal = trigger.misc.getUserFlag('10')
        msg = msg .. "Flag 10 = " .. tostring(_flagVal) .. "\n"
        _flagVal = trigger.misc.getUserFlag('11')
        msg = msg .. "Flag 11 = " .. tostring(_flagVal) .. "\n"
        _flagVal = trigger.misc.getUserFlag('13')
        msg = msg .. "Flag 13 = " .. tostring(_flagVal) .. "\n"         
    elseif arg['Mode'] == 'setUserFlag' then
        local _flagName = arg['Flag']
        trigger.action.setUserFlag(_flagName, true)
        msg = "Set user flag " .. _flagName .. " = true"
    end

    if arg['Mode'] == "printPlayers" then
        local _playersTable = coalition.getPlayers(coalition.side.BLUE)
        if _playersTable == nil then
            msg = "coalition.getPlayers() == nil"
        else
            local i
            local len = #_playersTable
            msg = "Players:\n"
            for i=1,len do
                local _unit = _playersTable[i]
                msg = msg .. _unit:getPlayerName() .. " in " .. _unit:getName() .. "\n"
            end
        end
    end

    trigger.action.outText(msg, 5)
end

world.addEventHandler(Event_Handler)
trigger.action.outText("- Event handlers configured", 10)

missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Aircrafts Status', nil, showActiveAirplanes, {['Coalition'] = coalition.side.BLUE})

menuSetAGLThreshold = missionCommands.addSubMenu('Set AGL Threshold...')
missionCommands.addCommandForCoalition(coalition.side.BLUE, '200 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 200})
missionCommands.addCommandForCoalition(coalition.side.BLUE, '400 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 400})
missionCommands.addCommandForCoalition(coalition.side.BLUE, '600 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 600})
missionCommands.addCommandForCoalition(coalition.side.BLUE, '800 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 800})
missionCommands.addCommandForCoalition(coalition.side.BLUE, '1000 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 1000})
missionCommands.addCommandForCoalition(coalition.side.BLUE, '1500 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 1500})
missionCommands.addCommandForCoalition(coalition.side.BLUE, '2000 feet', menuSetAGLThreshold, setAGLThershold, {['Threshold'] = 2000})

menuDebug = missionCommands.addSubMenu('DEBUG...')
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Print players', menuDebug, showDebugInfo, {['Mode'] = 'printPlayers', ['Flag'] = '100'})
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Print user flags', menuDebug, showDebugInfo, {['Mode'] = 'getUserFlag', ['Flag'] = '13'})
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Set User Flag 10 ON', menuDebug, showDebugInfo, {['Mode'] = 'setUserFlag', ['Flag'] = '10'})
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Set User Flag 11 ON', menuDebug, showDebugInfo, {['Mode'] = 'setUserFlag', ['Flag'] = '11'})
missionCommands.addCommandForCoalition(coalition.side.BLUE, 'Set User Flag 13 ON', menuDebug, showDebugInfo, {['Mode'] = 'setUserFlag', ['Flag'] = '13'})


