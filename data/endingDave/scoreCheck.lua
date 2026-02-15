function onStartCountdown()
    return Function_Stop
end

local score = 0

local endings = {
    {
        min = 87500,
        music = 'goodEnding',
        sprite = 'goodEnding',
        image = 'endings/dave/good_dave',
        anim = 'good_dave',
        title = 'Good Ending',
        desc = 'You helped Dave escape the third dimension!\nIn turn, Dave offers you and your girlfriend an invitation...'
    },
    {
        min = 50000,
        music = 'badEnding',
        sprite = 'badEnding',
        image = 'endings/dave/bad_dave',
        anim = 'bad_dave',
        title = 'Bad Ending',
        desc = 'You helped Dave escape the third dimension\nand received an invitation from Dave!\nHowever, your fly was down...'
    },
    {
        min = 0,
        music = 'badEnding',
        sprite = 'worstEnding',
        image = 'endings/dave/worst_dave',
        anim = 'worst_dave',
        title = 'Worst Ending',
        desc = 'You helped Dave escape the third dimension\nand received an invitation from Dave!\nHowever, you passed out from exhaustion.'
    }
}

function onCreate()
    initSaveData('scoreCheckDave')
    score = getDataFromSave('scoreCheckDave', 'score') or 0

    makeLuaSprite('black')
    makeGraphic('black', screenWidth, screenHeight, 'black')
    setObjectCamera('black', 'other')
    addLuaSprite('black')

    for _, ending in ipairs(endings) do
        if score >= ending.min then
            loadEnding(ending)
            break
        end
    end

    cameraFade('other', 'black', 0.8, true, true)
end

function loadEnding(e)
    playMusic(e.music, 1, true)

    makeAnimatedLuaSprite(e.sprite, e.image)
    addAnimationByPrefix(e.sprite, 'idle', e.anim)
    playAnim(e.sprite, 'idle', true)
    setObjectCamera(e.sprite, 'other')
    screenCenter(e.sprite)
    setProperty(e.sprite..'.y', getProperty(e.sprite..'.y') - 100)
    addLuaSprite(e.sprite)

    makeCenteredText(e.sprite..'Title', e.title, 55, 460)
    makeCenteredText(e.sprite..'Desc', e.desc, 24, 550)
end

function makeCenteredText(tag, text, size, y)
    makeLuaText(tag, text, 0, 0, y)
    setTextFont(tag, 'comic_normal.ttf')
    setTextSize(tag, size)
    setTextAlignment(tag, 'center')
    setProperty(tag..'.antialiasing', true)
    screenCenter(tag, 'x')
    setObjectCamera(tag, 'other')
    addLuaText(tag)
end

function onUpdate()
    if keyJustPressed('accept') then
        endIt()
    end

    if keyboardJustPressed('R') then
        restartSong()
    end
end

function endIt()
    setDataFromSave('scoreCheckDave', 'score', 0)
    flushSaveData('scoreCheckDave')
    endSong()
end
