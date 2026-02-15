luaDebugMode = false

local curState = ''
local allowKeys = false
local allowEndSong = false
local dialogueTriggered = false
local hasEndDialogue = false
local dialogueFile = {}
local dialogueIndex = 1

local soundFiles = {
    dave = 'daveDialogue',
    bf = 'bfDialogue',
    gf = 'gfDialogue',
    tristan = 'trisDialogue',
    bambi = 'bambDialogue'
}

local typingText
local typingString = ''
local typingIndex = 1
local typingActive = false
local typingSound = 'dialogue/bfDialogue'
local typeSpeed = 0.04

local currentSpeaker = nil
local speakers = {}
local tweenCounter = 0
local leftX, rightX = 100, 800
local offscreenLeft, offscreenRight = -10, 900

local TYPE_SOUND_TAG = 'dialogueTyping'

setVar('curState', curState)

function onCreatePost()
    if not isStoryMode then return end
    local path = 'data/dialogue/'..songName:lower()..'-endDialogue.json'
    local raw = getTextFromFile(path)
    -- Detects if the dialogue file is null, if not then continue.
    if raw and raw ~= '' then
        dialogueFile = callMethodFromClass('tjson.TJSON', 'parse', {raw})
        if dialogueFile.dialogue and #dialogueFile.dialogue > 0 then
            hasEndDialogue = true
            dialogueIndex = 1
        end
    end
end

local function getDialogueLine()
    if dialogueFile.dialogue and dialogueIndex <= #dialogueFile.dialogue then
        return dialogueFile.dialogue[dialogueIndex]
    end
    return nil
end

function onEndSong()
    if not hasEndDialogue then return Function_Continue end
    if seenCutscene then return Function_Continue end
    if dialogueTriggered then return Function_Stop end

    dialogueTriggered = true
    startDialogue()
    return Function_Stop
end

local fontMap = {
    setfont_code = "barcode",
    setfont_normal = "comic"
}

function createTypeText(text, sound, font, x, y)
    if not text then return end
    if typingText then removeLuaText(typingText, true) end

    typingText = 'typingText'
    typingString = text
    typingIndex = 1
    typingActive = true
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
    setObjectOrder(typingText, getObjectOrder('dialogueBox')+1)
    addLuaText(typingText)

    runTimer('typeChar', typeSpeed, 1)
end


function startDialogue()
    curState = 'dialogueInitial'
    allowKeys = false
    setProperty('inCutscene', true)

    playMusic(dialogueFile.music or 'DaveDialogue', 1, true)

    makeLuaSprite('bgDialogue', 500, -200)
    makeGraphic('bgDialogue', screenWidth*1.3, screenHeight*1.3, 'FF8A9AF5')
    setObjectCamera('bgDialogue', 'other')
    setProperty('bgDialogue.alpha', 0)
    addLuaSprite('bgDialogue')

    makeAnimatedLuaSprite('dialogueBox', 'ui/dialogue/speech_bubble_talking', 50, 380)
    addAnimationByPrefix('dialogueBox', 'none', 'chatboxnone', 24, true)
    addAnimationByPrefix('dialogueBox', 'norm', 'chatboxnorm', 24, true)
	addOffset('dialogueBox', 'norm', nil, 50)
    setObjectCamera('dialogueBox', 'other')
    setProperty('dialogueBox.alpha', 0)
    setObjectOrder('dialogueBox', getObjectOrder('bgDialogue')+1)
    addLuaSprite('dialogueBox')

    doTweenAlpha('boxIn', 'dialogueBox', 1, 1)
    doTweenAlpha('bgIn', 'bgDialogue', 0.7, 1)

    runTimer('actualDialogue', 0.8)
end


local dialogueCounter = 0
local lastDialogue = -1

function dialogueUpdate()
    if not allowKeys then return end

    if keyJustPressed('accept') then
        if typingActive then
			setTextString(typingText, typingString)
			typingActive = false
            stopSound(TYPE_SOUND_TAG)
		else
			dialogueCounter = dialogueCounter + 1
		end
    end

    if dialogueCounter ~= lastDialogue then
        local line = getDialogueLine()
        if not line then dialogueEnd() return end

        stopSound(TYPE_SOUND_TAG)

        Speaker(line.side == 'left', line.speaker, line.expression)
        local sound = soundFiles[line.speaker] and ('dialogue/'..soundFiles[line.speaker])
        createTypeText(line.text, sound, fontMap[line.modifier], 150, 430)

        typeSpeed = line.typeSpeed or 0.04
        dialogueIndex = dialogueIndex + 1
        lastDialogue = dialogueCounter
    end
    setVar('dialogueCounter', dialogueCounter) -- Used for dialogue events.
end

local currentSpeaker = nil
local yPos = 100
local tweenCounter = 0
local leftX, rightX = 100, 800
local offscreenLeft, offscreenRight = -10, 900

local speakers = {}

function Speaker(leftBool, charName, charExpression)
    local side = leftBool and 'left' or 'right'
    local xTarget = leftBool and leftX or rightX
    local startX = leftBool and offscreenLeft or offscreenRight
    local yPos = stringStartsWith(charName, 'dave') and 30 or 100

    if charExpression == "normal" then
        charExpression = "happy"
    end
    charExpression = charExpression or "happy"

    if currentSpeaker and currentSpeaker ~= charName and getProperty(currentSpeaker..'.exists') then
        local prevX = getProperty(currentSpeaker..'.x')
        local offscreenX = (prevX < 400) and offscreenLeft or offscreenRight
        doTweenX('moveOut_'..currentSpeaker, currentSpeaker, offscreenX, 0.5, 'easeIn')
        setProperty(currentSpeaker..'.alpha', 0)
    end

    if luaSpriteExists(charName) then
        removeLuaSprite(charName, true)
    end

    makeLuaSprite(charName, 'ui/dialogue/portraits/'..charName..'/'..charName..'_'..charExpression, startX, yPos)
    setObjectCamera(charName, 'other')
    addLuaSprite(charName, true)
    setObjectOrder(charName, getObjectOrder('dialogueBox')-1)
    setProperty(charName..'.alpha', 0)

    tweenCounter = tweenCounter + 1
    doTweenX('moveIn_'..charName..'_'..tweenCounter, charName, xTarget, 0.2, 'linear')
    doTweenAlpha('fadeIn_'..charName..'_'..tweenCounter, charName, 1, 0.2, 'linear')

    currentSpeaker = charName

    if not tableContains(speakers, charName) then
        table.insert(speakers, charName)
    end

    playAnim('dialogueBox', 'norm', true)
    setProperty('dialogueBox.flipX', not leftBool)
end

function tableContains(t,val)
    for i=1,#t do if t[i]==val then return true end end
    return false
end

function onTimerCompleted(tag)
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

    if tag=='actualDialogue' then
        allowKeys = true
        curState = 'dialogue'
    end
end

function dialogueEnd()
    curState='dialogueEnd'
    allowKeys=false

    doTweenAlpha('boxOut','dialogueBox',0,1)
    doTweenAlpha('bgOut','bgDialogue',0,1)
    if typingText then doTweenAlpha('textOut',typingText,0,1) end

    for _,sp in ipairs(speakers) do
        if getProperty(sp..'.exists') then doTweenAlpha('fadeOut_'..sp,sp,0,1) end
    end    
end

function onTweenCompleted(tag)
    if tag == 'bgOut' then
        setVar('dialogueFinishedE', true)
        seenCutscene=true
        allowEndSong=true
        setProperty('inCutscene',false)
        endSong()
    end
end

function onUpdatePost(elapsed)
    if dialogueTriggered and curState =='dialogue' then
        dialogueUpdate()
    end
end
