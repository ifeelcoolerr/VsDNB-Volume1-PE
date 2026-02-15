local shadname = "FLAG"

function makeBGSprite(var, image, x, y, scrollX, scrollY, animArray, loop)
    createInstance(var, 'objects.BGSprite', {image, x, y, scrollX, scrollY, animArray, loop})
end

function onCreate()
    setProperty('gf.alpha', 0)

    -- VOID

    makeLuaSprite('void', 'backgrounds/void/redsky', -250, -200)
    scaleObject('void', 0.7, 0.7, true)
    setProperty('void.alpha', 0)
    addLuaSprite('void')

	-- DAVE STAGE

	makeBGSprite('daveBg', 'backgrounds/shared/sky', -600, -400, 0.2, 0)
	scaleObject('daveBg', 0.4, 0.4, false)
	addLuaSprite('daveBg')

	makeBGSprite('stageHills', 'backgrounds/daveHouse/normal/hills', -834, -159, 0.35, 0.3)
	scaleObject('stageHills', 0.4, 0.4, false)
	addLuaSprite('stageHills')

	makeBGSprite('grassbg', 'backgrounds/daveHouse/normal/grass bg', -1205, 230, 0.65, 0.5)
	scaleObject('grassbg', 0.4, 0.4, false)
	addLuaSprite('grassbg')

	makeBGSprite('gate', 'backgrounds/daveHouse/normal/gate', -655, 225, 0.65, 0.75)
	scaleObject('gate', 0.4, 0.4, false)
	addLuaSprite('gate')

	makeBGSprite('stageFront', 'backgrounds/daveHouse/normal/grass', -932, 345, 0.8, 1)
	scaleObject('stageFront', 0.3, 0.3, false)
	addLuaSprite('stageFront')

	-- ROOM
	
	makeBGSprite('bg', 'backgrounds/tristanBackseat/backseat_bg', -550, -25)
	addLuaSprite('bg')

	makeBGSprite('tv', 'backgrounds/tristanBackseat/tv_bg', 0, 825)
	addLuaSprite('tv', true)
end

function onCreatePost()
	initLuaShader("FLAG")
	setSpriteShader('void', shadname)
end

function onUpdate(elapsed)
	setShaderFloat('void', 'uWaveAmplitude', 0.1)
	setShaderFloat('void', 'uFrequency', 5)
	setShaderFloat('void', 'uSpeed', 2)
end

function onUpdatePost(elapsed)
	setShaderFloat('void', 'uTime', os.clock())
end