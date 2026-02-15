import openfl.filters.BlurFilter;

var blur:BlurFilter = new BlurFilter(0, 0, 5);
var mosaic:FlxRuntimeShader = createRuntimeShader("mosaic");

function onStepHit()
{
    switch(curStep)
    {
        case 1932:
            game.camGame.setFilters([blur]);
            FlxTween.tween(blur, {blurX: 30}, (Conductor.stepCrochet / 1000) * 84); 
        case 2048:
            mosaic.setFloatArray('blockSize', [1, 1]);

            game.camGame.setFilters([
                blur,
                new ShaderFilter(mosaic.shader)
            ]);

            FlxTween.num(1, 200.0, (Conductor.stepCrochet / 1250) * 36, null, (v:Float) -> {
                mosaic.setFloatArray('blockSize', [v, v]);
            });
    }
}