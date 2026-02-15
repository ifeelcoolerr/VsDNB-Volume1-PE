luaDebugMode = true
function onCreate()
    if dadName == 'tristan-backseat-opponent' then
        setProperty('dad.x', getProperty('dad.x')-680)
    end
    if boyfriendName == 'tristan-backseat' then
        setProperty('dad.x', getProperty('dad.x')-65)
    end
    if boyfriendName == 'playrobot-backseat' then
        setProperty('boyfriend.x', getProperty('boyfriend.x')-660)
        setProperty('boyfriend.y', getProperty('boyfriend.y')-30)
    end
end

function onCountdownStarted()
    if difficultyName:lower() == 'playrobot' then
        for i = 0, 3 do
            setProperty("opponentStrums.members["..i.."].x", _G["defaultPlayerStrumX" ..i])
            setProperty("playerStrums.members["..i.."].x", _G["defaultOpponentStrumX" .. i])
        end
    end
end

function onSectionHit()
    if difficultyName == 'playrobot' then
        if not mustHitSection then
            cameraSetTarget('bf')
        else
            cameraSetTarget('dad')
        end
    end
end