
function onCountdownStarted()
    loadGraphic('healthBar.bg', 'ui/bars/fnfengine')
	if inGameOver == false then
		for i=0,4,1 do
			setPropertyFromGroup('opponentStrums', i, 'texture', 'noteSkins/OMGtop10awesomehi')
		end
		for i = 0, getProperty('unspawnNotes.length')-1 do
			if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteSkins/OMGtop10awesomehi'); --Change texture
			end
		end
	end
end

function onCreate()
    setProperty('gf.alpha', 0)
    createInstance('stfu', 'objects.BGSprite', {nil, -583, -383})
    loadGraphic('stfu', 'backgrounds/stfu')
    addLuaSprite('stfu')
end

function onUpdatePost()
    setProperty('timer.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('timerBG.visible', false)
    setProperty('alarmClock.visible', false)

    setTextFont('accuracyText', 'ariblk.ttf')
    setTextFont('missesText', 'ariblk.ttf')
    setTextFont('scoreText', 'ariblk.ttf')
end

function onCountdownTick(swagCounter)
    if swagCounter == 1 then
        makeLuaSprite('ready', 'ui/countdown/top10/ready', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('ready','other');
        doTweenAlpha('slamOneAlpha', 'ready', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownReady.visible', false);
        addLuaSprite('ready', true);
        screenCenter('ready')
	    setProperty('intro3.volume', 0)
    end
    if swagCounter == 2 then
        makeLuaSprite('set', 'ui/countdown/top10/set', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('set','other');
        doTweenAlpha('slamTwoAlpha', 'set', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownSet.visible', false);
        addLuaSprite('set', true);
        screenCenter('set')
    end
    if swagCounter == 3 then
        makeLuaSprite('Go', 'ui/countdown/top10/go', screenWidth / 2 - 279, screenHeight / 2 - 215);
        setObjectCamera('Go','other');
        doTweenAlpha('slamGoAlpha', 'Go', 0, crochet / 1000, 'cubeInOut');
        setProperty('countdownGo.visible', false);
        addLuaSprite('Go', true);
        screenCenter('Go')
    end
end

function onTweenCompleted(tag)
    if tag == 'slamGoAlpha' then
        removeLuaSprite('Go', true);
    elseif tag == 'slamTwoAlpha' then
        removeLuaSprite('set', true);
    elseif tag == 'slamOneAlpha' then
        removeLuaSprite('ready', true);
    elseif tag == 'slam3Alpha' then
        removeLuaSprite('3', true);
    end
end

