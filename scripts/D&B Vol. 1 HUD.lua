-- Script by NextGen
-- Edited by Me

luaDebugMode = true

local threeDeeSongs = {'polygonized', 'kabunga', 'oppression', 'furiosity'} -- 3d songs duh, put your songs here

local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then return true end
    end
    return false
end

function createLuaText(tag, width, posX, posY) -- A simplified version of making a luaText
    makeLuaText(tag, '', width, posX, posY)
    setTextAlignment(tag, 'left')
    setTextSize(tag, 21)
    setTextFont(tag, 'comic-sans.ttf')
    setProperty(tag..'.antialiasing', true)
    scaleObject(tag, 0.95, 1)
    addLuaText(tag)
end

function createAsset(tag, imgPath, posX, posY) -- A simplified version of making a luaSprite
    makeLuaSprite(tag, imgPath, posX, posY)
    scaleObject(tag, 0.5, 0.5, false)
    setObjectCamera(tag, 'camHUD')
    addLuaSprite(tag)
end

function formatTime(millisecond) -- Formats time in its proper format
    local seconds = math.floor(millisecond / 1000)
    return string.format('%01d:%02d', (seconds / 60) % 60, seconds % 60)
end

function rgbToHex(array) -- Self-explainatory
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end

local function lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function smoothLerp(current, target, elapsed, duration, precision)
    precision = precision or 1/100

    if current == target then 
        return target
    end

    local result = lerp(current, target, 1 - math.pow(precision, elapsed / duration))

    if math.abs(result - target) < (precision * target) then
        result = target
    end

    return result
end

function onCountdownStarted()
    if downscroll then
        for n = 0, 3 do
            setPropertyFromGroup('opponentStrums', n, 'y', 555)
            setPropertyFromGroup('playerStrums', n, 'y', 555)
        end
    end
end

local ogWindowTitle = ''

function onCreate()
    ogWindowTitle = getPropertyFromClass('flixel.FlxG', 'stage.window.title')

    if songName ~= 'MathGameState' then
        runHaxeCode('FlxG.mouse.load(Paths.image("cursor").bitmap);')
    end

    runHaxeCode([[
        import substates.PauseSubState;
        
        game.subStateOpened.add(function(substate) {
            if (Std.isOfType(substate, PauseSubState)) {
                substate.add(getVar('bgBackdrop'));
            }
        });
    ]])
end

-- Pause Backdrop Menu

function onPause()
    createInstance("bgBackdrop", "flixel.addons.display.FlxBackdrop", {nil, 0x11, 1, 1})
    loadGraphic("bgBackdrop", "checkeredBG")
    setObjectCamera("bgBackdrop", 'other')
    setProperty("bgBackdrop.velocity.x", -50)
    setProperty("bgBackdrop.velocity.y", -50)
    setProperty('bgBackdrop.alpha', 0.6)
    addLuaSprite('bgBackdrop')
end

function onResume()
    removeLuaSprite('bgBackdrop', true)
end

-- UI Stuff

function onCreatePost()    
    runHaxeCode([[
        import Main;
        import flixel.util.FlxStringUtil;
        import openfl.text.TextFormat;
        import openfl.system.System;

        Main.fpsVar.defaultTextFormat = new TextFormat("comic-sans.ttf", 18, 0xFFFFFF);
        Main.fpsVar.updateText = function() {
            var memBytes:Float = System.totalMemory;
            var memFormatted:String = FlxStringUtil.formatBytes(memBytes);

            Main.fpsVar.text = 'FPS: ' + Main.fpsVar.currentFPS +
            '\nMemory:\n' + memFormatted;

            Main.fpsVar.textColor = 0xFFFFFFFF;
            if (Main.fpsVar.currentFPS < FlxG.drawFramerate * 0.5)
                Main.fpsVar.textColor = 0xFFFF0000;
        }
    ]])

    if downscroll then
        setProperty('healthBar.y', 50.2)
        setProperty('iconP1.y', -24.8)
        setProperty('iconP2.y', -24.8)
    end

    for i = 0, getProperty('unspawnNotes.length')-1 do
        setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.disabled', true)
    end

    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
        end
    end

    if not getModSetting('cameraMovement') then
        removeLuaScript('scripts/Camera Movement.lua')
    end
    if not getModSetting('darkMode') then
        removeLuaScript('scripts/Window Color Mode.lua')
    end

    if getPropertyFromClass('flixel.FlxG', 'stage.window.title') ~= 'VS. Dave and Bambi' then
        setPropertyFromClass('flixel.FlxG', 'stage.window.title', 'VS. Dave and Bambi')
    end

    setProperty('showCombo', false)

    loadGraphic('healthBar.bg', 'ui/bars/healthBar')
    setProperty('healthBar.bg.scale.x', 1.01)

    setObjectCamera('comboGroup', 'camGame')
    setProperty('comboGroup.x', getProperty('gfGroup.x') - 170)
    setProperty('comboGroup.y', getProperty('gfGroup.y') + 150)

    -- i'll admit the timer code i took was from moonlight's volume 1 hud code (hscript code converted into lua lol)
    -- this now uses a pie chart shader instead of FlxPieDial
    if downscroll then
        clockY = getProperty('timeBar.y') - 125
    else
        clockY = getProperty('timeBar.y') - 10
    end
    makeLuaSprite('alarmClock', nil, 0, clockY)
    if contains(threeDeeSongs, songName:lower()) then
        loadGraphic('alarmClock', 'ui/timer-3d')
        setProperty('alarmClock.antialiasing', false)
        setPropertyFromClass('states.PlayState', 'stageUI', 'ui/3D')
    else
        loadGraphic('alarmClock', 'ui/timer')
    end
    setObjectCamera('alarmClock', 'camHUD')
    screenCenter('alarmClock', 'x')
    addToGroup('uiGroup', 'alarmClock')
    addLuaSprite('alarmClock')
    updateHitbox('alarmClock')

    createInstance('timerBG', 'flixel.addons.display.shapes.FlxShapeCircle', {0, 0, 50, {}, -1})
    setObjectCamera('timerBG', 'hud')
    setProperty('timerBG.color', FlxColor('gray'))
    setProperty('timerBG.origin.x', 50)
    setProperty('timerBG.origin.y', 50)
    setProperty('timerBG.x', getProperty('alarmClock.x') + 20)
    setProperty('timerBG.y', getProperty('alarmClock.y') + 20)
    addToGroup('uiGroup', 'timerBG')
    addLuaSprite('timerBG')

    makeLuaSprite('timer', nil, 0, 0)
    makeGraphic('timer', 100, 100, 'ffffff')
    setObjectCamera('timer', 'hud')
    setProperty('timer.flipX', true)
    setProperty('timer.origin.x', 50)
    setProperty('timer.origin.y', 50)
    setProperty('timer.x', getProperty('timerBG.x'))
    setProperty('timer.y', getProperty('timerBG.y'))
    addToGroup('uiGroup', 'timer')
    addLuaSprite('timer')

    for _, timers in ipairs({'timerBG', 'timer'}) do
        setObjectOrder(timers, getObjectOrder('alarmClock', 'uiGroup'), 'uiGroup')
    end

    initLuaShader('PieChart')
    setSpriteShader('timer', 'PieChart')
    setShaderBool('timer', 'useGradient', false)
    setShaderFloat('timer', '_amount', 0)
    setShaderFloat('timer', '_start', 0)
    setShaderFloat('timer', '_end', 360)

    setProperty('timer.color', FlxColor('#'..rgbToHex(getProperty("dad.healthColorArray"))..''))

    local alarmX = getProperty('alarmClock.x')
    local alarmY = getProperty('alarmClock.y')

    local offsetX = 14
    local offsetY = 20

    for _, timers in ipairs({'timerBG', 'timer'}) do
        setProperty(timers..'.x', alarmX + offsetX)
        setProperty(timers..'.y', alarmY + offsetY)
    end

    setProperty('timer.alpha', 0.001)
    setProperty('timerBG.alpha', 0.001)

    createAsset('accuracyIcon', 'ui/accuracy', 456, getProperty('healthBar.y') + 6)
    createLuaText('accuracyText', 1280, 481, getProperty('healthBar.y') + 26)

    createAsset('missesIcon', 'ui/misses', 596, getProperty('healthBar.y') + 8)
    createLuaText('missesText', 1280, 651, getProperty('healthBar.y') + 24)

    createAsset('scoreIcon', 'ui/score', 744, getProperty('healthBar.y') + 5)
    createLuaText('scoreText', 1280, 808, getProperty('healthBar.y') + 27)

    for _, uE in ipairs({'accuracyIcon', 'accuracyText', 'missesIcon', 'missesText', 'scoreIcon', 'scoreText'}) do
        setObjectOrder(uE, getObjectOrder('healthBar', 'uiGroup'))
        setObjectOrder('noteGroup', getObjectOrder(uE) - 1)
    end

    setTextFont('timeTxt', 'comic-sans.ttf')
    setTextSize('timeTxt', 23)
    setTextBorder('timeTxt', 2.5, '000000')
    screenCenter('timeTxt', 'x')
    setProperty('timeTxt.y', getProperty('timer.y')+105)
    setProperty('timeTxt.antialiasing', true)

    setTextFont('botplayTxt', 'comic-sans.ttf')
    setTextSize('botplayTxt', 29)
    setTextBorder('botplayTxt', 2.25, '000000')
    setProperty('botplayTxt.y', downscroll and getProperty('healthBar.y') + 55 or getProperty('healthBar.y') - 55)

    setProperty('timeBar.visible', false)
    setProperty('scoreTxt.visible', false)

    setProperty('botplayTxt.antialiasing', true)

    if getModSetting('minimalUI') then
        setPropertyFromClass('Main', 'fpsVar.visible', false)
        for _, s in ipairs({'accuracyIcon', 'missesIcon',  'scoreIcon', 'timeGauge', 'clockCover', 'alarmClock'}) do
            removeLuaSprite(s)
        end
        for _, t in ipairs({'accuracyText', 'scoreText', 'missesText'}) do
            removeLuaText(t)
        end
        runHaxeCode([[
            game.remove(botplayTxt);
            game.remove(comboGroup);
        ]])
        setProperty('timeTxt.visible', false)
    end
    setObjectOrder('timeTxt', getObjectOrder('uiGroup')+1, 'uiGroup')
end

function onUpdate(elapsed)
    for i = 0, getProperty('notes.length') - 1 do
        if getPropertyFromGroup('notes', i, 'isSustainNote') then
            setPropertyFromGroup('notes', i, 'animation.curAnim.looped', false)
        end
    end
end

function onUpdatePost(elapsed)
    setProperty('cameraSpeed', 1.35)

    if getModSetting('timerType') then
        setTextString('timeTxt', ''..formatTime(math.max(0, getSongPosition() - noteOffset))..' / '..formatTime(songLength)..'')
    end
    
    setShaderFloat('timer', '_amount', math.max(0, getSongPosition() - noteOffset) / songLength)

    if not getModSetting('minimalUI') then
        setTextString('accuracyText', ratingName == '?' and '100%' or callMethodFromClass('backend.CoolUtil', 'floorDecimal', {100 * rating, 2})..'%')
        setTextString('missesText', callMethodFromClass('flixel.util.FlxStringUtil', 'formatMoney', {misses, false}))
        setTextString('scoreText', callMethodFromClass('flixel.util.FlxStringUtil', 'formatMoney', {score, false}))

        for _, t in ipairs({'timer', 'timerBG', 'alarmClock'}) do
            setProperty(t..'.alpha', getProperty('timeTxt.alpha'))
        end
    end

    for p = 1, 2 do
        setProperty('iconP'..p..'.origin.y', 0)
        setProperty('iconP'..p..'.scale.y', (getProperty('iconP'..p..'.scale.x') - 1) / -2.5 + 1)
    end

    for i = 0, getProperty('notes.length') - 1 do
        if getPropertyFromGroup('notes', i, 'isSustainNote') then
            local alpha = getPropertyFromGroup('notes', i, 'alpha')
            if alpha > 0 then
                setPropertyFromGroup('notes', i, 'alpha', 1)
            end
        end
    end

    -- For faster camera zooms
    setProperty('camera.zoom', smoothLerp(getProperty('camera.zoom'), getProperty('defaultCamZoom'), elapsed, 0.75, 1 / 1000))
    setProperty('camHUD.zoom', smoothLerp(getProperty('camHUD.zoom'), 1, elapsed, 0.75, 1 / 1000))
end

function onBeatHit()
    setProperty('iconP1.scale.x', math.max(1.05, 1 + getHealth() / 4))
    setProperty('iconP2.scale.x', math.max(1.05, 1 + (2 - getHealth()) / 4))
    doTweenX('bounceP1', 'iconP1.scale', 1, crochet / 1500, 'quintOut')
    doTweenX('bounceP2', 'iconP2.scale', 1, crochet / 1500, 'quintOut')
end

function opponentNoteHit(_, _, _, sustain)
	if sustain then
		setProperty('dad.holdTimer', 0)
	end
end 

function goodNoteHit(_, _, _, sustain)
	if sustain then
		setProperty('boyfriend.holdTimer', 0)
	end

    if sustain then return end -- so gf doesn't freak out when playing her cheer animation

    if combo % 50 == 0 and combo > 0 then
        triggerEvent('Play Animation', 'cheer', 'gf')
        setProperty('showCombo', true)
    else
        setProperty('showCombo', false)
    end
end 

function noteMiss()
    local song = songName:lower()
    local excluded = {
        ['vs-dave-rap'] = true,
        ['vs-dave-rap-two'] = true
    }

    if not excluded[song] then
        playSound(song == 'overdrive' and 'bad_disc' or 'missNote' .. getRandomInt(1, 3), song ~= 'overdrive' and getRandomFloat(0.1, 0.2) or nil)
    end

    if boyfriendName == 'bf-cool' then
        playSound('deathbell')
    end
end

function onEvent(name)
    if name == 'Change Character' then
        setProperty('timer.color', FlxColor('#'..rgbToHex(getProperty("dad.healthColorArray"))..''))
    end
end

function onDestroy()
    if getModSetting('minimalUI') then
        setPropertyFromClass('Main', 'fpsVar.visible', getPropertyFromClass('backend.ClientPrefs', 'data.showFPS'))
    end
    runHaxeCode([[
        import Main;
        import flixel.util.FlxStringUtil;
        import openfl.text.TextFormat;
        import openfl.system.System;

        Main.fpsVar.defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFF, false);
        Main.fpsVar.updateText = function() {
            var memBytes:Float = System.totalMemory;
            var memFormatted:String = FlxStringUtil.formatBytes(memBytes);

            Main.fpsVar.text = 'FPS: ' + Main.fpsVar.currentFPS +
            '\nMemory: ' + memFormatted;

            Main.fpsVar.textColor = 0xFFFFFFFF;
            if (Main.fpsVar.currentFPS < FlxG.drawFramerate * 0.5)
                Main.fpsVar.textColor = 0xFFFF0000;
        }
    ]])
    setPropertyFromClass('flixel.FlxG', 'stage.window.title', ogWindowTitle)
end