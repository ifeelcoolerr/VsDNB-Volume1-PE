function onCountdownTick(swagCounter)
    if swagCounter == 1 then
        makeLuaSprite('ready', 'ui/countdown/evil/ready', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('ready','other');
        doTweenAlpha('slamOneAlpha', 'ready', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownReady.visible', false);
        addLuaSprite('ready', true);
        screenCenter('ready')
	    setProperty('intro3.volume', 0)
    end
    if swagCounter == 2 then
        makeLuaSprite('set', 'ui/countdown/evil/set', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('set','other');
        doTweenAlpha('slamTwoAlpha', 'set', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownSet.visible', false);
        addLuaSprite('set', true);
        screenCenter('set')
    end
    if swagCounter == 3 then
        makeLuaSprite('Go', 'ui/countdown/evil/go', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('Go','other');
        doTweenAlpha('slamGoAlpha', 'Go', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownGo.visible', false);
        addLuaSprite('Go', true);
        screenCenter('Go')
    end
end

function onCreate()
	makeLuaSprite('bg', 'backgrounds/exbungo/Exbongo', -320, -160);
	runHaxeCode('getLuaObject("bg").setGraphicSize(Std.int(getLuaObject("bg").width * 1.5));')
	addLuaSprite('bg', false)

    makeLuaSprite('circle', 'backgrounds/exbungo/Circle', -30, 550)
    addLuaSprite('circle')

    makeLuaSprite('place', 'backgrounds/exbungo/Place', 860, -15)
    addLuaSprite('place')

    makeLuaSprite('hell', 'backgrounds/exbungo/HELL', 0, 0)
    setScrollFactor('hell', 0, 0)
    scaleObject('hell', 1.5, 1.5)
    screenCenter('hell')
    setObjectOrder('hell', getObjectOrder('bg'))
    addLuaSprite('hell')
end

local shadname = "FLAG"

function onCreatePost()
	initLuaShader("FLAG")
	setSpriteShader('bg', shadname)
end

local elapsedtime = 0
	
function onUpdate(elapsed)
    elapsedtime = elapsedtime + elapsed
	setShaderFloat('bg', 'uWaveAmplitude', 0.1)
	setShaderFloat('bg', 'uFrequency', 5)
	setShaderFloat('bg', 'uSpeed', 2)

    setProperty('place.y', math.sin(elapsedtime)*0.4)
end

function onUpdatePost(elapsed)
	setShaderFloat('bg', 'uTime', os.clock())
end