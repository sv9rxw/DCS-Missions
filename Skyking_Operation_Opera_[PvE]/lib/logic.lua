--[[
    Check mission constraints. Is relevant only when airplanes
    are in AGL threshold zone - outside Isreal and before target zone.

]]

local _userFlagValue = trigger.misc.getUserFlag(DETECTION_USER_FLAG_NAME)

if _userFlagValue == 0 then
    local idx = 0
    local len = 0
                
    local _activePlayerUnits = coalition.getPlayers(coalition.side.BLUE)
    local _activePlayerUnitNames = nil
    if _activePlayerUnits ~= nil then        
        if #_activePlayerUnits > 0 then            
            _activePlayerUnitNames = {}    
            for i=1,#_activePlayerUnits do
                table.insert(_activePlayerUnitNames, _activePlayerUnits[i]:getName())
            end

            if #_activePlayerUnitNames > 0 then                          
                local _uTable = mist.getUnitsInZones(_activePlayerUnitNames, {'AGLThresholdZone'})
                len = #_uTable
            
                -- Check if any player airplane is violating mission constraints
                local any_unit_above_threshold = false    
                local any_unit_in_air_defence_zones = false
                for idx=1,len do
                    local msg = ""            
                    local _unit = _uTable[idx]
            
                    if _unit ~= nil then                        
                        local _name = _unit:getPlayerName()
                        local _unitAGL = getUnitAGLFeet(_unit) 
            
                        -- Check if unit is above AGL threshold                                        
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

                        -- Check if unit is in any air defence zone
                        if unitIsInZone(_unit, 'RedAispaceEast') == true then
                            if AA_ZONE_PENETRATED == false then
                                timer.scheduleFunction(blueDetected, {}, timer.getTime() + DETECTION_DELAY)
                            end                                        
                            any_unit_in_air_defence_zones = true
                            msg = "SKYKING. COURSE WARNING: " .. _unit:getPlayerName() .. " you are very deep in eastern enemy air defence zone. Go back to your course."
                            trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 1)
                            timer.scheduleFunction(blueDetected, {}, timer.getTime() + DETECTION_DELAY)    
                        end

                        if unitIsInZone(_unit, 'RedAispaceWest') == true then
                            if AA_ZONE_PENETRATED == false then
                                timer.scheduleFunction(blueDetected, {}, timer.getTime() + DETECTION_DELAY)
                            end                                        
                            any_unit_in_air_defence_zones = true
                            msg = "SKYKING. COURSE WARNING: " .. _unit:getPlayerName() .. " you are very deep in western enemy air defence zone. Go back to your course."
                            trigger.action.outTextForCoalition(coalition.side.BLUE, msg, 1)
                            timer.scheduleFunction(blueDetected, {}, timer.getTime() + DETECTION_DELAY)    
                        end                

                    else
                        msg = "DEBUG: Internal error: " .. __FUNC__() .. ": found unit == nil in uTable at " .. tostring(idx)
                        LOG(msg)
                        MSG(msg)
                    end
                end
            
                AGL_MAX_PASSED = any_unit_above_threshold
                AA_ZONE_PENETRATED = any_unit_in_air_defence_zones       
                
                _uTable = nil
            end
        else
            LOG("#ACTIVE_AIRCRAFT_NAMES == 0")
        end           
    else
        LOG("ACTIVE_AIRCRAFTS == nil")
    end  
    
    _activePlayerUnits = nil
    _activePlayerUnitNames = nil
end    
