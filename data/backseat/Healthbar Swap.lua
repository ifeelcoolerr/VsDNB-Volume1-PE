local isPlayrobot = false

function onCreate()
    if difficultyName:lower() == 'playrobot' then
        isPlayrobot = true
    end
end

function onUpdatePost(elapsed)
    if not isPlayrobot then return end
    
    runHaxeCode('healthBar.setColors(FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]), FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));')

    local p1X = getProperty('iconP1.x')
    local p1Y = getProperty('iconP1.y')
    local p2X = getProperty('iconP2.x')
    local p2Y = getProperty('iconP2.y')

    setProperty('iconP1.x', p2X)
    setProperty('iconP1.y', p2Y)
    setProperty('iconP2.x', p1X)
    setProperty('iconP2.y', p1Y)

    setProperty('iconP1.flipX', true)
    setProperty('iconP2.flipX', true)

    setProperty('healthBar.leftToRight', true)
end
