function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

local focusOnBF = false

function onSectionHit()
    if focusOnBF then
        cameraSetTarget('bf')
    end
end

function onStepHit()
    local transitionTime = (stepCrochet / 1000) * 224

    if curStep == 1600 then
        focusOnBF = true
        runTimer('camOff', 0)
        doTweenColor('healthBarColor1', 'healthBar.leftBar', rgbToHex(getProperty("boyfriend.healthColorArray")), transitionTime)
        doTweenColor('timerColor1', 'timer', rgbToHex(getProperty("boyfriend.healthColorArray")), transitionTime)
    end

    if curStep == 2324 then
        doTweenColor('healthBarColor2', 'healthBar.leftBar', rgbToHex(getProperty("dad.healthColorArray")), 1)
        doTweenColor('timerColor2', 'timer', rgbToHex(getProperty("dad.healthColorArray")), 1)
    end
end