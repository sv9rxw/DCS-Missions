
function setAltitude(arg)
    if (arg == nil) then
        trigger.action.outText("DEBUG: Internal Error: setAltitude(): arg == nil", 10)
    end

    ALTITUDE = arg['altitude']
    ALT_MIN = ALTITUDE - ALT_ERR_DELTA
    ALT_MAX = ALTITUDE + ALT_ERR_DELTA       
end

function setAltitudeErrorDelta(arg)
    if (arg == nil) then
        trigger.action.outText("DEBUG: Internal Error: setAltitudeErrorDelta(): arg == nil", 10)
    end    
    ALT_ERR_DELTA = arg['error_delta']
    ALT_MIN = ALTITUDE - ALT_ERR_DELTA
    ALT_MAX = ALTITUDE + ALT_ERR_DELTA        
end

ALTITUDE = 1000  -- feet
ALT_ERR_DELTA = 100 -- feet
ALT_MAX = ALTITUDE + ALT_ERR_DELTA
ALT_MIN = ALTITUDE - ALT_ERR_DELTA

USER_FLAG_ALT_NAME = '10'
USER_FLAG_ERR_DELTA_NAME = '11'
CUR_USER_FLAG_10 = 0
CUR_USER_FLAG_11 = 0

trigger.action.outText("DEBUG: declared gloval vars", 10)

-- Radio items for desired altitude
altitudeMenu = missionCommands.addSubMenu('Set Altitude...')
--missionCommands.addCommand('Set desired ALTITUDE = 100', mainMenu, setAlitude, {['setting'] = 'trainingSams', ['val'] = 'true'})
missionCommands.addCommand('Set desired ALTITUDE = 100', altitudeMenu, setAltitude, {['altitude'] = 100 })
missionCommands.addCommand('Set desired ALTITUDE = 500', altitudeMenu, setAltitude, {['altitude'] = 500 })
missionCommands.addCommand('Set desired ALTITUDE = 1000', altitudeMenu, setAltitude, {['altitude'] = 1000 })
missionCommands.addCommand('Set desired ALTITUDE = 5000', altitudeMenu, setAltitude, {['altitude'] = 5000 })
missionCommands.addCommand('Set desired ALTITUDE = 10000', altitudeMenu, setAltitude, {['altitude'] = 10000 })
missionCommands.addCommand('Set desired ALTITUDE = 20000', altitudeMenu, setAltitude, {['altitude'] = 20000 })
missionCommands.addCommand('Set desired ALTITUDE = 35000', altitudeMenu, setAltitude, {['altitude'] = 35000 })


--trigger.action.addOtherCommand("Set desired ALTITUDE = 100", USER_FLAG_ALT_NAME, 99)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 500", USER_FLAG_ALT_NAME, 98)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 1000", USER_FLAG_ALT_NAME, 1)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 5000", USER_FLAG_ALT_NAME, 5)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 10000", USER_FLAG_ALT_NAME, 10)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 15000", USER_FLAG_ALT_NAME, 15)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 20000", USER_FLAG_ALT_NAME, 20)
--trigger.action.addOtherCommand("Set desired ALTITUDE = 35000", USER_FLAG_ALT_NAME, 30)

-- Radio items for desired altitude error delta
altitudeErrorDeltaMenu = missionCommands.addSubMenu('Set Altitude Error Delta...')
missionCommands.addCommand('Allow ERROR +/- 10', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 10 })
missionCommands.addCommand('Allow ERROR +/- 20', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 20 })
missionCommands.addCommand('Allow ERROR +/- 50', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 50 })
missionCommands.addCommand('Allow ERROR +/- 100', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 100 })
missionCommands.addCommand('Allow ERROR +/- 200', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 200 })
missionCommands.addCommand('Allow ERROR +/- 500', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 500 })
missionCommands.addCommand('Allow ERROR +/- 1000', altitudeErrorDeltaMenu, setAltitudeErrorDelta, {['error_delta'] = 1000 })


--trigger.action.addOtherCommand("Set Altitude Error Delta = 10", USER_FLAG_ERR_DELTA_NAME, 1)
--trigger.action.addOtherCommand("Set Altitude Error Delta = 20", USER_FLAG_ERR_DELTA_NAME, 2)
--trigger.action.addOtherCommand("Set Altitude Error Delta = 50", USER_FLAG_ERR_DELTA_NAME, 5)
--trigger.action.addOtherCommand("Set Altitude Error Delta = 100", USER_FLAG_ERR_DELTA_NAME, 10)
--trigger.action.addOtherCommand("Set Altitude Error Delta = 500", USER_FLAG_ERR_DELTA_NAME, 50)

trigger.action.outText("DEBUG: added radio items", 10)
