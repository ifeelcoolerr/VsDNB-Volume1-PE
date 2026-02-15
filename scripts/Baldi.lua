luaDebugMode = true
function onCreatePost()
    if getRandomInt(0, 5) == 5 then
        if songName:lower() == 'blocked' or songName:lower() == 'corn-theft' or songName:lower() == 'maze' then
            setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

            makeLuaSprite('baldi', 'backgrounds/farm/baldo', 495, 70)
            setScrollFactor('baldi', 0.55, 0.55)
            scaleObject('baldi', 0.31, 0.31)
            updateHitbox('baldi')
        
            setObjectOrder('baldi', getObjectOrder('flatgrass')+1)
        
            addLuaSprite('baldi')
        end
    end
end

function onUpdate(elapsed)
    if getProperty('baldi') ~= nil then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

        if callMethodFromClass('flixel.FlxG', 'mouse.overlaps', {instanceArg('baldi')}) and mouseClicked() then
            loadSong('MathGameState', 1)
        end
    end
end
