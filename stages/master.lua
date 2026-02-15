function onCreate()
    makeLuaSprite('space', 'backgrounds/shared/sky_space', -1724, -971)
    setScrollFactor('space', 0.8, 0.8)
    callMethod('space.setGraphicSize', {callMethodFromClass('Std', 'int', {getProperty('space.width') * 10})})
    setProperty('space.antialiasing', false)
    addLuaSprite('space')

    makeLuaSprite('land', 'backgrounds/daveHouse/land', 675, 555)
    addLuaSprite('land')
end
