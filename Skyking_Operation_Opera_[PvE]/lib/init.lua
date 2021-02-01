AGL_MAX = 800  -- feet
AGL_MAX_PASSED = false
DETECTION_DELAY = 30 -- seconds
DETECTION_USER_FLAG_NAME = "10"

BLUE_COMMAND_GROUP = nil
BLUE_COMMAND_GROUP_NAME = "Cmd"

ACTIVE_AIRCRAFTS = {} -- table of active aircrafts
AGL_THRESHOLD_ZONES = {'AGLThresholdZone'}

function activeRemove(u)
    local len = 0
    local temp = nil
    if ACTIVE_AIRCRAFTS ~= nil then
        len = #ACTIVE_AIRCRAFTS
        local i = 0
        for i=1,len do
            temp = ACTIVE_AIRCRAFTS[i]
            if u:getName() == temp:getName() then
                table.remove(ACTIVE_AIRCRAFTS, i)
                return true
            end
        end
    end
    return false
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


trigger.action.outText("- Gloval variables initialized", 10)

Event_Handler = {}
function Event_Handler:onEvent(event)
    local _unit = event.initiator
    local msg = ""
    local status = false

    if event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then                
        -- trigger.action.outTextFor_unit:getCoalition(), "Player " .. _unit:getPlayerName() .. " entered unit " .. _unit:getName() .. " at " .. tostring(event.time), 10)        
        if _unit:getCoalition() == coalition.side.BLUE then
            table.insert(ACTIVE_AIRCRAFTS, _unit)
            msg = "Player " .. _unit:getPlayerName() .. " entered unit " .. _unit:getName() .. " at " .. tostring(event.time)
            trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10)   
            local num_active = #ACTIVE_AIRCRAFTS
            trigger.action.outTextForCoalition(coalition.side.BLUE, tostring(num_active) .. " active aircrafts for BLUEFOR", 10)                     
        end
    elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then
        if _unit:getCoalition() == coalition.side.BLUE then
            status = activeRemove(_unit)
            if status == true then
                msg = "Player " .. _unit:getPlayerName() .. " left unit " .. _unit:getName() .. " at " .. tostring(event.time)
            else
               -- msg = "DEBUG: Internal Error: _unit not found in ACTIVE_AIRCRAFTS table"
            end
            trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10)                        
            local num_active = #ACTIVE_AIRCRAFTS
            trigger.action.outTextForCoalition(coalition.side.BLUE, tostring(num_active) .. " active aircrafts for BLUEFOR", 10)
        end     
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
    msg = "Set new AGL threshold at " .. AGL_MAX .. " feet"
    trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10)
end

function blueDetected(arg, time)
    if AGL_MAX_PASSED == true then
        trigger.action.setUserFlag("10", true)
    end
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

