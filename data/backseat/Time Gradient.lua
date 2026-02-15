function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function onCreatePost()
    if getProperty('timer') ~= nil then
        setProperty('timer.color', FlxColor('WHITE'))
        callMethodFromClass('flixel.util.FlxGradient', 'overlayGradientOnFlxSprite', {instanceArg('timer'), getProperty('timer.width'), getProperty('timer.height'), {getColorFromHex('ffc300'), getColorFromHex('ff130f')}, 1, 0, 1, 90})
    end
end