

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

    for idx=1,len do
        local msg = ""
        --local _unit = ACTIVE_AIRCRAFTS[idx]    
        local _unit = uTable[idx]

        if _unit ~= nil then                        
            local _name = _unit:getPlayerName()
            local _unitAGL = getUnitAGLFeet(_unit) 

            -- Check if unit is in AGL Threshold Zone
            
                    
            if (_unitAGL  > AGL_MAX) then
                AGL_MAX_PASSED = true
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

end

-- Remove references for garbage collector
unitNamesToCheck = nil
uTable = nil