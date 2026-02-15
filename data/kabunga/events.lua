luaDebugMode = true
local follow = true
function onMoveCamera(character)
    if not follow then
        if character == 'boyfriend' then
            callMethod('camGame.snapToTarget', {})
        elseif character == 'dad' then
            callMethod('camGame.snapToTarget', {})
        end
    end
end
function onCreatePost()
    makeLuaSprite('skullBody', 'backgrounds/exbungo/skullbody')
    setGraphicSize('skullBody', getProperty('boyfriend.width'))
    updateHitbox('skullBody')
    setProperty('skullBody.x', getProperty('boyfriend.x') + (getProperty('boyfriend.width') - getProperty('skullBody.width')) / 2)
    setProperty('skullBody.y', getProperty('boyfriend.y') + (getProperty('boyfriend.height') - getProperty('skullBody.height')) / 2)
    setProperty('skullBody.alpha', 0)
    addLuaSprite('skullBody', true)
end

function onStepHit()
    if curStep == 272 then
        follow = false
        runTimer('camOff', 0)
    end
end