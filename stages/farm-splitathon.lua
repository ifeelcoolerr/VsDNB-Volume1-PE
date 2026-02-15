luaDebugMode = true
local nightColor = '51557A'
function onCreate()
    local bagType = getRandomInt(0, 1000) == 0 and 'popeye' or 'cornbag'
    makeLuaSprite('bg', 'backgrounds/shared/sky_night', -600, -200)
    setScrollFactor('bg', 0.3, 0.3)
    addLuaSprite('bg')

    makeLuaSprite('flatgrass', 'backgrounds/farm/gm_flatgrass', 350, 55)
    setScrollFactor('flatgrass', 0.55, 0.55)
    setGraphicSize('flatgrass', callMethodFromClass('Std', 'int', {getProperty('flatgrass.width') * 0.34}))
    addLuaSprite('flatgrass')

    makeLuaSprite('hills', 'backgrounds/farm/orangey hills', -473, 100)
    setScrollFactor('hills', 0.65, 0.65)
    addLuaSprite('hills')

    makeLuaSprite('farmhouse', 'backgrounds/farm/funfarmhouse', 100, 125)
    setScrollFactor('farmhouse', 0.7, 0.7)
    setGraphicSize('farmhouse', callMethodFromClass('Std', 'int', {getProperty('farmhouse.width') * 0.9}))
    addLuaSprite('farmhouse')

    makeLuaSprite('grassLand', 'backgrounds/farm/grass lands', -600, 500)
    addLuaSprite('grassLand')

    makeLuaSprite('cornFence', 'backgrounds/farm/cornFence', -700, 200)
    addLuaSprite('cornFence')

    makeLuaSprite('cornFence2', 'backgrounds/farm/cornFence2', 1100, 250)
    addLuaSprite('cornFence2')

    makeLuaSprite('sign', 'backgrounds/farm/sign', 0, 350)
    addLuaSprite('sign')

    for _, v in ipairs({'boyfriend', 'gf', 'dad', 'flatgrass', 'hills', 'farmhouse', 'grassLand', 'cornFence', 'cornFence2', 'bagType', 'sign'}) do
        setProperty(v..'.color', getColorFromHex(nightColor))
    end

    makeAnimatedLuaSprite('cornbagsplit', 'backgrounds/farm/cornbag_splitathon', 1355, 435)
    addAnimationByPrefix('cornbagsplit', 'a', 'cornbag_tristan', 24, true)
    scaleObject('cornbagsplit', 0.9, 0.9, true)
    addLuaSprite('cornbagsplit')

    makeLuaSprite('picnic', 'backgrounds/farm/picnic_towel_thing', 1350, 650)
    addLuaSprite('picnic')

    for _, v in ipairs({'cornbagsplit', 'picnic'}) do
        setProperty(v..'.color', getColorFromHex(nightColor))
    end
end