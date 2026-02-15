local shakeCam = false
local crazyZooming = false
local targetPulseVal = 1
function onCreatePost()
    makeLuaSprite("temporaryShader")
    makeGraphic("temporaryShader", screenWidth, screenHeight)

    initLuaShader('PulseShader')
    setSpriteShader('temporaryShader', "PulseShader")

    setShaderFloat('temporaryShader', 'uWaveAmplitude', 0)
	setShaderFloat('temporaryShader', 'uFrequency', 1)
	setShaderFloat('temporaryShader', 'uSpeed', 1)
    setShaderFloat('temporaryShader', 'uTime', 0)
    setShaderBool('temporaryShader', 'uEnabled', false)

    createInstance('meme', 'flixel.addons.display.FlxBackdrop', {nil, 0x10})
    loadGraphic('meme', 'backgrounds/daveHouse/MEME')
    callMethod('meme.setPosition', {-50, 275})
    setScrollFactor('meme', 0.2, 0)
    setProperty('meme.alpha', 0)
    runHaxeCode('insert(members.indexOf(getVar("gate")), game.getLuaObject("meme"));')
    addLuaSprite('meme')

    makeAnimatedLuaSprite('cutscene', 'characters/joke/cutscene', 0, 0)
    addAnimationByPrefix('cutscene', 'play', 'bambi', 24, false)
end

local shadname = "PulseShader"

function onBeatHit()
    if getProperty('camZooming') and curBeat % 4 == 0 or crazyZooming then
        triggerEvent('Add Camera Zoom', '0.015', '0.03')
    end
end

function onStepHit()
    if curStep == 15 then
        triggerEvent('Play Animation', 'hey', 'dad')
    elseif curStep == 16 or curStep == 719 or curStep == 1167 then
        setProperty('defaultCamZoom', 1)
    elseif curStep == 80 or curStep == 335 or curStep == 588 or curStep == 1103 then
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 584 or curStep == 1039 then
        setProperty('defaultCamZoom', 1.2)
    elseif curStep == 272 or curStep == 975 then
        setProperty('defaultCamZoom', 1.1)
    elseif curStep == 464 then
        setProperty('defaultCamZoom', 1)
        callMethodFromClass('flixel.tweens.FlxTween', 'linearMotion', {instanceArg('dad'), getProperty('dad.x'), getProperty('dad.y'), 25, -1800, 100, true})
    elseif curStep == 848 then
        fadePulse(false)

        crazyZooming = false
        setProperty('defaultCamZoom', 1)
        doTweenAlpha('memeAlpha1', 'meme', 1, 1)
        setProperty('meme.velocity.y', getProperty('meme.velocity.y')-300)
    elseif curStep == 132 or curStep == 612 or curStep == 740 or curStep == 771 or curStep == 836 then
        enablePulse(true)
        enablePulseAmplitude(true)
        crazyZooming = true
        setProperty('defaultCamZoom', 1.2)
    elseif curStep == 144 or curStep == 624 or curStep == 752 or curStep == 784 then
        fadePulse(false)

        crazyZooming = false
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 1231 then
        setProperty('defaultCamZoom', 0.8)

        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('meme')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('dad')})

        doTweenAlpha('memeAlpha2', 'meme', 0, 1)
        callMethodFromClass('flixel.tweens.FlxTween', 'linearMotion', {instanceArg('dad'), getProperty('dad.x'), getProperty('dad.y'), 50, 300, 1, true})
    end
end

function onUpdatePost(elapsed)
    setShaderFloat('temporaryShader', 'uampmul', 1)
    setShaderFloat('temporaryShader', 'uTime', getShaderFloat('temporaryShader', 'uTime') + elapsed)
end

function enablePulse(toggle)
    local isEnabled = toggle

    if not flashingLights then isEnabled = false end

    if isEnabled then
        runHaxeCode('game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);')
    else
        runHaxeCode("game.camGame.setFilters([]);")
    end
end

function fadePulse(toggle)
    if toggle then
        runHaxeCode([[
            FlxTween.num(0, ]]..targetPulseVal..[[, 2, {}, function(newValue:Float) {
                game.getLuaObject('temporaryShader').shader.setFloat('uWaveAmplitude', newValue);
            });
        ]])
    else
        runHaxeCode([[
            FlxTween.num(]]..targetPulseVal..[[, 0, 1, {}, function(newValue:Float) {
                game.getLuaObject('temporaryShader').shader.setFloat('uWaveAmplitude', newValue);
            });
        ]])
    end
end

function enablePulseAmplitude(enabled)
    setShaderFloat('temporaryShader', 'uWaveAmplitude', enabled and 1 or 0)
end

function onEndSong()
    removeLuaSprite('temporaryShader', true)
    setProperty('defaultCamZoom', 0.8)
end