function onCreate()
    makeLuaSprite('bgBus', 'backgrounds/shared/sky', -600, -880)
    setScrollFactor('bgBus', 0.5, 0.5)
    scaleObject('bgBus', 1.5, 1.5)
    setProperty('bgBus.visible', false)
    addLuaSprite('bgBus')

    makeLuaSprite('hillBus', 'backgrounds/adventure/busstop/hill3', -340, 152)
    setScrollFactor('hillBus', 0.7, 0.7)
    setProperty('hillBus.visible', false)
    addLuaSprite('hillBus')

    makeLuaSprite('neighborhood', 'backgrounds/adventure/busstop/neighborhood', -800, -175)
    setScrollFactor('neighborhood', 0.85, 0.95)
    setProperty('neighborhood.visible', false)
    addLuaSprite('neighborhood')

    makeLuaSprite('sidewalk', 'backgrounds/adventure/busstop/sidewalk', -923, 756)
    setProperty('sidewalk.visible', false)
    addLuaSprite('sidewalk')

    makeAnimatedLuaSprite('marvin', 'backgrounds/adventure/busstop/character_marvin', 171, 466)
    setScrollFactor('marvin', 0.85, 0.95)
    addAnimationByPrefix('marvin', 'start', 'character_marvin_loopstart0')
    addAnimationByPrefix('marvin', 'turn-transition', 'character_marvin_start0', 24, false)
    addAnimationByPrefix('marvin', 'turn', 'character_marvin_loop0')
    playMarvinAnimation('start')
    setProperty('marvin.visible', false)
    addLuaSprite('marvin')
end

function onUpdate(elapsed)
    if getProperty('marvin.animation.curAnim.name') == 'turn-transition' and getProperty('marvin.animation.curAnim.finished') then
        playMarvinAnimation('turn')
    end
end

function playMarvinAnimation(anim)
    if anim == 'start' then
        callMethod('marvin.offset.set', {0, 0})
    elseif anim == 'turn-transition' then
        callMethod('marvin.offset.set', {-3, 0})
    elseif anim == 'turn' then
        callMethod('marvin.offset.set', {-7, 0})
    end
    callMethod('marvin.animation.play', {anim, true})
end