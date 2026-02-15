-- STRUM NOTE CODE BY MOONLIGHT PSYCH ENGINE!!! https://www.youtube.com/@MoonPE they gave me permission to use this so go sub to them!!!
luaDebugMode = false
local jsonTble = {}
local fakeNotes = {}
local indexNote = 0
local oldFakeNote = 0
local oldLength = 0
local banTypes = {'f'}
local dopoop = false
local changeColors = false

local follow = true
function onMoveCamera(character)
    if not follow then
        if character == 'boyfriend' then
            callMethod('camGame.snapToTarget', {})
        elseif character == 'dad' then
            callMethod('camGame.snapToTarget', {})
        end
    end
end

function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

function onBeatHit()
    if getProperty('camZooming') and curBeat % 4 == 0 or crazyZooming then
        triggerEvent('Add Camera Zoom', '0.015', '0.03')
    end

    if curBeat == 392 or curBeat == 432 or curBeat == 456 or curBeat == 472 then
        runTimer('camOff', 0)
        dopoop = true
    elseif curBeat == 376 or curBeat == 408 or curBeat == 440 or curBeat == 464 or curBeat == 488 or curBeat == 536 then
        runTimer('camOn', 0)
        dopoop = false
    elseif curBeat == 520 then
        runTimer('camOff', 0)
        addCameraFollowPoint(100, nil)
    end
    if getProperty('dave.animation.curAnim.finished') then
        playAnim('dave', 'idle', true)
    end
end


function onCreate()
    makeFlxAnimateSprite('bambiVoicelines', getProperty('dad.x'), getProperty('dad.y'), 'characters/bambi/bambi_mealieVoicelines')
    addAnimationBySymbol('bambiVoicelines', 'phone', 'bambi idiot', 24, false)
    addAnimationBySymbol('bambiVoicelines', 'liar', 'focking liar moldy', 24, false)
    addAnimationBySymbol('bambiVoicelines', 'blockYou', 'igonna block youse', 24, false)
    addAnimationBySymbol('bambiVoicelines', 'holyShit', 'holyShit', 24, false)
    addAnimationBySymbol('bambiVoicelines', 'sigh', 'sigh', 24, false)

    addOffset('bambiVoicelines', 'liar', -376, 32)
    addOffset('bambiVoicelines', 'blockYou', -328, 5)
    addOffset('bambiVoicelines', 'phone', -35, -20)
    addOffset('bambiVoicelines', 'holyShit', -50, -23)
    addOffset('bambiVoicelines', 'sigh', -35, -18)


    precacheImage('characters/dave/dave_mealie')

    makeAnimatedLuaSprite('davemealie', 'characters/dave/dave_mealie', getProperty('dave.x'), getProperty('dave.y'))
    addAnimationByPrefix('davemealie', 'surprised', 'surprised', 24, false)
    addAnimationByPrefix('davemealie', 'surprised-loop', 'surprisedloop', 24, true)

    updateHitbox('bambiVoicelines')
    setProperty('bambiVoicelines.alpha', 0.001)
    setObjectOrder('bambiVoicelines', getObjectOrder('gfGroup')+1)
    addLuaSprite('bambiVoicelines', true)

    createInstance('dave', 'objects.Character', {getProperty('dad.x')-350, getProperty('dad.y')-160, 'dave', false})
    setProperty('dave.alpha', 0.0001)
    setObjectOrder('dave', getObjectOrder('dadGroup')+1)
    addInstance('dave')

    for i = 0, 3 do
        local startY = 250 -- upscroll
        createInstance('daveStrums'..i, 'objects.StrumNote', {112 * i, startY, i, 0})
        callMethod('daveStrums.setPosition', {-270, 200})
        setScrollFactor('daveStrums'..i, 1, 1)
        setProperty('daveStrums'..i..'.downScroll', false)
        setProperty('daveStrums'..i..'.x', getProperty('daveStrums'..i..'.x') - 200)
        setProperty('daveStrums'..i..'.alpha', 0)
		setOnScripts('defaultdaveStrumsX'..i, getProperty('daveStrums'..i..'.x'))
		setOnScripts('defaultdaveStrumsY'..i, getProperty('daveStrums'..i..'.y'))
        addInstance('daveStrums'..i, true)
        setProperty('daveStrums'..i..'.useRGBShader', true)
    end
    jsonTble = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('data/'..songName..'/alt-notes.json')})
    for i = 1, #jsonTble.notes do
		if #jsonTble.notes[i].sectionNotes > 0 then
			for b = 1, #jsonTble.notes[i].sectionNotes do
				indexNote = indexNote + 1
				fakeNotes[indexNote] = {
					strumTime = 0,
					direction = 0,
					sustainLength = 0,
					noteType = '',
					sustainWasHit = {},
					sustainTimes = {}
				}
				fakeNotes[indexNote].strumTime = jsonTble.notes[i].sectionNotes[b][1]
				fakeNotes[indexNote].direction = (jsonTble.notes[i].sectionNotes[b][2])
				fakeNotes[indexNote].sustainLength = jsonTble.notes[i].sectionNotes[b][3]
				fakeNotes[indexNote].noteType = jsonTble.notes[i].sectionNotes[b][4]
			end
		end
	end
end

function onStartCountdown()
	spawnFakeNote()
end

function spawnFakeNote()
	for i in pairs(fakeNotes) do
        if not findBannedNoteType(fakeNotes[i].noteType) then
			if getProperty('unspawnNotes.length') > 0 then
				oldFakeNote = instanceArg('unspawnNotes['.. (getProperty('unspawnNotes.length')-1)..']')
			else
				oldFakeNote = nil 
			end
			createInstance('fakeNote'..i, 'objects.Note', {fakeNotes[i].strumTime, fakeNotes[i].direction % 4, oldFakeNote})
			setProperty('fakeNote'..i..'.noteType', 'Alt Animation')
			setProperty('fakeNote'..i..'.noAnimation', true)
			setProperty('fakeNote'..i..'.noMissAnimation', true)
            setProperty('fakeNote'..i..'.rgbShader.enabled', false)
			setProperty('fakeNote'..i..'.mustPress', fakeNotes[i].direction < 4)
			setProperty('fakeNote'..i..'.blockHit', fakeNotes[i].direction < 4)
			setProperty('fakeNote'..i..'.ignoreNote', fakeNotes[i].direction < 4)

            setObjectCamera('fakeNote'..i, 'game')
            setScrollFactor('fakeNote'..i, 1, 1)
			callMethod('unspawnNotes.push', {instanceArg('fakeNote'..i)})
            	
			local stepCrochetFromTemu = (60 / curBpm * 1000 / 4.0) 
			local isLong = math.floor(fakeNotes[i].sustainLength / stepCrochetFromTemu)
			if isLong > 0 then
				for b = 0, isLong + 1 do
					fakeNotes[i].sustainTimes[b] = fakeNotes[i].strumTime + (stepCrochetFromTemu * b) + (stepCrochet / callMethodFromClass('backend.CoolUtil', 'floorDecimal', {getProperty('songSpeed'), 2}))
					fakeNotes[i].sustainWasHit[b] = false
				end
            end
		end
	end
	callMethod('unspawnNotes.sort', {instanceArg('sortByTime', 'states.PlayState')})
end

elapsedTime = 0

function onUpdatePost(elapsed)
    elapsedTime = elapsedTime + elapsed
    if dopoop then
        setCameraFollowPoint(getMidpointX('dave'), getMidpointY('dave')-150)
    end
	for i in pairs(fakeNotes) do
		callMethod('fakeNote'..i..'.followStrumNote', {instanceArg('daveStrums'..fakeNotes[i].direction % 4), (60/curBpm)*1000, getProperty('songSpeed') / playbackRate})
	end
    if focusOnBF then
        cameraSetTarget('bf')
    end
    if focusOnDad then
        cameraSetTarget('dad')
    end
    if getProperty('dad.animation.curAnim.finished') == 'singThrow' then
        setProperty('dad.canDance', true)
    end
    if getProperty('davemealie.animation.curAnim.name') == 'surprised' and getProperty('davemealie.animation.curAnim.finished') then
        playAnim('davemealie', 'surprised-loop', true)
    end

    if forceSustainAlpha then
        for i = 0, getProperty('notes.length') - 1 do
            if getPropertyFromGroup('notes', i, 'isSustainNote') and not getPropertyFromGroup('notes', i, 'mustPress') then
                local alpha = getPropertyFromGroup('notes', i, 'alpha')
                if alpha > 0 then
                    setPropertyFromGroup('notes', i, 'alpha', 0.3)
                end
            end
        end
    end
end

function opponentNoteHit(i,d,t,s)
    if t == 'Alt Animation' then
        playAnim('dave', getProperty('singAnimations')[d + 1],true)
        setProperty('dave.holdTimer', 0)
        callMethod('opponentStrums.members[' .. d .. '].playAnim', {'static', true})
        playAnim('daveStrums'..d, 'confirm', true, false, 0)
        setProperty('daveStrums'..d..'.resetAnim', getProperty('notes.members['..i..'].height') / .45 / getProperty('songSpeed') / getProperty('notes.members['..i..'].multSpeed') / playbackRate * .001)
    end
end

function onStepHit()
    if getProperty('camZooming') and curStep % 16 == 0 or crazyZooming2 then
        triggerEvent('Add Camera Zoom', '0.015', '0.03')
    end
    
    local bfCamPosX = getMidpointX('boyfriend')-850-getProperty('boyfriend.cameraPosition[0]')-getProperty('boyfriendCameraOffset[0]')
    local dadCamPosX = getMidpointX('dad')-450+getProperty('dad.cameraPosition[0]')+getProperty('opponentCameraOffset[0]')
    local bfCamPosX = getMidpointX('boyfriend')-850-getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]')
    local dadCamPosX = getMidpointX('dad')-450+getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')
    local targetX = bfCamPosX - dadCamPosX

    if curStep == 112 then
        doTweenAlpha('huda', 'camHUD', 0, 0.5)
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.2)
        setProperty('dad.alpha', 0)
        setProperty('bambiVoicelines.alpha', 1)
        playAnim('bambiVoicelines', 'blockYou', true)
    elseif curStep == 128 then
        crazyZooming = true
        setProperty('dad.alpha', 1)
        setProperty('bambiVoicelines.visible', false)

        doTweenAlpha('huda', 'camHUD', 1, 0.5, 'expoOut')
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
    elseif curStep == 156 then
        focusOnBF = true
        runTimer('camOff', 0)
        doTweenX('poopcamcam', 'camGame.scroll', bfCamPosX, 0.5, 'backOut')
    elseif curStep == 192 then
        focusOnBF = false
        runTimer('camOn', 0.3)
        startTween('yea1', 'game', {defaultCamZoom = getProperty('defaultCamZoom') - 0.2}, 0.25, {ease = 'sineIn'})
    elseif curStep == 320 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.1)
    elseif curStep == 380 then
        crazyZooming = false
        crazyZooming2 = true
    elseif curStep == 384 then
        crazyZooming2 = false
        crazyZooming = true
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.2)
    elseif curStep == 512 or curStep == 576 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.1)
    elseif curStep == 608 then
        crazyZooming = false
    elseif curStep == 635 then
        if callMethod('boyfriend.hasAnimation', {'hey'}) and callMethod('dad.hasAnimation', {'hey'}) then
            triggerEvent('Play Animation', 'hey', 'boyfriend')
            triggerEvent('Play Animation', 'hey', 'dad')
        end

        if callMethod('gf.hasAnimation', {'cheer'}) then
            triggerEvent('Play Animation', 'cheer', 'gf')
        end
        crazyZooming = false
    elseif curStep == 640 then
        crazyZooming = true
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 690 then
        focusOnDad = true
        runTimer('camOff', 0)
        setProperty('defaultCamZoom', 1)
        setProperty('camGame.scroll.x', getProperty('camGame.scroll.x')-100)
    elseif curStep == 704 then
        focusOnDad = false
        runTimer('camOn', 0)
    elseif curStep == 752 then
        focusOnBF = true
        runTimer('camOff', 0)
        runHaxeCode('FlxG.camera.zoom = game.defaultCamZoom += 0.2;')
        setProperty('camGame.scroll.x', getProperty('camGame.scroll.x')+100)
    elseif curStep == 768 then
        focusOnBF = false
        runTimer('camOn', 0)
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 784 or curStep == 816 then
        focusOnDad = true
        runTimer('camOff', 0)
    elseif curStep == 800 then
        setProperty('defaultCamZoom', 0.85)
    elseif curStep == 832 then
        focusOnDad = false
        runTimer('camOn', 0)
    elseif curStep == 896 then
        setProperty('defaultCamZoom', 0.8)
        setProperty('camZooming', false)
    elseif curStep == 922 then
        runTimer('camOff', 0)
        setProperty('defaultCamZoom', 1.3)
        setPropertyFromClass('flixel.FlxG', 'camera.zoom', 1.3)
        setProperty('camGame.scroll.x', getProperty('camGame.scroll.x') - 50)
        setProperty('dad.alpha', 0)
        setProperty('bambiVoicelines.visible', true)
        playAnim('bambiVoicelines', 'sigh', true)
    elseif curStep == 928 then
        crazyZooming = false
        setProperty('dad.alpha', 1)
        setProperty('bambiVoicelines.visible', false)
        runTimer('camOn', 0)
        setProperty('camZooming', true)
    elseif curStep == 960 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 1066 or curStep == 1120 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.1)
    elseif curStep == 1186 then
        focusOnDad = true
        runTimer('camOff', 0)
        callMethod('camGame.snapToTarget', {})
        setProperty('defaultCamZoom', 1.1)
    elseif curStep == 1200 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 1216 or curStep == 1280 then
        focusOnDad = false
        setProperty('defaultCamZoom', 1)
        follow = false
    elseif curStep == 1296 then
        runTimer('camOn', 0)
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 1312 then
        follow = true
        setProperty('defaultCamZoom', 1)
    elseif curStep == 1390 then
        focusOnDad = true
        setProperty('dad.alpha', 0)
        setProperty('bambiVoicelines.visible', true)
        setProperty('bambiVoicelines.alpha', 1)
        playAnim('bambiVoicelines', 'phone', true)
    elseif curStep == 1412 then
        setProperty('bambiVoicelines.visible', false)
        setProperty('dad.alpha', 1)
        playAnim('dad', 'singThrow', true)
    elseif curStep == 1426 then
        setProperty('dad.alpha', 0)
        setProperty('bambiVoicelines.visible', true)
        playAnim('bambiVoicelines', 'holyShit', true)
    elseif curStep == 1440 then
        focusOnDad = false
        crazyZooming = true
        changeStuff()
    elseif curStep == 1568 then
        cameraSetTarget('dad')
        dopoop = true
    elseif curStep == 1632 then
        cameraSetTarget('bf')
        setCameraFollowPoint(bfCamPosX)
    elseif curStep == 1688 then
        setProperty('camZooming', false)
    elseif curStep == 1692 then
        runTimer('camOff', 0)
        focusOnDad = true
        playAnim('dad', 'hey', true)
        playAnim('dave', 'hey', true)
        cameraSetTarget('dad')
        callMethod('camGame.snapToTarget', {})
    elseif curStep == 1696 then
        focusOnDad = false
        setProperty('camZooming', true)
        runTimer('camOn', 0)
    elseif curStep == 1952 then
        crazyZooming = true
    elseif curStep == 2016 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.1)
    elseif curStep == 2080 then
        crazyZooming = false
    elseif curStep == 2208 then
        setProperty('camZooming', false)
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 2225 then
        runTimer('camOff', 0)
        focusOnDad = true
        ending()
    end
end

function changeStuff()
    setProperty('defaultCamZoom', 0.9)
    callMethod('iconP2.changeIcon', {'the-duo'})
    if getProperty('timer') ~= nil then
        setProperty('timer.color', FlxColor('WHITE'))
        callMethodFromClass('flixel.util.FlxGradient', 'overlayGradientOnFlxSprite', {instanceArg('timer'), getProperty('timer.width'), getProperty('timer.height'), {getColorFromHex('4965FF'), getColorFromHex('00B515')}, 1, 0, 1, 90})
    end
    setProperty('healthBar.leftBar.color', FlxColor('WHITE'))
    callMethodFromClass('flixel.util.FlxGradient', 'overlayGradientOnFlxSprite', {instanceArg('healthBar.leftBar'), getProperty('healthBar.leftBar.width'), getProperty('healthBar.leftBar.height'), {getColorFromHex('4965FF'), getColorFromHex('00B515')}, 1, 0, 1, 180})
    setProperty('bambiVoicelines.visible', false)
    setProperty('dad.alpha', 1)
    setProperty('dave.alpha', 1)
    doTweenX('daveX', 'dave', getProperty('dave.x')+100, 0.5, 'expoOut')
    for i = 0, 3 do
        -- this is shit
        runHaxeCode([[
            var s = game.opponentStrums.members[]]..i..[[];
            s.cameras = [game.camGame];
            game.addBehindDad(s);
        ]])
        setObjectCamera('opponentStrums.members['..i..']', 'game')
        setProperty('daveStrums'..i..'.alpha', 0.3)
        setProperty('opponentStrums.members['..i..'].downScroll', false)
        startTween('oppStrum'..i, 'opponentStrums.members['..i..']', {x = 100 + (112 * i), y = 350}, 0.5, {ease = 'quadOut'})
        doTweenAlpha('oppStrumAlpha'..i, 'opponentStrums.members['..i..']', 0.3, 0.5, 'quadOut')
        startTween('oppStrumSF'..i, 'opponentStrums.members['..i..'].scrollFactor', {x = 1, y = 1}, 0.5, {ease = 'quadOut'})
    end
    forceSustainAlpha = true
end

function ending()
    setProperty('bambiVoicelines.visible', true)
    playAnim('bambiVoicelines', 'liar', true)
    setProperty('camZooming', false)
    setProperty('dad.alpha', 0)
    playAnim('davemealie', 'surprised', true)
    setProperty('dave.alpha', 0)
    setProperty('davemealie.x', getProperty('dave.x')) -- BRUHH
    setProperty('davemealie.y', getProperty('dave.y'))
    doTweenX('davex1', 'davemealie', getProperty('dave.x')-20, 0.5, 'quadOut')
    setObjectOrder('davemealie', getObjectOrder('bambiVoicelines')+1)
    addLuaSprite('davemealie')
end

function findBannedNoteType(noteType)
	for _, v in ipairs(banTypes) do
		if v == noteType then
			return true
		end
	end
	return false
end

function instanceExists(tag)
    return getProperty(tag .. '.x') ~= nil
end