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

function onEvent(event, value1)
    if event == 'eyesores' then
        local toggle = (value1 == 'true' or value1 == '1')
        enablePulse(toggle)
        fadePulse(toggle)
    end
end