local handled = false

function onUpdate(elapsed)
    if handled then return end

    if getVar('dialogueFinishedE') == true then
        handled = true
        openCustomSubstate('toBeContinued', true)
    end
end

function onCustomSubstateCreate(name)
    if name ~= 'toBeContinued' then return end
    toBeContinued()
end

function toBeContinued()
    doTweenAlpha('camHUDFade', 'camHUD', 0, 0.5)

    makeLuaSprite('black')
    makeGraphic('black', screenWidth, screenHeight, 'black')
    setObjectCamera('black', 'other')
    setProperty('black.alpha', 0)
    addLuaSprite('black')
    doTweenAlpha('blackFade', 'black', 1, 0.5)

    makeLuaText('text', 'To Be Continued', 0, 0, 0)
    setTextFont('text', 'comic.ttf')
    setTextSize('text', 36)
    setTextAlignment('text', 'center')
    screenCenter('text')
    setProperty('text.alpha', 0)
    setObjectCamera('text', 'other')
    addLuaText('text')
    doTweenAlpha('textFade', 'text', 1, 0.5)

    runTimer('continueTimer', 2)
end

function onTimerCompleted(tag)
    if tag == 'continueTimer' then
        closeCustomSubstate()
        endSong()
    end
end
