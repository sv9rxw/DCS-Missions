

local idx = 0
local len = 0

len = #ACTIVE_AIRCRAFTS

local unitNamesToCheck = {}

for idx=1,len do
    local _unit = ACTIVE_AIRCRAFTS[idx]
    if _unit ~= nil then
        table.insert(unitNamesToCheck, _unit:getName())
    end
end

if #unitNamesToCheck > 0 then
    local uTable = mist.getUnitsInZones(unitNamesToCheck, {'AGLThresholdZone'})

    len = #uTable

    local any_unit_above_threshold = false

    for idx=1,len do
        local msg = ""
        --local _unit = ACTIVE_AIRCRAFTS[idx]    
        local _unit = uTable[idx]

        if _unit ~= nil then                        
            local _name = _unit:getPlayerName()
            local _unitAGL = getUnitAGLFeet(_unit) 

            -- Check if unit is in AGL Threshold Zone
            
                    
            if (_unitAGL  > AGL_MAX) then
                if AGL_MAX_PASSED == false then
                    -- schedule detection function
                    timer.scheduleFunction(blueDetected, {}, timer.getTime() + DETECTION_DELAY)
                end                

                any_unit_above_threshold = true
                msg = "SKYKING. AGL WARNING: " .. _name .. " is ABOVE threshold " .. tostring(AGL_MAX) .. " feet at " .. tostring(_unitAGL) .. " feet."            
                trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 1)
                -- msg = "DEBUG: land altitude at unit point = " .. tostring(_landAltFeet) .. " -> unit AGL = " .. tostring(_unitAltFeet - _landAltFeet) .. " feet"
                -- trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 1)             
            end        
        else
            msg = "DEBUG: Internal error: logic.lua: found unit == nil in ACTIVE_AIRCRAFTS at " .. tostring(idx)
            trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 10)
        end
    end

    AGL_MAX_PASSED = any_unit_above_threshold

end

-- Remove references for garbage collector
unitNamesToCheck = nil
uTable = nil