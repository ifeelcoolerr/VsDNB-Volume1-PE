function onStartCountdown()
    return Function_Stop
end

local score = 0

local endings = {
    {
        min = 100000,
        music = 'goodEnding',
        sprite = 'goodEnding',
        image = 'endings/bambi/good_bambi',
        anim = 'good_bambi',
        title = 'Good Ending',
        desc = 'You have a nice picnic with your friends at Bambi\'s Farm.\nEverything goes well!\nBut Dave has a challenge for you...'
    },
    {
        min = 62500,
        music = 'badEnding',
        sprite = 'badEnding',
        image = 'endings/bambi/bad_bambi',
        anim = 'bad_bambi',
        title = 'Bad Ending',
        desc = 'You have a nice picnic with your friends at Bambi\'s Farm.\nGirlfriend forgot to bring any food though...\nBut Dave has a challenge for you!'
    },
    {
        min = 0,
        music = 'badEnding',
        sprite = 'worstEnding',
        image = 'endings/bambi/worst_bambi',
        anim = 'worst_bambi',
        title = 'Worst Ending',
        desc = 'You have a nice picnic with your friends at Bambi\'s Farm.\nSomeone snuck a rock in your sandwich though, ouch.\nBut Dave has a challenge for you!'
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
