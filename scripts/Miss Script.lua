-- Detects if the player's miss animation is nil/null.

local hasMissAnimsTriggered = false
local originalColor = nil
local usedBlueFallback = false

function onSongStart()
    originalColor = getProperty('boyfriend.color')

    local hasMissAnims =
        callMethod('boyfriend.hasAnimation', {'singLEFTmiss'}) or
        callMethod('boyfriend.hasAnimation', {'singDOWNmiss'}) or
        callMethod('boyfriend.hasAnimation', {'singUPmiss'}) or
        callMethod('boyfriend.hasAnimation', {'singRIGHTmiss'})

    if hasMissAnims then
        hasMissAnimsTriggered = true
    else
        hasMissAnimsTriggered = false
    end
end

function noteMiss(_, d, _, _)
    if hasMissAnimsTriggered then return end
    playAnim('boyfriend', getProperty('singAnimations')[d+1], true)
    if boyfriendName ~= 'tristan-backseat-miss' and boyfriendName ~= 'tristan-backseat' and boyfriendName ~= 'playrobot-backseat' and boyfriendName ~= 'playrobot-backseat-miss' then
        setProperty('boyfriend.color', FlxColor('BLUE'))
    end
    usedBlueFallback = true
end

function onUpdate()
    if usedBlueFallback then
        local anim = getProperty('boyfriend.animation.curAnim.name')
        if anim == 'idle' or anim == 'danceLeft' or anim == 'danceRight' then
            setProperty('boyfriend.color', originalColor)
            usedBlueFallback = false
        end
    end
end
