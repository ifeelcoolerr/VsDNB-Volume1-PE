luaDebugMode = true

local spotLightElapsed = 0
local spotLightPart = false
local spotLightScaler = 1.3

function onCreate()
    precacheImage('spotLight')

    makeLuaSprite('spotLight', 'spotLight')
    setBlendMode('spotLight', 'add')
    setGraphicSize('spotLight', math.floor(getProperty('dad.width') * spotLightScaler))
    callMethod('spotLight.origin.set', {getProperty('spotLight.origin.x'), getProperty('spotLight.origin.y') - (getProperty('spotLight.frameHeight') / 2)})
    addLuaSprite('spotLight', true)

    setProperty('spotLight.x', getProperty('dad.x') + (getProperty('dad.width') - getProperty('spotLight.width') / 2))
    setProperty('spotLight.y', getMidpointY('dad') - (getProperty('spotLight.height') / 2))

    setProperty('spotLight.alpha', 0.001)
end

function onUpdate(elapsed)
    if spotLightPart then
        spotLightElapsed = spotLightElapsed + elapsed
        setProperty('spotLight.angle', math.sin(spotLightElapsed * 2) * 3)
    end
end

function onStepHit()
    if curBeat % 4 == 0 and spotLightPart then
        runHaxeFunction('updateSpotlight', {mustHitSection})
    end

    if curStep == 912 then
        if not spotLightPart then
            spotLightPart = true
            setProperty('defaultCamZoom', getProperty('defaultCamZoom')-0.1)
            cameraFlash('game', 'white', 0.5)
            setProperty('spotLight.alpha', 1)

            runHaxeFunction('updateSpotlight', {false})
        end
    end

    if curStep == 1168 then
        spotLightPart = false
        doTweenAlpha('spotLightAlpha', 'spotLight', 0, 1)
    end
end

function onTweenCompleted(tag)
    if tag == 'spotLightAlpha' then
        removeLuaSprite('spotLight')
    end
end

runHaxeCode([[
    import flixel.math.FlxBasePoint;
    import objects.Character;

    var lastSinger:Character;

    function updateSpotlight(bfSinging:Bool)
	{
		var curSinger = bfSinging ? boyfriend : dad;

		if (lastSinger != curSinger)
		{
            if (gf.hasAnimation('singRIGHT') || gf.hasAnimation('singLEFT'))
            {
                gf.stunned = true;
			    bfSinging ? gf.playAnim("singRIGHT", true) : gf.playAnim("singLEFT", true);
			    gf.animation.finishCallback = function(anim:String)
			    {
                    gf.stunned = false;
			    }
            }

			var targetPosition = FlxBasePoint.get();

			targetPosition.x = curSinger.x + (curSinger.width - game.getLuaObject("spotLight").width) / 2;
            targetPosition.y = curSinger.getMidpoint().y - (game.getLuaObject("spotLight").height / 2);
			
			FlxTween.tween(game.getLuaObject("spotLight"), {x: targetPosition.x, y: targetPosition.y}, 0.66, {ease: FlxEase.circOut});
			lastSinger = curSinger;
		}
	}
]])