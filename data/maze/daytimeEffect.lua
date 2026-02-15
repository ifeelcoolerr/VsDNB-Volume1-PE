luaDebugMode = true

local sunsetColor = 'FF8FB2'
local nightColor  = '51557A'

local tweenTime = 0
local tweenList = {}

local bgObjects = {'flatgrass', 'hills', 'farmhouse', 'grassLand', 'cornFence', 'cornFence2', 'cornBag', 'sign'}

function sectionStartTime(section)
    local daPos = 0
    for i = 0, section do
        daPos = daPos + 4 * (1000 * 60 / bpm)
    end
    return daPos
end

function onCountdownStarted()
    makeLuaSprite('sunsetBG', 'backgrounds/shared/sky_sunset', -600, -200)
    setScrollFactor('sunsetBG', 0.6, 0.6)
    setProperty('sunsetBG.alpha', 0)
    setObjectOrder('sunsetBG', getObjectOrder('bg'))
    addLuaSprite('sunsetBG')

    makeLuaSprite('nightBG', 'backgrounds/shared/sky_night', -600, -200)
    setScrollFactor('nightBG', 0.6, 0.6)
    setProperty('nightBG.alpha', 0)
    setObjectOrder('nightBG', getObjectOrder('flatgrass'))
    addLuaSprite('nightBG')

    tweenTime = sectionStartTime(25)

    for _, bgSprite in ipairs({'bg', 'sunsetBG'}) do
        local tweenName = bgSprite..'Tween'

        if bgSprite == 'bg' then
            doTweenAlpha(tweenName, bgSprite, 0, tweenTime / 1000)
            table.insert(tweenList, tweenName)
        elseif bgSprite == 'sunsetBG' then
            doTweenAlpha(tweenName ..'_in', bgSprite, 1, tweenTime / 1000)
            runTimer('sunsetFadeOut_'..bgSprite, tweenTime / 1000, 1)
            table.insert(tweenList,tweenName..'_in')
        elseif bgSprite == 'nightBG' then
            doTweenAlpha(tweenName..'_out', bgSprite, 0, tweenTime / 1000)
            runTimer('nightFadeIn_'..bgSprite, tweenTime / 1000, 1)
            table.insert(tweenList, tweenName..'_out')
        end
    end

    doTweenColor('gfTween', 'gfGroup', sunsetColor, tweenTime / 1000)
    doTweenColor('dadTween', 'dad', sunsetColor, tweenTime / 1000)
    doTweenColor('bfTween', 'boyfriendGroup', sunsetColor, tweenTime / 1000)

    for _, obj in ipairs(bgObjects) do
        doTweenColor(obj..'Color', obj, sunsetColor, tweenTime / 1000)
    end

    runTimer('sunsetToNight', tweenTime / 1000, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if string.find(tag, 'sunsetFadeOut_') then
        local bg = string.gsub(tag, 'sunsetFadeOut_', '')
        doTweenAlpha(bg..'_out', bg, 0, tweenTime / 1000)
    elseif string.find(tag, 'nightFadeIn_') then
        local bg = string.gsub(tag, 'nightFadeIn_', '')
        doTweenAlpha(bg..'_in', bg, 1, tweenTime / 1000)
    elseif tag == 'sunsetToNight' then
        doTweenColor('gfTweenNight', 'gfGroup', nightColor, tweenTime / 1000)
        doTweenColor('dadTweenNight', 'dad', nightColor, tweenTime / 1000)
        doTweenColor('bfTweenNight', 'boyfriendGroup', nightColor, tweenTime / 1000)

        doTweenAlpha('nightBG_in', 'nightBG', 1, tweenTime / 1000)

        for _, obj in ipairs(bgObjects) do
            doTweenColor(obj..'NightColor', obj, nightColor, tweenTime / 1000)
        end
    end
end

function onSongStart()
    for _, tweenName in ipairs(tweenList) do
        if string.find(tweenName, 'Tween') then
            local sprite = string.gsub(tweenName, 'Tween.*', '')
            if sprite == 'sunsetBG' or sprite == 'nightBG' then
                setProperty(sprite..'.alpha', 0)
                doTweenAlpha(tweenName, sprite, 1, tweenTime / 1000)
            end
        end
    end
end