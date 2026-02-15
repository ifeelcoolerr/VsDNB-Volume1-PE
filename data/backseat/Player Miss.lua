local isMissCharacter = false

local tristanX, tristanY = 0, 0
local playrobotX, playrobotY = 0, 0

function onCreate()
    addCharacterToList('tristan-backseat-miss', 'bf')
    addCharacterToList('playrobot-backseat-miss', 'bf')
end

function onCreatePost()
    if boyfriendName == 'tristan-backseat' then
        tristanX = getProperty('boyfriend.x')
        tristanY = getProperty('boyfriend.y')
    end

    if boyfriendName == 'playrobot-backseat' then
        playrobotX = getProperty('boyfriend.x')
        playrobotY = getProperty('boyfriend.y')
    end
end

function noteMiss(i)
    local dir = getPropertyFromGroup('notes', i, 'noteData')
    local anim = ({'singLEFTmiss','singDOWNmiss','singUPmiss','singRIGHTmiss'})[dir+1]

    if boyfriendName == 'tristan-backseat' then
        triggerEvent('Change Character', 'bf', 'tristan-backseat-miss')
        playAnim('boyfriend', anim, true)
        isMissCharacter = true
        setProperty('boyfriend.x', tristanX)
        setProperty('boyfriend.y', tristanY)
    end

    if boyfriendName == 'playrobot-backseat' then
        triggerEvent('Change Character', 'bf', 'playrobot-backseat-miss')
        playAnim('boyfriend', anim, true)
        isMissCharacter = true
        setProperty('boyfriend.x', playrobotX)
        setProperty('boyfriend.y', playrobotY)
    end
end

function goodNoteHit()
    if boyfriendName == 'tristan-backseat-miss' then
        triggerEvent('Change Character', 'bf', 'tristan-backseat')

        setProperty('boyfriend.x', tristanX)
        setProperty('boyfriend.y', tristanY)
    end
    if boyfriendName == 'playrobot-backseat-miss' then
        triggerEvent('Change Character', 'bf', 'playrobot-backseat')

        setProperty('boyfriend.x', playrobotX)
        setProperty('boyfriend.y', playrobotY)
    end
end

function onUpdatePost()
    if isMissCharacter then
        local anim = getProperty('boyfriend.animation.curAnim.name')
        local finished = getProperty('boyfriend.animation.curAnim.finished')

        if finished and anim:find("miss") then
            if difficultyName:lower() == 'tristan' then
                triggerEvent('Change Character', 'bf', 'tristan-backseat')
                setProperty('boyfriend.x', tristanX)
                setProperty('boyfriend.y', tristanY)
            else
                triggerEvent('Change Character', 'bf', 'playrobot-backseat')
                setProperty('boyfriend.x', playrobotX)
                setProperty('boyfriend.y', playrobotY)
            end
            isMissCharacter = false
        end
    end
end
