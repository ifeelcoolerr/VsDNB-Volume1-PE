luaDebugMode = true

local instantFollow = false
local busSprites = {'bgBus', 'hillBus', 'neighborhood', 'sidewalk', 'marvin'}
local roomSprites = {'bg', 'hill', 'room', 'tv'}
local schoolSprites = {'school', 'spike', 'tighthead', 'kevin', 'ezekiel'}
local parkSprites = {'bgPark', 'buildings', 'hillPark', 'park', 'fountain', 'memesKid', 'david', 'dane', 'movingChars'}

function onMoveCamera(character)
    if instantFollow then
        callMethod('camGame.snapToTarget', {})
    end
end

function getMeasureLength()
    local measureLength = crochet * 4
    return measureLength
end

local function makeCamera(tag, x, y, width, height)
    createInstance(tag, "flixel.FlxCamera", {x, y, width, height})
    callMethod(tag..".copyFrom", {instanceArg("camGame")})
    setProperty(tag..".bgColor", 0x000000)
end

function onCreate()
    precacheImage('characters/tristan/tristan_adventure_notice')
end

function onCreatePost()
    makeAnimatedLuaSprite('tristanAdventureNotice', 'characters/tristan/tristan_adventure_notice', getProperty('dad.x'), getProperty('dad.y'))
    addAnimationByPrefix('tristanAdventureNotice', 'notice', 'notice', 24, false)
    setProperty('tristanAdventureNotice.flipX', getProperty('dad.flipX'))
    setProperty('tristanAdventureNotice.visible', false)
    addLuaSprite('tristanAdventureNotice')

    makeLuaSprite('blackBehind')
    makeGraphic('blackBehind', 1, 1, 'black')
    scaleObject('blackBehind', screenWidth * 3, screenHeight * 3)
    screenCenter('blackBehind')
    setProperty('blackBehind.alpha', 0)
    setObjectOrder('blackBehind', getObjectOrder('dadGroup')-1)
    addLuaSprite('blackBehind')

    makeLuaSprite('vignette', 'vignette')
    setProperty('vignette.color', FlxColor('BLACK'))
    setObjectCamera('vignette', 'hud')
    setProperty('vignette.alpha', 0)
    addLuaSprite('vignette')

    makeLuaSprite('slideTransition')
	makeGraphic('slideTransition', 1, screenHeight, '000000')
	setObjectCamera('slideTransition', 'hud')
	setProperty('slideTransition.alpha', 1)
	addLuaSprite('slideTransition')
end

function onSongStart()
    createInstance('bfGhost1', 'objects.Character', {getProperty('boyfriend.x'), getProperty('boyfriend.y'), boyfriendName, true})
    setProperty('bfGhost1.alpha', 0)
    setBlendMode('bfGhost1', 'screen')
    setObjectOrder('bfGhost1', getObjectOrder('boyfriendGroup')+1)
    addLuaSprite('bfGhost1')

    createInstance('bfGhost2', 'objects.Character', {getProperty('boyfriend.x'), getProperty('boyfriend.y'), boyfriendName, true})
    setProperty('bfGhost2.alpha', 0)
    setBlendMode('bfGhost2', 'screen')
    setObjectOrder('bfGhost2', getObjectOrder('bfGhost1')+1)
    addLuaSprite('bfGhost2')
end

function goodNoteHit(i, d, n, s)
    if getProperty('bfGhost1.exists') and getProperty('bfGhost2.exists') then
        playAnim('bfGhost1', getProperty('singAnimations')[d + 1],true)
        setProperty('bfGhost1.holdTimer', 0)

        playAnim('bfGhost2', getProperty('singAnimations')[d + 1],true)
        setProperty('bfGhost2.holdTimer', 0)

        if sustain then
            for i = 1,2 do
		        setProperty('bfGhost'..i..'.holdTimer', 0)
            end
	    end
    end
end

function onUpdate()
    setProperty("camTop.zoom", getProperty("camGame.zoom"))
    setProperty("camBottom.zoom", getProperty("camTop.zoom"))

    if focusOnGF then
        setObjectCamera('gf')
    end
end

function onStepHit()
    if curStep == 224 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
    elseif curStep == 392 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.2)
    elseif curStep == 440 then
        startTween('game-2', 'game', {defaultCamZoom = 3}, (stepCrochet / 1100) * 8, {ease = 'sineOut'})
        
        doTweenAlpha('blackBehindAlpha1', 'blackBehind', 0.5, (stepCrochet / 1100) * 8, 'sineOut')
    elseif curStep == 448 then
        callMethod('boyfriend.setPosition', {1100, 455})
        callMethod('dad.setPosition', {550, 450})
        callMethod('gf.setPosition', {400, 130})

        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {getProperty('defaultCamZoom')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('blackBehind')})

        startTween('game-1', 'game', {defaultCamZoom = 0.85}, (stepCrochet / 1100) * 8, {ease = 'backOut'})
        doTweenAlpha('blackBehindAlpha2', 'blackBehind', 0, (stepCrochet / 1100) * 8)

        -- change to bus-stop bg
        for _, i in ipairs(busSprites) do
            setProperty(i..'.visible', true)
        end

        for _, i in ipairs(roomSprites) do
            setProperty(i..'.visible', false)
        end

        instantFollow = true
    elseif curStep == 454 or curStep == 460 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.05)
    elseif curStep == 560 then
        setProperty('camGame.zoom', 1)
        setProperty('defaultCamZoom', 1)
    elseif curStep == 578 then
        instantFollow = false
    elseif curStep == 672 or curStep == 700 or curStep == 728 or curStep == 756 then
        if curStep == 672 then
            setProperty('defaultCamZoom', 0.7)
            callScript('data/adventure/Bus Stop Stage.lua', 'playMarvinAnimation', {'turn-transition'})

            callMethod('bfGhost1.setPosition', {getProperty('boyfriend.x'), getProperty('boyfriend.y')})
            callMethod('bfGhost2.setPosition', {getProperty('boyfriend.x'), getProperty('boyfriend.y')})
        end

        doTweenX('bfGhost1X', 'bfGhost1', getProperty('bfGhost1.x')-5, 1, 'quadIn')
        doTweenAlpha('bfGhost1Alpha', 'bfGhost1', 0.4, 1, 'quadIn')

        doTweenX('bfGhost2X', 'bfGhost2', getProperty('bfGhost2.x')+5, 1, 'quadIn')
        doTweenAlpha('bfGhost2Alpha', 'bfGhost2', 0.4, 1, 'quadIn')

    elseif curStep == 784 then
        startTween('bfGhost1X3', 'bfGhost1', {x = getProperty('bfGhost1.x')-10, alpha = 0.3}, 1, {ease = 'quadIn'})
        startTween('bfGhost2X3', 'bfGhost2', {x = getProperty('bfGhost2.x')+10, alpha = 0.3}, 1, {ease = 'quadIn'})

        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 892 then
        -- ok i had to steal some of moonlight's code sorry :(
        doTweenX('slideTransitionX', 'slideTransition.scale', screenWidth * 2, ((crochet / 1100) / playbackRate), 'sineOut')
    elseif curStep == 896 then
        callMethod('boyfriend.setPosition', {1320, 568})
        callMethod('dad.setPosition', {463, 560})
        
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('blackBehind')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {getPropertyFromClass('states.PlayState', 'instance')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('vignette')})

        for i = 1,2 do
            removeLuaSprite('bfGhost'..i)
        end

        for _, i in ipairs(busSprites) do
            setProperty(i..'.visible', false)
        end

        for _, i in ipairs(schoolSprites) do
            setProperty(i..'.visible', true)
        end
        startTween('game0', 'game', {defaultCamZoom = 1.1}, (stepCrochet / 1100) * 224)
        updateHitbox('slideTransition')
		doTweenX('slideTransitionX2', 'slideTransition.scale', 0.00001, ((crochet / 1100) / playbackRate), 'sineIn')

        doTweenAlpha('blackBehindAlpha2', 'blackBehind', 1, (stepCrochet / 1000) * 224)
        doTweenAlpha('vignetteAlpha1', 'vignette', 1, (stepCrochet / 1000) * 224)

        doTweenAlpha('kevinAlpha1', 'kevin', 0, (stepCrochet / 1000) * 224)
        doTweenAlpha('ezekielAlpha1', 'ezekiel', 0, (stepCrochet / 1000) * 224)
    elseif curStep == 1120 then
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('kevin')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('ezekiel')})

        doTweenAlpha('kevinAlpha2', 'kevin', 1, 0.5)
        doTweenAlpha('ezekielAlpha2', 'ezekiel', 1, 0.5)

        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('blackBehind')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {getProperty('defaultCamZoom')})
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('vignette')})

        doTweenAlpha('blackBehindAlpha3', 'blackBehind', 0, 0.5)
        doTweenAlpha('vignetteAlpha2', 'vignette', 0, 0.5)

        startTween('game1', 'game', {defaultCamZoom = 0.8}, 0.5, {ease = 'elasticOut'})
    elseif curStep == 1232 then
        startTween('game2', 'game', {defaultCamZoom = 0.6}, (getMeasureLength() / 1100), {ease = 'sineIn'})
    elseif curStep == 1344 then
        startTween('game3', 'game', {defaultCamZoom = 1.0}, 0.5, {ease = 'backOut'})
    elseif curStep == 1400 then
        runTimer('camOff', 0.5)

        makeCamera("camTop", -screenWidth, 0, screenWidth, screenHeight / 2, 0, 450)
		makeCamera("camBottom", screenWidth, screenHeight / 2, screenWidth, screenHeight / 2, 900, 650)

        setProperty('camTop.target', instanceArg('dad'), false, true)
        setProperty('camBottom.target', instanceArg('boyfriend'), false, true)

        for _, camRemove in ipairs ({"camHUD", "camOther"}) do
            callMethodFromClass("flixel.FlxG", "cameras.remove", {instanceArg(camRemove), false})
        end

        for _, camAdd in ipairs ({"camTop", "camBottom", "camHUD", "camOther"}) do
            callMethodFromClass("flixel.FlxG", "cameras.add", {instanceArg(camAdd), camAdd == "camTop" or camAdd == "camBottom"})
        end

        doTweenX("topX", "camTop", 0, 0.5 / playbackRate)
        doTweenX("bottomX", "camBottom", 0, 0.5 / playbackRate)
    elseif curStep == 1444 then
        setProperty('camGame.visible', false)

        focusOnGF = true

        startTween('camTopDisappear', 'camTop', {height = getPropertyFromClass('flixel.FlxG', 'stage.window.height')}, (stepCrochet / 1000) * 12, {onComplete = 's'})
        startTween('camBottomDisappear', 'camBottom', {height = 0}, (stepCrochet / 1000) * 12, {onUpdate = 't'})

        callScript('data/adventure/School Stage.lua', 'playBullyboySlide', {})
    elseif curStep == 1468 then
        doTweenAlpha('camHUDAlpha1', 'camHUD', 0, 0.5)
    elseif curStep == 1480 then
        setProperty('camZooming', false)
        -- thank you moonlight :sob:
        startTween("gameScale", "camGame.flashSprite", {scaleX = 0}, ((stepCrochet / 1250) * 4 / playbackRate))
    elseif curStep == 1484 then
        callMethod('boyfriend.setPosition', {1075, 515})
        callMethod('dad.setPosition', {570, 500})

        for _, i in ipairs(schoolSprites) do
            setProperty(i..'.visible', false)
        end
        for _, i in ipairs(parkSprites) do
            setProperty(i..'.visible', true)
        end
        setProperty('dad.visible', true)
        removeLuaSprite('tristanAdventureNotice')

        removeLuaSprite('bullyBoy')
        callScript('data/adventure/Park Stage.lua', 'initalizeMovingChars', {})
        startTween("gameScale", "camGame.flashSprite", {scaleX = 1}, ((stepCrochet / 1250) * 4 / playbackRate))
        runTimer('camOn', (stepCrochet / 1250) * 4)
        setProperty('camHUD.alpha', 1)
    elseif curStep == 1928 then
		setProperty('slideTransition.x', 0)
		setGraphicSize('slideTransition', screenWidth, 1)
		doTweenY('slideTransitionX3', 'slideTransition.scale', 2, ((crochet / 1100) / playbackRate), 'quadOut')
    elseif curStep == 1596 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
    elseif curStep == 1708 then
        setProperty('camGame.zoom', 0.9)
        setProperty('defaultCamZoom', 0.9)
        instantFollow = true
    elseif curStep == 1932 then
        callMethod('boyfriend.setPosition', {1150, 640})
        callMethod('dad.setPosition', {595, 637})
        
        instantFollow = false
        for _, i in ipairs(parkSprites) do
            setProperty(i..'.visible', false)
        end

        for _, i in ipairs(roomSprites) do
            setProperty(i..'.visible', true)
        end
    elseif curStep == 1936 then
        doTweenAlpha('slideTransitionX4', 'slideTransition', 0.0001, ((crochet / 1100) / playbackRate), 'quadOut')
    elseif curStep == 2060 then
        for _, cam in ipairs({'camGame', 'camHUD'}) do
            doTweenAlpha(cam..'Alpha', cam, 0, 2)
        end
    end
end

function onTweenCompleted(tag)
    if tag == 'bfGhost1X' then
        startTween('bfGhost1X2', 'bfGhost1', {x = getProperty('bfGhost1.x')+5, alpha = 0}, 1, {ease = 'quadOut', startDelay = (getMeasureLength() / 1000) - 2})
        startTween('bfGhost2X2', 'bfGhost2', {x = getProperty('bfGhost2.x')-5, alpha = 0}, 1, {ease = 'quadOut', startDelay = (getMeasureLength() / 1000) - 2})
    end
end

function t()
    setProperty('camBottom.y', screenHeight - getProperty('camBottom.height'))
end

function s()
    setProperty('camGame.visible', true)
    setProperty('camTop.visible', false)
    setProperty('camBottom.visible', false)
end

function opponentNoteHit(i, d, t, s)
    if curSection == 52 and d == 1 then
        setProperty('dad.visible', false)
        callMethod('tristanAdventureNotice.setPosition', {getProperty('dad.x'), getProperty('dad.y')})
        setProperty('tristanAdventureNotice.visible', true)
        playAnim('tristanAdventureNotice', 'notice', true)
    end
end