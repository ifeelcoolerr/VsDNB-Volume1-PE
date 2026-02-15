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

function onUpdate(elapsed)
    if curStep == 128 then
        setProperty('defaultCamZoom', 0.7)
    elseif curStep == 252 or curStep == 512 then
        setProperty('defaultCamZoom', 0.4)
        enablePulse(false)
        fadePulse(false)
    elseif curStep == 256 then
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 380 then
        setProperty('defaultCamZoom', 0.5)
    elseif curStep == 384 then
        setProperty('defaultCamZoom', 1)
        enablePulse(true)
        fadePulse(true)
    elseif curStep == 508 then
        setProperty('defaultCamZoom', 1.2)
    elseif curStep == 560 then
        triggerEvent('Play Animation', 'die', 'dad')
        playSound('dead', 1)
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
