local crazyZooming = false

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
    makeLuaSprite("temporaryShader")
    makeGraphic("temporaryShader", screenWidth, screenHeight)

    initLuaShader("BlockedGlitchShader")
    setSpriteShader('temporaryShader', "BlockedGlitchShader")

    setShaderFloat('temporaryShader', 'time', 0)
end

function onBeatHit()
    if getProperty('camZooming') and curBeat % 4 == 0 or crazyZooming then
        triggerEvent('Add Camera Zoom', '0.015', '0.03')
    end
end

function onStepHit()
    if curStep == 128 then
        makeLuaSprite('black', 'black', screenWidth-10000, screenHeight - 900)
        scaleObject('black', 10, 10, true)
        if not getModSetting('minimalUI') then
            setObjectOrder('black', getObjectOrder('comboGroup'))
        end
        setProperty('black.alpha', 0)
        addLuaSprite('black', true)

        doTweenAlpha('blackAlpha1', 'black', 0.6, 1)
        setProperty('defaultCamZoom', 0.9)
        cameraFlash('game', 'white', 0.5)
        runHaxeFunction('makeInvisibleNotes', {true})
    elseif curStep == 256 then
        crazyZooming = true
        setProperty('defaultCamZoom', 0.8)
        cameraFlash('game', 'white', 1)
        doTweenAlpha('blackAlpha2', 'black', 0, 1)
        doTweenAlpha('black')
        runHaxeFunction('makeInvisibleNotes', {false})
    elseif curStep == 384 then
        crazyZooming = false
    elseif curStep == 640 then
        cameraFlash('game', 'white', 1)
        setProperty('black.alpha', 0.6)
        setProperty('camHUD.alpha', 0)
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.1)
    elseif curStep == 768 then
        crazyZooming = true
        cameraFlash('game', 'white', 1)
        setProperty('black.alpha', 0)
        setProperty('camHUD.alpha', 1)
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
    elseif curStep == 1028 then
        crazyZooming = false
        runHaxeFunction('makeInvisibleNotes', {true})
    elseif curStep == 1143 then
        runHaxeFunction('makeInvisibleNotes', {false})
    elseif curStep == 1152 then
        doTweenAlpha('blackAlpha3', 'black', 0.4, 1)
        addLuaSprite('black', true)
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.3)
    elseif curStep == 1200 then
        runHaxeCode('game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);')
    elseif curStep == 1216 then
        runHaxeCode("game.camHUD.setFilters([]);")
        crazyZooming = true
        removeLuaSprite('black', true)
        cameraFlash('game', 'white', 0.5)
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 1536 then
        crazyZooming = false
    end
end

function onUpdate(elapsed)
    setShaderFloat('temporaryShader', 'time', getShaderFloat('temporaryShader', 'time') + elapsed)
end