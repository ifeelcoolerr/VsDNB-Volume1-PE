local shadname = "FLAG"

function onCreate()
	makeLuaSprite('bg', 'backgrounds/void/redsky', -1900, -700);
	setScrollFactor('bg', 0.6, 0.6); 
	scaleObject('bg', 1.5,1.5,true)
	addLuaSprite('bg', false);
end

function onCreatePost()
	initLuaShader("FLAG")
	setSpriteShader('bg', shadname)
end
	
function onUpdate(elapsed)
	setShaderFloat('bg', 'uWaveAmplitude', 0.1)
	setShaderFloat('bg', 'uFrequency', 5)
	setShaderFloat('bg', 'uSpeed', 2)
end

function onUpdatePost(elapsed)
	setShaderFloat('bg', 'uTime', os.clock())
end