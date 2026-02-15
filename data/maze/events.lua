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

function onCreatePost()
    if isStoryMode then
        setHealth(getHealth()-0.2)
    end
end

function onStepHit()
    if curStep == 466 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.2)
        makeLuaSprite('black', 'black', screenWidth-10000, screenHeight - 900)
        scaleObject('black', 10, 10, true)
        if not getModSetting('minimalUI') then
            setObjectOrder('black', getObjectOrder('comboGroup'))
        end
        setProperty('black.alpha', 0)
        doTweenAlpha('blackALpha', 'black', 0.6, 1)
        addLuaSprite('black', true)
        runHaxeFunction('makeInvisibleNotes', {true})
    elseif curStep == 510 then
        runHaxeFunction('makeInvisibleNotes', {false})
    elseif curStep == 528 then
        setProperty('defaultCamZoom', 0.8)
        setProperty('black.alpha', 0)
        cameraFlash('game', 'white', 1)
    elseif curStep == 832 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.2)
        doTweenAlpha('blackAlpha2', 'black', 0.4, 1)
    elseif curStep == 838 then
        runHaxeFunction('makeInvisibleNotes', {true})
    elseif curStep == 902 then
        runHaxeFunction('makeInvisibleNotes', {false})
    elseif curStep == 908 then
        doTweenAlpha('blackAlpha99', 'black', 0.4, (stepCrochet/1000)*4)
    elseif curStep == 912 then
        doTweenAlpha('blackAlpha11', 'black', 0.6, 1)
    elseif curStep == 1168 then
        doTweenAlpha('blackAlpha10', 'black', 0, 1)
    elseif curStep == 1232 then
        cameraFlash('game', 'white', 1)
    end
end