luaDebugMode = true

local nightColor = '51557A'

function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function onCreate()
    addCharacterToList('dave-splitathon-calm', 'dad')
    addCharacterToList('bambi-splitathon', 'dad')
    triggerEvent('Change Character', 'dad', 'dave-splitathon-calm')
    setProperty('dad.color', getColorFromHex(nightColor))
end

function onSectionHit()
    if focusOnGF then
        cameraSetTarget('gf')
    end
end

function onStepHit()
    if curStep == 384 or curStep == 6288 then
        triggerEvent('Change Character', 'dad', 'dave-splitathon')
        setProperty('dadGroup.color', getColorFromHex(nightColor))
    elseif curStep == 2976 then
        triggerEvent('Change Character', 'dad', 'dave-splitathon-calm')
    elseif curStep == 3232 then
        triggerEvent('Change Character', 'dad', 'dave-splitathon')
    elseif curStep == 6800 or curStep == 8116 then
        triggerEvent('Change Character', 'dad', 'dave-splitathon-calm')
        setProperty('dadGroup.color', getColorFromHex(nightColor))
    elseif curStep == 4096 then
        triggerEvent('Change Character', 'dad', 'bambi-splitathon')
        setProperty('dadGroup.color', getColorFromHex(nightColor))
    elseif curStep == 6928 then
        triggerEvent('Change Character', 'dad', 'dave-splitathon')
        if getProperty('timer') ~= nil then
            setProperty('timer.color', FlxColor('WHITE'))
            callMethodFromClass('flixel.util.FlxGradient', 'overlayGradientOnFlxSprite', {instanceArg('timer'), getProperty('timer.width'), getProperty('timer.height'), {getColorFromHex('00B515'), getColorFromHex('4965FF')}, 1, 0, 1, 90})
        end
    elseif curStep == 7696 then
        if getProperty('timer') ~= nil then
            callMethodFromClass('flixel.util.FlxGradient', 'overlayGradientOnFlxSprite', {instanceArg('timer'), getProperty('timer.width'), getProperty('timer.height'), {FlxColor('WHITE')}, 1, 0, 1, 90})
            setProperty('timer.color', FlxColor('#'..rgbToHex(getProperty("dad.healthColorArray"))..''))
        end
        runTimer('camOff', 0)
        focusOnGF = true
    elseif curStep == 7714 then
        runTimer('camOn', 0)
        focusOnGF = false
    end
end