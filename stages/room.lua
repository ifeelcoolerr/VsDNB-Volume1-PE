function onCreate()
    setProperty('gf.alpha', 0)
    
    makeLuaSprite('bg', 'backgrounds/shared/sky', 1300, 0)
    setScrollFactor('bg', 0.5, 0.5)
    scaleObject('bg', 0.25, 0.25)
    addLuaSprite('bg')

    makeLuaSprite('hill', 'backgrounds/adventure/room/hill2', 1305, 380)
    setScrollFactor('hill', 1.1, 1.1)
    addLuaSprite('hill')

    makeLuaSprite('room', 'backgrounds/adventure/room/tristanroom', -200, -35)
    addLuaSprite('room')

    makeLuaSprite('tv', 'backgrounds/tristanBackseat/tv_bg', 1600, 1425)
    setScrollFactor('tv', 1.5, 1.5)
    addLuaSprite('tv')
end