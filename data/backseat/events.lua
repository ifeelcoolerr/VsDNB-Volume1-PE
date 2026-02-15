luaDebugMode = true
local jsonTble = {}
local fakeNotes = {}
local indexNote = 0

local floatingGroup = {}
local floatingInfo = {}

local floatingCharsInitalized = false

local floatCheck = 0.06
local floatTimer = 0

local prevGaugeW, prevGaugeH = 0, 0

local shakeObjects = {'daveBg', 'stageHills', 'grassbg', 'gate', 'stageFront', 'daveChar', 'bfChar', 'gfChar'}

local noteOffsetTime = 40000

local charBaseOffset = {}

function instanceExists(tag)
    return getProperty(tag .. '.x') ~= nil
end

function onCreate()
    if getModSetting('cameraMovement') then
        runTimer('camOff', 0)
    end

    precacheImage('backgrounds/tristanBackseat/3d_bf_backseat')
    precacheImage('backgrounds/tristanBackseat/gf_3d_backseat')
    
    createInstance('gfChar', 'objects.Character', {350, 100, 'gf', false})
    scaleObject('gfChar', 0.4, 0.4, false)
    addLuaSprite('gfChar')
    setScrollFactor('gfChar', 0.8, 1)

    createInstance('daveChar', 'objects.Character', {360, 190, 'dave-annoyed', false})
    scaleObject('daveChar', 0.4, 0.4, false)
    addLuaSprite('daveChar')
    setScrollFactor('daveChar', 0.8, 1)

    createInstance('bfChar', 'objects.Character', {650, 305, 'bf', true})
    scaleObject('bfChar', 0.4, 0.4, false)
    addLuaSprite('bfChar')
    setScrollFactor('bfChar', 0.8, 1)

    makeLuaSprite('white')
    makeGraphic('white', screenWidth, screenHeight, 'white')
    setProperty('white.alpha', 0)
    setObjectOrder('white', getObjectOrder('bg'))
    addLuaSprite('white')

    for _, i in ipairs({'gfChar','bfChar','daveChar'}) do
        setObjectOrder(i, getObjectOrder('bg'))
    end

    for i = 0, 3 do
        local startY = 250 -- upscroll
        createInstance('daveStrums'..i, 'objects.StrumNote', {112 * i, startY, i, 0})
        callMethod('daveStrums.setPosition', {-270, 200})
        setScrollFactor('daveStrums'..i, 1, 1)
        setProperty('daveStrums'..i..'.downScroll', false)
        setProperty('daveStrums'..i..'.useRGBShader', false)
        setProperty('daveStrums'..i..'.x', getProperty('daveStrums'..i..'.x') - 200)
        setProperty('daveStrums'..i..'.alpha', 0)
		setOnScripts('defaultdaveStrumsX'..i, getProperty('daveStrums'..i..'.x'))
		setOnScripts('defaultdaveStrumsY'..i, getProperty('daveStrums'..i..'.y'))
        addLuaSprite('daveStrums'..i, true)
    end
    jsonTble = callMethodFromClass('tjson.TJSON', 'parse', {getTextFromFile('data/'..songName..'/insanity.json')})
    for i = 1, #jsonTble.notes do
        if #jsonTble.notes[i].sectionNotes > 0 then
            for b = 1, #jsonTble.notes[i].sectionNotes do
                indexNote = indexNote + 1
                fakeNotes[indexNote] = {
                    strumTime = jsonTble.notes[i].sectionNotes[b][1] - noteOffsetTime,
                    direction = jsonTble.notes[i].sectionNotes[b][2],
                    sustainLength = jsonTble.notes[i].sectionNotes[b][3],
                    noteType = jsonTble.notes[i].sectionNotes[b][4],
                }
            end
        end
    end
    for _, char in ipairs(floatingGroup) do
        setProperty(char..'.visible', false)
    end
end

function onBeatHit()
    if curBeat % 2 == 0 then
        if getProperty('gfChar.animation.curAnim.finished') then
            callMethod('gfChar.dance', {})
        end
        if getProperty('bfChar.animation.curAnim.finished') then
            callMethod('bfChar.dance', {})
        end
        if getProperty('daveChar.animation.curAnim.finished') then
            callMethod('daveChar.dance', {})
        end
    end
end

function onUpdatePost(elapsed)
    local curTime = getPropertyFromClass('flixel.FlxG', 'sound.music.time')
    local crochetMs = (60 / curBpm) * 1000

    for i, fn in pairs(fakeNotes) do
        if fn.spawned and fn.name then
            local noteName = fn.name
            local targetStrum = fn.targetStrum

            if not fn.hit and curTime >= fn.strumTime then
                fn.hit = true
                playAnim('bfChar', getProperty('singAnimations')[fn.direction + 1], true)
                setProperty('bfChar.holdTimer', 0)
                if instanceExists(targetStrum) then
                    callMethod(targetStrum..'.playAnim', {'static', true})
                end
            end

            if instanceExists(noteName) and instanceExists(targetStrum) then
                callMethod(noteName..'.followStrumNote', {instanceArg(targetStrum), crochetMs, getProperty('songSpeed') / playbackRate})
            end
        end
    end

    local animName = getProperty('boyfriend.animation.curAnim.name')
    local animNameDad = getProperty('dad.animation.curAnim.name')
    if difficultyName == 'tristan' then
        if animName == 'scared' and getProperty('boyfriend.animation.curAnim.finished') then
            triggerEvent('Play Animation', 'scared-idle', 'bf')
        end
    end
    if difficultyName == 'playrobot' then
        if animNameDad == 'scared' and getProperty('dad.animation.curAnim.finished') then
            triggerEvent('Play Animation', 'scared-idle', 'dad')
        end
    end
end

function onStartCountdown()
	spawnFakeNote()
end

function spawnFakeNote()
    local stepCrochetFromTemu = (60 / curBpm * 1000 / 4.0)

    for i, fn in pairs(fakeNotes) do
            local oldFakeNote
            if getProperty('unspawnNotes.length') > 0 then
                oldFakeNote = instanceArg('unspawnNotes['.. (getProperty('unspawnNotes.length')-1)..']')
            else
                oldFakeNote = nil 
            end

            local noteName = 'fakeNote'..i
            createInstance(noteName, 'objects.Note', {fn.strumTime, fn.direction % 4, oldFakeNote})
            setProperty(noteName..'.noteType', 'Alt Animation')
            setProperty(noteName..'.noAnimation', true)
            setProperty(noteName..'.noMissAnimation', true)
            setProperty(noteName..'.rgbShader.enabled', false)

            if fn.direction < 4 then
                fn.mustPress = true
            else
                fn.mustPress = false
            end

            setProperty(noteName..'.mustPress', fn.mustPress)
            setProperty(noteName..'.blockHit', fn.mustPress)
            setProperty(noteName..'.ignoreNote', fn.mustPress)

            setObjectCamera(noteName, 'game')
            setScrollFactor(noteName, 1, 1)
            callMethod('unspawnNotes.push', { instanceArg(noteName) })

            fn.name = noteName
            if fn.direction < 4 then
                fn.targetStrum = 'bfStrums'..(fn.direction % 4)
            else
                fn.targetStrum = 'daveStrums'..(fn.direction % 4)
            end
            fn.spawned = true

            local isLong = math.floor(fn.sustainLength / stepCrochetFromTemu)
            if isLong > 0 then
                fn.sustainTimes = {}
                fn.sustainWasHit = {}
                for b = 0, isLong + 1 do
                    fn.sustainTimes[b] = fn.strumTime + (stepCrochetFromTemu * b) + (stepCrochet / callMethodFromClass('backend.CoolUtil', 'floorDecimal', {getProperty('songSpeed'), 2}))
                    fn.sustainWasHit[b] = false
                end
            end
    end
    callMethod('unspawnNotes.sort', {instanceArg('sortByTime', 'states.PlayState')})
end

function opponentNoteHit(i,d,t,s)
    if t == 'Alt Animation' then
        playAnim('daveChar', getProperty('singAnimations')[d + 1],true)
        setProperty('daveChar.holdTimer', 0)
        callMethod('opponentStrums.members[' .. d .. '].playAnim', {'static', true})
        playAnim('daveStrums'..d, 'confirm', true, false, 0)
        setProperty('daveStrums'..d..'.resetAnim', getProperty('notes.members['..i..'].height') / .45 / getProperty('songSpeed') / getProperty('notes.members['..i..'].multSpeed') / playbackRate * .001)
    end
end

function goodNoteHit(i,d,t,s)
    if t == 'Alt Animation' then
        playAnim('bfChar', getProperty('singAnimations')[d + 1], true)
        callMethod('playerStrums.members[' .. d .. '].playAnim', {'static', true})
        setProperty('bfChar.holdTimer', 0)
    end
end

local shakeTime = 5
local shakeIntensity = 5

local originalPos = {}

function startShake(objects, intensity, duration)
    shakeIntensity = intensity
    shakeTime = duration
    shakeBG = true

    for _, a in ipairs(objects) do
        originalPos[a] = {x = getProperty(a..'.x'), y = getProperty(a..'.y')}
    end
end

function onUpdate(elapsed)
    if shakeBG then
        if shakeTime > 0 then
            shakeTime = shakeTime - elapsed
            for _, a in ipairs(shakeObjects) do
                local pos = originalPos[a]
                if pos then
                    setProperty(a..'.x', pos.x + (math.random() - 0.5) * shakeIntensity * 2)
                    setProperty(a..'.y', pos.y + (math.random() - 0.5) * shakeIntensity * 2)
                end
            end
        else
            shakeBG = false
            for _, a in ipairs(shakeObjects) do
                local pos = originalPos[a]
                if pos then
                    setProperty(a..'.x', pos.x)
                    setProperty(a..'.y', pos.y)
                end
            end
        end
    end

    floatTimer = floatTimer + elapsed
    if floatTimer >= floatCheck then
        floatTimer = floatTimer - floatCheck
        for i, char in ipairs(floatingGroup) do
            local dir = floatingInfo[i]
            if dir == 'left' then
                if getProperty(char..'.x') > screenWidth - 200 - getProperty(char..'.width') / 2 then
                    switchDirection(i)
                end
            elseif dir == 'right' then
                if getProperty(char..'.x') < 200 - getProperty(char..'.width') / 2 then
                    switchDirection(i)
                end
            end
        end
    end
end

function onCreatePost()
    initalizeFloatingChars()
    for _, char in ipairs({'gfScared', 'bfScared', 'daveScared'}) do
        setProperty(char..'.visible', false)
    end

    -- sorry i had to steal moonlight's code :sob:
    runHaxeCode([[
        for (key in game.getLuaObject('bfChar').animOffsets.keys()) {
            game.getLuaObject('bfChar').animOffsets[key][0] *= game.getLuaObject('bfChar').scale.x;
            game.getLuaObject('bfChar').animOffsets[key][1] *= game.getLuaObject('bfChar').scale.y;
        }
        for (keyt in game.getLuaObject('daveChar').animOffsets.keys()) {
            game.getLuaObject('daveChar').animOffsets[keyt][0] *= game.getLuaObject('daveChar').scale.x;
            game.getLuaObject('daveChar').animOffsets[keyt][1] *= game.getLuaObject('daveChar').scale.y;
        }
		for (keytt in game.getLuaObject('gfChar').animOffsets.keys()) {
            game.getLuaObject('gfChar').animOffsets[keytt][0] *= game.getLuaObject('gfChar').scale.x;
            game.getLuaObject('gfChar').animOffsets[keytt][1] *= game.getLuaObject('gfChar').scale.y;
        }
    ]])
end

function onStepHit()
    if curStep == 416 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1)
    end
    if curStep == 644 then
        startShake({'daveBg', 'stageHills', 'grassbg', 'gate', 'stageFront', 'daveChar', 'bfChar', 'gfChar'}, 2, (stepCrochet * 28) / 1000)
    end
    if curStep == 672 then
        runHaxeCode('FlxG.camera.shake(0.01);')

        flashSwitchBackground()

        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.2)
        triggerEvent('Play Animation', 'scared', 'bf')
        triggerEvent('Play Animation', 'scared', 'dad')
    end
    if curStep == 688 or curStep == 704 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.1)
    end
    if curStep == 944 then
        setProperty('defaultCamZoom', 1.2)
    end
    if curStep == 960 or curStep == 1024 then
        setProperty('defaultCamZoom', 1.1)
    end
    if curStep == 992 or curStep == 1056 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
    end
    if curStep == 1088 or curStep == 1152 then
        setProperty('defaultCamZoom', 0.8)
        setProperty('freezeCamera', true)
        doTweenX('cameraScroll', 'camGame.scroll', getProperty('camGame.scroll.x')-100, 0.5, 'backOut')
    end
    if curStep == 1120 or curStep == 1128 or curStep == 1184 or curStep == 1192 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')+0.15)
    end
    if curStep == 1136 or curStep == 1200 then
        setProperty('defaultCamZoom', 1)
    end
    if curStep == 1216 then
        setProperty('defaultCamZoom', 0.7)
        triggerEvent('Play Animation', 'scared2', 'dad')
        triggerEvent('Play Animation', 'scared2', 'bf')

        runHaxeCode('FlxG.camera.shake(0.01);')
        flashBg()

        changeFloatingCharsTo3D()
    end
    if curStep == 1232 then
        setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 1248 then
        runHaxeCode('FlxG.camera.zoom = game.defaultCamZoom = 1.0;')
    end
    if curStep == 1504 then
        setProperty('defaultCamZoom', 0.8)
    end
    if curStep == 1520 then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
    end
end

function flashSwitchBackground()
    flashBg()

    setProperty('daveChar.visible', false)
    setProperty('bfChar.visible', false)
    setProperty('gfChar.visible', false)

    for _, char in ipairs({'gfScared', 'bfScared', 'daveScared'}) do
        setProperty(char..'.visible', true)
    end

    for _, s in ipairs({'daveBg', 'stageHills', 'grassbg', 'gate', 'stageFront'}) do
        setProperty(s..'.visible', false)
    end

    setProperty('void.alpha', 1)
end

function flashBg()
    setProperty('white.alpha', 1)
    runHaxeCode([[
        FlxTween.tween(getVar("white"), {alpha: 0}, 3, 
        {
            startDelay: 1.5,
        });
    ]])
end

function initalizeFloatingChars()
    if floatingCharsInitalized then
        return
    end
    floatingGroup = {} -- clear
    floatingInfo = {}
    local directions = {'left', 'right'}

    local randomDirection = directions[getRandomInt(1, #directions)]

    makeAnimatedLuaSprite('gfScared', 'backgrounds/tristanBackseat/GF_Scared', 550, 350)
    addAnimationByPrefix('gfScared', 'idle', 'GF FEAR', 24)
    callMethod('gfScared.animation.play', {'idle', true})
    setScrollFactor('gfScared', 0.8, 1)
    scaleObject('gfScared', 0.4, 0.4)
    table.insert(floatingGroup, 'gfScared')
    addLuaSprite('gfScared')
    setDirection(randomDirection, 1, 'gfScared')

    randomDirection = directions[getRandomInt(1, #directions)]

    makeLuaSprite('daveScared', 'backgrounds/tristanBackseat/dave_backseat_scared', 430, 350)
    callMethod('daveScared.animation.play', {'idle', true})
    setScrollFactor('daveScared', 0.8, 1)
    scaleObject('daveScared', 0.4, 0.4)
    table.insert(floatingGroup, 'daveScared')
    addLuaSprite('daveScared')
    setDirection(randomDirection, 1, 'daveScared')

    randomDirection = directions[getRandomInt(1, #directions)]

    makeAnimatedLuaSprite('bfScared', 'backgrounds/tristanBackseat/BF_Scared', 750, 425)
    addAnimationByPrefix('bfScared', 'idle', 'BF idle shaking', 24)
    callMethod('bfScared.animation.play', {'idle', true})
    setScrollFactor('bfScared', 0.8, 1)
    scaleObject('bfScared', 0.4, 0.4)
    table.insert(floatingGroup, 'bfScared')
    addLuaSprite('bfScared')
    setDirection(randomDirection, 2, 'bfScared')

    for _, s in ipairs({'gfScared', 'bfScared', 'daveScared'}) do
        setObjectOrder(s, getObjectOrder('white'))
    end

    floatingCharsInitalized = true
end

function changeFloatingCharsTo3D()
    loadGraphic('bfScared', 'backgrounds/tristanBackseat/3d_bf_backseat')
    scaleObject('bfScared', 0.4, 0.4)

    loadGraphic('gfScared', 'backgrounds/tristanBackseat/gf_3d_backseat')
    scaleObject('gfScared', 0.4, 0.4)
end

function setDirection(dir, index, sprite)
    local dirM = (dir == 'left') and -1 or 1
    setProperty(sprite..'.velocity.x', getRandomFloat(50, 100) * dirM)
    setProperty(sprite..'.angularVelocity', getRandomFloat(-30, 30))
    floatingInfo[index] = dir
end

function switchDirection(index)
    for _, floatingChar in ipairs(floatingGroup) do
        local dirM = (floatingInfo[index] == 'left') and -1 or 1
        setProperty(floatingChar..'.y', getRandomFloat(250, 350))
        setProperty(floatingChar..'.velocity.x', getRandomFloat(50, 150) * getRandomFloat(1, 2.5) * dirM)
        setProperty(floatingChar..'.velocity.y', getRandomFloat(-25, 50))
        setProperty(floatingChar..'.angle', getRandomFloat(-5, 5))
        setProperty(floatingChar..'.angularVelocity', getRandomFloat(-30, 30))
    end
end

function onTweenCompleted(tag)
    if tag == 'cameraScroll' then
        setProperty('freezeCamera', false)
    end
end
