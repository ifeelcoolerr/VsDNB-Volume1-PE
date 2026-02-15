local floatyCharacters = {'dave-angey'}
local canFloat = true
local elapsedtime = 0
local dadY = 0

local function contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then return true end
    end
    return false
end

function onCreate()
    if curStage == 'red-void' and contains(floatyCharacters, dadName:lower()) then
        dadY = getProperty('dad.y')
        setProperty('dad.y', dadY + 80)
        dadY = getProperty('dad.y')
    end
end

function onUpdate(elapsed)
    if contains(floatyCharacters, dadName:lower()) and canFloat then
        elapsedtime = elapsedtime + elapsed
        setProperty('dad.y', dadY + math.sin(elapsedtime * 2) * 20)
    end
end
