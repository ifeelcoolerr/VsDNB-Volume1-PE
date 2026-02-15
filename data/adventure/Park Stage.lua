function onCreate()
    makeLuaSprite('bgPark', 'backgrounds/shared/sky_sunset', -600, -880)
    setScrollFactor('bgPark', 0.5, 0.5)
    scaleObject('bgPark', 1.5, 1.5)
    setProperty('bgPark.visible', false)
    addLuaSprite('bgPark')

    makeLuaSprite('buildings', 'backgrounds/adventure/park/buildingsback', -370, -180)
    setScrollFactor('buildings', 0.7, 0.9)
    setProperty('buildings.visible', false)
    addLuaSprite('buildings')

    makeLuaSprite('hillPark', 'backgrounds/adventure/park/hill4', -425, 300)
    setScrollFactor('hillPark', 0.8, 0.9)
    setProperty('hillPark.visible', false)
    addLuaSprite('hillPark')

    makeLuaSprite('park', 'backgrounds/adventure/park/bgpark', -556, -534)
    setProperty('park.visible', false)
    addLuaSprite('park')

    makeAnimatedLuaSprite('fountain', 'backgrounds/adventure/park/fountain', 786, 413)
    addAnimationByPrefix('fountain', 'loop', 'fountainfull')
    playAnim('fountain', 'loop')
    setProperty('fountain.visible', false)
    addLuaSprite('fountain')

    makeAnimatedLuaSprite('memesKid', 'backgrounds/adventure/park/character_memeskidshander', 800, 581)
    addAnimationByPrefix('memesKid', 'idle', 'character_memeskidshander')
    playAnim('memesKid', 'idle', true)
    setProperty('memesKid.visible', false)
    addLuaSprite('memesKid')

    makeAnimatedLuaSprite('david', 'backgrounds/adventure/park/character_davidjanett', 1592, 516)
    addAnimationByPrefix('david', 'idle', 'character_davidjanett')
    playAnim('david', 'idle')
    setProperty('david.visible', false)
    addLuaSprite('david')

    makeAnimatedLuaSprite('dane', 'backgrounds/adventure/park/character_dane', 1711, 331)
    addAnimationByPrefix('dane', 'idle', 'character_dane')
    playAnim('dane', 'idle')
    setProperty('dane.visible', false)
    addLuaSprite('dane')

    createMovingChars()
end

function createMovingChars()
    createInstance('movingChars', 'flixel.group.FlxTypedSpriteGroup', {})
    setProperty('movingChars.y', 700)
    setProperty('movingChars.visible', false)
    callMethod('add', {instanceArg('movingChars')})

    makeAnimatedLuaSprite('maldoMuko', 'backgrounds/adventure/park/character_maldomuko', 0, 0)
    addAnimationByPrefix('maldoMuko', 'idle', 'character_mukomaldo', 24, true)
    scaleObject('maldoMuko', 2, 2)
    playAnim('maldoMuko', 'idle')
    callMethod('movingChars.add', {instanceArg('maldoMuko')})

    makeAnimatedLuaSprite('juanCarl', 'backgrounds/adventure/park/character_juancarl', 3000, 0)
    addAnimationByPrefix('juanCarl', 'idle', 'juancarl', 24, true)
    scaleObject('juanCarl', 2, 2)
    playAnim('juanCarl', 'idle')
    callMethod('movingChars.add', {instanceArg('juanCarl')})

    makeAnimatedLuaSprite('juanCarl', 'backgrounds/adventure/park/character_juancarl', 3000, 0)
    addAnimationByPrefix('juanCarl', 'idle', 'juancarl', 24, true)
    scaleObject('juanCarl', 2, 2)
    playAnim('juanCarl', 'idle')
    callMethod('movingChars.add', {instanceArg('juanCarl')})

    makeAnimatedLuaSprite('diamondRuby', 'backgrounds/adventure/park/character_diamondrubyman', 6000, 0)
    addAnimationByPrefix('diamondRuby', 'idle', 'character_diamondrubyman', 24, true)
    scaleObject('diamondRuby', 2, 2)
    playAnim('diamondRuby', 'idle')
    callMethod('movingChars.add', {instanceArg('diamondRuby')})
end

function initalizeMovingChars()
    setProperty('movingChars.x', 700)
    setProperty('movingChars.velocity.x', -200)
end