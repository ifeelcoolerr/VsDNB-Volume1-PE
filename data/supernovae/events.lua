luaDebugMode = true
local shakeCam = false
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
end

function onBeatHit()
    if getProperty('camZooming') and curBeat % 4 == 0 or crazyZooming then
        triggerEvent('Add Camera Zoom', '0.015', '0.03')
    end
end

local shadname = "PulseShader"

function onStepHit()
    if curStep == 60 then
        triggerEvent('Play Animation', 'hey', 'dad')
    elseif curStep == 64 then
        setProperty('defaultCamZoom', 1)
    elseif curStep == 192 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 320 or curStep == 768 then
        setProperty('defaultCamZoom', 1.1)
    elseif curStep == 444 then
        setProperty('defaultCamZoom', 0.6)
    elseif curStep == 448 or curStep == 960 or curStep == 1344 then
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 896 or curStep == 1152 then
        setProperty('defaultCamZoom', 1.2)
    elseif curStep == 1024 then
        setProperty('defaultCamZoom', 1)
        if flashingLights then
            cameraShake('game', 0.010, 24 / playbackRate)
        end
        enablePulse(true)
        enablePulseAmplitude(true)
        callMethodFromClass('flixel.tweens.FlxTween', 'linearMotion', {instanceArg('dad'), getProperty('dad.x'), getProperty('dad.y'), 25, -50, 75, true})
    elseif curStep == 1280 then
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('dad')})
        callMethodFromClass('flixel.tweens.FlxTween', 'linearMotion', {instanceArg('dad'), getProperty('dad.x'), getProperty('dad.y'), 50, 280, 50, true})

        fadePulse(false)
        setProperty('defaultCamZoom', 1)
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