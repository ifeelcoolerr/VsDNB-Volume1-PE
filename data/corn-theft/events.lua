luaDebugMode = true
runHaxeCode([[
    function makeInvisibleNotes(invisible:Bool)
	{
		if (invisible)
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 0}, 1);
			}
		}
		else
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 1}, 1);
			}
		}
	}
]])

function onStepHit()
    if curStep == 668 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 784 then
        setProperty('defaultCamZoom', 1)
    elseif curStep == 848 then
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 916 then
        cameraFlash('game', 'white', 0.5, true)
    elseif curStep == 935 then
        setProperty('defaultCamZoom', 1)
        makeLuaSprite('black', 'black', screenWidth-10000, screenHeight - 900)
        scaleObject('black', 10, 10, true)
        if not getModSetting('minimalUI') then
            setObjectOrder('black', getObjectOrder('comboGroup'))
        end
        setProperty('black.alpha', 0)
        doTweenAlpha('blackAlpha', 'black', 0.6, 1)
        addLuaSprite('black', true)
        runHaxeFunction('makeInvisibleNotes', {true})
    elseif curStep == 1033 then
        startTween('gameBruh', 'game', {defaultCamZoom = getProperty('defaultCamZoom') + 0.2}, (stepCrochet / 1000) * 6)
        doTweenAlpha('dadAlpha', 'dadGroup', 0, (stepCrochet / 1000) * 6)
        doTweenAlpha('blackAlpha', 'black', 0, (stepCrochet / 1000) * 6)
        runHaxeFunction('makeInvisibleNotes', {false})
    elseif curStep == 1040 then
        setProperty('defaultCamZoom', 0.8)
        setProperty('dad.alpha', 1)
        removeLuaSprite('black', true)
        cameraFlash('game', 'white', 0.5, true)
    end
end

function onTweenCompleted(tag)
    if tag == 'gameing' then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.2)
    end
end