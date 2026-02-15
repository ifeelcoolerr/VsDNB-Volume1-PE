function onCreate()
    precacheImage('ui/countdown/normal/ready')
    precacheImage('ui/countdown/normal/set')
    precacheImage('ui/countdown/characters/playrobot/go')
end

function onCountdownTick(swagCounter)
    if swagCounter == 1 then
        makeLuaSprite('ready', 'ui/countdown/normal/ready', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('ready','other');
        doTweenAlpha('slamOneAlpha', 'ready', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownReady.visible', false);
        addLuaSprite('ready', true);
        screenCenter('ready')
	    setProperty('intro3.volume', 0)
    end
    if swagCounter == 2 then
        makeLuaSprite('set', 'ui/countdown/normal/set', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('set','other');
        doTweenAlpha('slamTwoAlpha', 'set', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownSet.visible', false);
        addLuaSprite('set', true);
        screenCenter('set')
    end
    if swagCounter == 3 then
        makeLuaSprite('Go', 'ui/countdown/characters/playrobot/go', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('Go','other');
        doTweenAlpha('slamGoAlpha', 'Go', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownGo.visible', false);
        addLuaSprite('Go', true);
        screenCenter('Go')
    end
end