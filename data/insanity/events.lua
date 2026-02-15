local shadname = "FLAG"
luaDebugMode = true

local ogDad = ''
function onCreate()
    ogDad = dadName

    makeLuaSprite('wavybg', 'backgrounds/void/redsky_insanity', -1900, -700); -- X and Y
	scaleObject('wavybg', 1.5,1.5,true)

    makeLuaSprite('wavybg2', 'backgrounds/void/redsky', -1900, -700); -- X and Y
	scaleObject('wavybg2', 1.5,1.5,true) 

    addCharacterToList('dave-angey-insanity', 'dad')
    precacheImage('backgrounds/void/redsky_insanity')
    precacheImage('backgrounds/void/redsky')
end
function onCreatePost()
	initLuaShader("FLAG")
	setSpriteShader('wavybg', shadname)

    setSpriteShader('wavybg2', shadname)
end
function onUpdate(elapsed)
    setShaderFloat('wavybg', 'uWaveAmplitude', 0.1)
	setShaderFloat('wavybg', 'uFrequency', 5)
	setShaderFloat('wavybg', 'uSpeed', 2)

    setShaderFloat('wavybg2', 'uWaveAmplitude', 0.1)
	setShaderFloat('wavybg2', 'uFrequency', 5)
	setShaderFloat('wavybg2', 'uSpeed', 2)
end

function onStepHit()
    if curStep == 384 or curStep == 1040 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 448 or curStep == 1056 then
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 512 then
        setProperty('defaultCamZoom', 1)
    elseif curStep == 640 then
        setProperty('defaultCamZoom', 1.1)
    elseif curStep == 660 or curStep == 680 then
        playSound('static', 0.1)
        triggerEvent('Change Character', 'Dad', 'dave-angey-insanity')
        addLuaSprite('wavybg')
    elseif curStep == 664 or curStep == 684 then
        removeLuaSprite('wavybg', false)
        triggerEvent('Change Character', 'Dad', ogDad)
    elseif curStep == 708 then
        triggerEvent('Play Animation', 'um', 'Dad')
        setProperty('defaultCamZoom', 0.8)
    elseif curStep == 768 then
        setProperty('defaultCamZoom', 0.7)
    elseif curStep == 784 then
        setProperty('defaultCamZoom', 0.9)
    elseif curStep == 1176 then
        playSound('static', 0.1)
        triggerEvent('Change Character', 'Dad', 'dave-angey-insanity')
        addLuaSprite('wavybg2')
    elseif curStep == 1180 then
        triggerEvent('Change Character', 'Dad', ogDad)
        playAnim('dad', 'scared', false)
        runTimer('stopScared', 0.25 / playbackRate)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'stopScared' then
        triggerEvent('Play Animation', 'scared-loop', 'Dad')
    end
end

function onUpdatePost(elapsed)
    setShaderFloat('wavybg', 'uTime', os.clock())
    setShaderFloat('wavybg2', 'uTime', os.clock())
end