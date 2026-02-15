function onCreate()
    makeLuaSprite('school', 'backgrounds/adventure/school/bgschool', -650, -420)
    setProperty('school.visible', false)
    addLuaSprite('school')

    makeAnimatedLuaSprite('spike', 'backgrounds/adventure/school/character_spike', 711.7, 396.15)
    addAnimationByPrefix('spike', 'idle', 'spikebro', 24, false)
    playAnim('spike', 'idle')
    setProperty('spike.visible', false)
    addLuaSprite('spike')

    makeAnimatedLuaSprite('tighthead', 'backgrounds/adventure/school/character_tighthead', 1621, 522)
    addAnimationByPrefix('tighthead', 'idle', 'Tighthead')
    playAnim('tighthead', 'idle')
    setProperty('tighthead.visible', false)
    addLuaSprite('tighthead')

    makeAnimatedLuaSprite('bullyBoy', 'backgrounds/adventure/school/character_bullyboy', 843, 285)
    addAnimationByPrefix('bullyBoy', 'mad', 'bullyboymad')
    playAnim('bullyBoy', 'mad')
    setProperty('bullyBoy.visible', false)
    addLuaSprite('bullyBoy')

    makeAnimatedLuaSprite('kevin', 'backgrounds/adventure/school/character_kevin', 54, 579)
    addAnimationByPrefix('kevin', 'idle', 'kevin', 24, false)
    playAnim('kevin', 'idle')
    setProperty('kevin.visible', false)
    addLuaSprite('kevin')

    makeAnimatedLuaSprite('ezekiel', 'backgrounds/adventure/school/character_ezekiel', 1939, 575)
    addAnimationByPrefix('ezekiel', 'idle', 'ezekielbg')
    scaleObject('ezekiel', 2, 2)
    playAnim('ezekiel', 'idle')
    setProperty('ezekiel.visible', false)
    addLuaSprite('ezekiel')
end

function onBeatHit()
    if curBeat % 2 == 0 then
        playAnim('spike', 'idle', true)
        playAnim('kevin', 'idle', true)
    end
end

function playBullyboySlide()
    setProperty('bullyBoy.visible', true)
    setProperty('bullyBoy.alpha', 0.001)
    doTweenAlpha('bullyBoyAlpha', 'bullyBoy', 1, 0.5)
end