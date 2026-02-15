function onCreate()
    makeLuaSprite('hall1', 'backgrounds/insideHouse/hall1_bg', -485, 200)
    setScrollFactor('hall1', 0.9, 0.9)
    addLuaSprite('hall1')

    makeLuaSprite('hall2', 'backgrounds/insideHouse/hall2_bg', 1730, 170)
    setScrollFactor('hall2', 0.9, 0.9)
    addLuaSprite('hall2')

    makeLuaSprite('bg', 'backgrounds/insideHouse/inside_house', -717, -286)
    addLuaSprite('bg')

    makeLuaSprite('tv', 'backgrounds/insideHouse/tv_bg', -130, 206)
    addLuaSprite('tv')
end

local couchData = {}
local defaultCouch = {
    'backgrounds/insideHouse/couchbop_bg',
    'couchbopbf'
}
local altCouch = {
    'backgrounds/insideHouse/couchbop_bg_alt',
    'couchbopalt',
    true
}

function goodNoteHitPre(index, noteData, noteType, isSustain)
    setProperty('comboGroup.x', 800)
    setProperty('comboGroup.y', 50)
end

function changeCouch()
    if boyfriendName == 'playrobot-playable' or boyfriendName == 'tristan-playable' or boyfriendName == 'tristan-golden' then
        couchData = altCouch
    else
        couchData = defaultCouch
    end
    makeAnimatedLuaSprite('couch', couchData[1], 283, 305)
    local loop = couchData[3] or false
    addAnimationByPrefix('couch', 'idle', couchData[2], 24, loop)
    addLuaSprite('couch')
end

function onCountdownTick(counter)
    couchDance()
end

function onBeatHit()
    if curBeat % 2 == 0 then
        couchDance()
    end
end

function couchDance()
    playAnim('couch', 'idle', true)
end