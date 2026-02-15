// how come it works in hscript and not lua??
import flixel.math.FlxBasePoint;

import flixel.addons.display.FlxBackdrop;

var lazychartshader:FlxRuntimeShader = createRuntimeShader("glitchEffect");

var pos:FlxBasePoint = FlxBasePoint.get(298, 131);

var skull:FlxBackdrop;

function onCreate()
{
    initLuaShader("glitchEffect");

    lazychartshader.setFloat("uWaveAmplitude", 0.03);
    lazychartshader.setFloat("uTime", 0);
    lazychartshader.setFloat("uFrequency", 5);
    lazychartshader.setFloat("uSpeed", 1);
    lazychartshader.setFloat("uAlpha", 1);
    lazychartshader.setBool("enableAlpha", false);
    
    game.camHUD.setFilters([new ShaderFilter(lazychartshader)]);

    skull = new FlxBackdrop(Paths.image('backgrounds/exbungo/skull'));
    skull.frames = Paths.getSparrowAtlas('backgrounds/exbungo/skull', 'shared');
    skull.animation.addByPrefix('idle', 'moving', 24);
    skull.animation.play('idle', true);
    skull.scrollFactor.set();
    skull.velocity.y = 200;
    skull.alpha = 0.0001;
    addBehindGF(skull);
}

function onUpdate(elapsed:Float)
{
    lazychartshader.setFloat('uTime', lazychartshader.getFloat('uTime') + elapsed);
}

function onStepHit() 
{
    switch(curStep)
    {
        case 15:
            FlxTween.linearMotion(game.dad, game.dad.x, game.dad.y, 25, 3000, 20, true, {
                onUpdate: (t:FlxTween) -> {
                    game.camZooming = true;
                }
            });
        case 528:
            var skullBody = game.getLuaObject('skullBody');
            FlxTween.tween(skull, {alpha: 1}, 1);

            skullBody.alpha = 1;
            game.boyfriend.visible = false;
                
            game.gf.playAnim('sad', true);
            game.gf.animation.curAnim.looped = true;
        case 1321:
            game.freezeCamera = true;
            game.dad.setPosition(pos.x, pos.y);
    }
    
}