-- very crazy coding here
local crazyZooming = false
local playerIsBF = false
local targetPulseVal = 1
luaDebugMode = true
function onCreate()
    addCharacterToList('bf-3d-polygonized', 'bf')
    addCharacterToList('gf-3d', 'gf')
    addCharacterToList('dave-polygonized-end', 'dad')

    precacheImage('backgrounds/shared/sky_night')
    precacheImage('backgrounds/daveHouse/night/hills')
    precacheImage('backgrounds/daveHouse/night/grass bg')
    precacheImage('backgrounds/daveHouse/night/gate')
    precacheImage('backgrounds/daveHouse/night/grass')
end

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

runHaxeCode([[
    function regenerateStaticArrows(player:Int, fadeIn = true)
	{
		switch (player)
		{
			case 0:
				opponentStrums.forEach(function(spr:StrumNote)
				{
					opponentStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
			case 1:
				playerStrums.forEach(function(spr:StrumNote)
				{
					playerStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
		}
		generateStaticArrows(player, false, fadeIn);
	}
]])

function doShit()
    makeLuaSprite('abg', 'backgrounds/shared/sky_night', -600, -300)
    setScrollFactor('abg', 0.5, 0.5)
    addLuaSprite('abg')

    makeLuaSprite('astagehills', 'backgrounds/daveHouse/night/hills', -834, -59)
    setScrollFactor('astagehills', 0.4, 0.4)
    addLuaSprite('astagehills')

    makeLuaSprite('agrassbg', 'backgrounds/daveHouse/night/grass bg', -1205, 580)
    addLuaSprite('agrassbg')

    makeLuaSprite('agate', 'backgrounds/daveHouse/night/gate', -695, 380)
    setScrollFactor('agate', 0.65, 0.65)
    addLuaSprite('agate')

    makeLuaSprite('astagefront', 'backgrounds/daveHouse/night/grass', -832, 705)
    addLuaSprite('astagefront')

    runHaxeFunction('regenerateStaticArrows', {0, true})

    local objects = {
        'boyfriend',
        'gf',
        'dad',
        'astagehills',
        'agrassbg',
        'agate',
        'astagefront'
    }
    local color = getColorFromHex('51557A')

    for i = 1, #objects do
        setProperty(objects[i]..'.color', color)
    end

    -- change !!
    loadGraphic('alarmClock', 'ui/timer')
    scaleObject('alarmClock', 1, 1)
    screenCenter('alarmClock', 'x')
    setProperty('alarmClock.antialising', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
end

function onBeatHit()
    if getProperty('camZooming') and curBeat % 4 == 0 or crazyZooming then
        triggerEvent('Add Camera Zoom', '0.015', '0.03')
    end
end

function onSongStart()
    if boyfriendName == 'bf' then
        playerIsBF = true
    else
        playerIsBF = false
    end

    if boyfriendName ~= 'bf-3d' then
        setPropertyFromClass('states.PlayState', 'stageUI', 'normal')
    end
end

local shakeCam = false

function onUpdate(elapsed)
    if shakeCam and flashingLights then
        cameraShake('game', 0.010, 0.010)
    end
end

function onStepHit()
    if curStep == 128 or curStep == 640 or curStep == 704 or curStep == 1535 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 256 or curStep == 768 or curStep == 1468 or curStep == 1596 or curStep == 2048 or curStep == 2144 or curStep == 2428 then
        setProperty('defaultCamZoom', 0.7)
    elseif curStep == 688 or curStep == 752 or curStep == 1279 or curStep == 1663 or curStep == 2176 then
        setProperty('defaultCamZoom', 1)
    elseif curStep == 1019 or curStep == 1471 or curStep == 1599 or curStep == 2064 then
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 1920 then
        setProperty('defaultCamZoom', 1.1)
    elseif curStep == 1024 or curStep == 1312 then
        crazyZooming = true
        shakeCam = true
        setProperty('defaultCamZoom', 1.1)
        enablePulse(true)
        fadePulse(true)
        if playerIsBF == true then
            setPropertyFromClass('states.PlayState', 'stageUI', 'ui/3D')
            triggerEvent('Change Character', 'BF', 'bf-3d-polygonized')
            triggerEvent('Change Character', 'GF', 'gf-3d')
        end
    elseif curStep == 1152 or curStep == 1408 then
        shakeCam = false
        setProperty('defaultCamZoom', 0.9)
        crazyZooming = false
        enablePulse(false)
        fadePulse(false)
        if playerIsBF == true then
            setPropertyFromClass('states.PlayState', 'stageUI', 'normal')
            triggerEvent('Change Character', 'BF', 'bf')
            triggerEvent('Change Character', 'GF', 'gf')
        end
    end
end

function onBeatHit()
    if curBeat == 608 then
        doTweenAlpha('bgalpha', 'bg', 0.0, 1, 'linear')
        cameraFlash('game', 'white', 1)
        setProperty('defaultCamZoom', 0.8)
        triggerEvent('Hey!', 'Both', '10')
        triggerEvent('Change Character', 'Dad', 'dave-polygonized-end')
        triggerEvent('Play Animation', 'polygonevent', 'Dad')
        callMethod('dad.setPosition', {150, 290})
        callMethod('boyfriend.setPosition', {960, 460})
        callMethod('gf.setPosition', {400, 130})
    end

    if curBeat == 608 then
        doShit()
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