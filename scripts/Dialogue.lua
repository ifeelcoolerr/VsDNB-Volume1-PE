luaDebugMode = false

local allowCountdown = false

local curState = '' -- three states: dialogueInital, dialogue, dialogueEnd

setVar('curState', curState)

local TYPE_SOUND_TAG = 'dialogueTyping'

local allowKeys = false

local dialogueFile = {}

local soundFiles = {
    ['dave'] = 'daveDialogue',
    ['bf'] = 'bfDialogue',
    ['gf'] = 'gfDialogue',
    ['tristan'] = 'trisDialogue',
    ['bambi'] = 'bambDialogue'
}

local speakerCache = {}
local switchingSpeaker = false

local function getDialogueLine()
    return dialogueFile.dialogue and dialogueFile.dialogue[dialogueIndex]
end

function onStartCountdown()
    if isStoryMode and not allowCountdown and not seenCutscene then
        local path = 'data/dialogue/'..songName:lower()..'.json'
        local raw = getTextFromFile(path)
        -- Detects if the dialogue file is null, if not then continue.
        if raw == nil or raw == '' then
            allowCountdown = true
            return Function_Continue
        end
        startDialogue()
        return Function_Stop
    end
    return Function_Continue
end


function onUpdatePost(elapsed)
    if not isStoryMode then return end
    if seenCutscene then return end

    if curState == 'dialogueInital' then
        allowKeys = false
    else
        allowKeys = true
    end

    if curState == 'dialogue' then
        dialogueUpdate()
        cameraSetTarget('gf')
    end
end

function onUpdate(elapsed)
    if not isStoryMode then return end
    if seenCutscene then return end

    if luaDebugMode then
        if keyboardJustPressed('Z') then
            dialogueEnd()
        end
        if keyboardJustPressed('R') then
            restartSong()
        end
        if keyboardJustPressed('Q') then
            endSong()
        end
    end
end

function onCreate()
    if not isStoryMode then return end
    if seenCutscene then return end

    local path = 'data/dialogue/'..songName:lower()..'.json'
    local rawJson = getTextFromFile(path)

    if rawJson == nil or rawJson == '' then
        dialogueFile = {}
        return
    end

    dialogueFile = callMethodFromClass('tjson.TJSON', 'parse', {rawJson})

    expression = dialogueFile.expression
    modifier = dialogueFile.modifier
    side = dialogueFile.side
    speaker = dialogueFile.speaker
    text = dialogueFile.text
    typeSpeed = dialogueFile.typeSpeed

    dialogueIndex = 1
end

local fontMap = {
    setfont_code = "barcode",
    undistort = "barcode",
    distort = "barcode",
    setfont_normal = "comic"
}

function createTypeText(text, sound, font, x, y)
    if not text then return end

    if typingText then
        removeLuaText(typingText, true)
        typingText = nil
    end

    typingText = 'typingText'
    typingString = text
    typingIndex = 1
    typingActive = true
    typeSpeed = typeSpeed or 0.04
    typingSound = sound or 'dialogue/bfDialogue'
    typingFont = font or 'comic'

    typingX = x or 150
    typingY = y or 430

    makeLuaText(typingText, "", 0, typingX, typingY)
    setTextFont(typingText, typingFont..'.ttf')
    setTextSize(typingText, 30)
    setTextBorder(typingText, 0, 'none')
    setTextWidth(typingText, getProperty('dialogueBox.width') - 90)
    setTextColor(typingText, 'black')
    setProperty(typingText..'.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    setObjectCamera(typingText, 'other')
    setTextAlignment(typingText, 'left')
    addLuaText(typingText)

    runTimer('typeChar', typeSpeed, 1)
end

function startDialogue()
    curState = 'dialogueInital'

    playMusic(dialogueFile.music or 'DaveDialogue', 1, true)

    setProperty('inCutscene', true)

    runTimer('actualDialogue', 1)

	makeLuaSprite('bgDialogue', -500, -200)
	makeGraphic('bgDialogue', screenWidth * 1.3, screenHeight * 1.3, 'FF8A9AF5')
	setObjectCamera('bgDialogue', 'other')
	setProperty('bgDialogue.alpha', 0)
	addLuaSprite('bgDialogue')
	setObjectOrder('bgDialogue', 0)

    makeAnimatedLuaSprite('dialogueBox', 'ui/dialogue/speech_bubble_talking', 50, 380)
    addAnimationByPrefix('dialogueBox', 'none', 'chatboxnone', 24, true)
    addAnimationByPrefix('dialogueBox', 'norm', 'chatboxnorm', 24, true)
	addOffset('dialogueBox', 'norm', nil, 50)
    setObjectCamera('dialogueBox', 'other')
    setProperty('dialogueBox.alpha', 0)
    addLuaSprite('dialogueBox')

    doTweenAlpha('dialougeBoxAlpha', 'dialogueBox', 1, 2)
	doTweenAlpha('bgDialogueA', 'bgDialogue', 0.7, 4.15)
end

local dialogueCounter = 1
local lastDialogue = 0

function dialogueUpdate()
	if allowKeys then
   		if keyJustPressed('accept') then
            if typingActive then
                setTextString(typingText, typingString)
                typingActive = false
                stopSound(TYPE_SOUND_TAG)
            elseif not switchingSpeaker then
                dialogueCounter = dialogueCounter + 1
            end
        end

    	if dialogueCounter ~= lastDialogue then
            local line = getDialogueLine()

            stopSound(TYPE_SOUND_TAG)

            if not line then
                dialogueEnd()
                return
            end

            Speaker(line.side == 'left', line.speaker, line.expression)

            local sound = soundFiles[line.speaker] and ('dialogue/' .. soundFiles[line.speaker])

            local text = line.text
            createTypeText(text, sound, fontMap[line.modifier], 150, 430)

            typeSpeed = line.typeSpeed or 0.04

            dialogueIndex = dialogueIndex + 1
            lastDialogue = dialogueCounter
        end
        setVar('dialogueCounter', dialogueCounter) -- Used for dialogue events.
	end
end

local currentSpeaker = nil
local yPos = 100
local tweenCounter = 0
local leftX, rightX = 100, 800
local offscreenLeft, offscreenRight = -10, 900

local speakers = {}

function Speaker(leftBool, charName, charExpression)
    if switchingSpeaker then return end
    switchingSpeaker = true

    local side = leftBool and 'left' or 'right'
    local xTarget = leftBool and leftX or rightX
    local startX = leftBool and offscreenLeft or offscreenRight
    local yPos = stringStartsWith(charName, 'dave') and 30 or 100

    charExpression = ((charExpression == "normal" and "happy") or (charExpression or "happy")):gsub("_", "-")

    if currentSpeaker and currentSpeaker ~= charName and speakerCache[currentSpeaker] then
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg(currentSpeaker)})
        local prevX = getProperty(currentSpeaker..'.x')
        local offX = (prevX < 400) and offscreenLeft or offscreenRight
        doTweenX('outX_'..currentSpeaker, currentSpeaker, offX, 0.25, 'easeIn')
        setProperty(currentSpeaker..'.alpha', 0)
    end

    if not speakerCache[charName] then
        makeLuaSprite(charName, 'ui/dialogue/portraits/'..charName..'/'..charName..'_'..charExpression:gsub("_","-"), startX, yPos)
        setObjectCamera(charName, 'other')
        addLuaSprite(charName, true)
        speakerCache[charName] = true
    else
        loadGraphic(charName, 'ui/dialogue/portraits/'..charName..'/'..charName..'_'..charExpression:gsub("_","-"))
    end

    callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg(charName)})
    setProperty(charName..'.x', startX)
    setProperty(charName..'.alpha', 0)

    doTweenX('inX_'..charName, charName, xTarget, 0.2, 'linear')
    doTweenAlpha('inA_'..charName, charName, 1, 0.2, 'linear')

    setObjectOrder(charName, 1)
    currentSpeaker = charName

    playAnim('dialogueBox', 'norm', true)
    setProperty('dialogueBox.flipX', not leftBool)

    speakerCache[charName] = true

    if not tableContains(speakers, charName) then
        table.insert(speakers, charName)
    end

    runTimer('unlockSpeaker', 0.25)
end


function tableContains(t, val)
    for i=1,#t do
        if t[i] == val then return true end
    end
    return false
end

function actualDialogue()
    curState = 'dialogue'
end

function dialogueEnd()
	curState = 'dialogueEnd'

	for _, i in ipairs({'dialogueBox', 'bgDialogue'}) do
		doTweenAlpha('ok'..i, i, 0, 1)
	end
	for i, sp in ipairs(speakers) do
        if getProperty(sp..'.exists') then
            doTweenAlpha('spea'..sp, sp, 0, 1)
        end
    end
	soundFadeOut(_, 1, 0)
	if typingText then
        doTweenAlpha('dialogueText', typingText, 0, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'typeChar' and typingActive then
        if typingIndex <= #typingString then
            setTextString(typingText, getTextString(typingText)..typingString:sub(typingIndex, typingIndex))

            if typingString:sub(typingIndex, typingIndex) ~= " " then
                if currentSpeaker == "bambi" then
                    local randomSound = 'dialogue/bambDialogue'..getRandomInt(1,3)
                    playSound(randomSound, 1, TYPE_SOUND_TAG)
                else
                    playSound(typingSound, 1, TYPE_SOUND_TAG)
                end
            end

            typingIndex = typingIndex + 1
            runTimer('typeChar', typeSpeed, 1)
        else
            typingActive = false
        end
    end

    if tag == 'unlockSpeaker' then
        switchingSpeaker = false
    end

    if tag == 'actualDialogue' then
        allowKeys = true
    end
end

function onTweenCompleted(tag)
    if tag == 'dialougeBoxAlpha' then
        allowKeys = true
        actualDialogue()
    end
	if tag == 'okdialogueBox' then
		destroy()
		allowCountdown = true
		startCountdown()
	end
end

function destroy()
	setVar('dialogueFinishedS', true)
	
    if typingText then
        removeLuaText(typingText, true)
        typingText = nil
        typingActive = false
        typingString = ""
        typingIndex = 1
    end

    if getProperty('dialogueBox') then
        removeLuaSprite('dialogueBox', true)
    end

    for i, sp in ipairs(speakers) do
        if getProperty(sp..'.exists') then
            removeLuaSprite(sp, true)
        end
    end
    speakers = {}
    currentSpeaker = nil

    if getProperty('bgDialogue') then
        removeLuaSprite('bgDialogue', true)
    end
end
