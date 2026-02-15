import hxvlc.flixel.FlxVideoSprite;
import objects.BGSprite;

var matrix:BGSprite;
var binaryVideo:FlxVideoSprite;

function onCreate()
{
    matrix = new BGSprite('backgrounds/playrobot/matrix/matrix_bg', -180, 100);
    matrix.scale.set(1.5 * (1 / 0.9), 1.5 * (1 / 0.9));
    matrix.updateHitbox();
    matrix.scrollFactor.set();
    matrix.screenCenter();
    matrix.antialiasing = false;
    matrix.color = FlxColor.GREEN;
    matrix.active = false;
    matrix.visible = false;
    addBehindGF(matrix);

    binaryVideo = new FlxVideoSprite();
    binaryVideo.antialiasing = false;
    binaryVideo.scrollFactor.set();
    binaryVideo.color = FlxColor.LIME;
    binaryVideo.bitmap.onFormatSetup.add(onFormatChange);
    binaryVideo.bitmap.onTimeChanged.add(onTimeChange);
    binaryVideo.visible = false;
    addBehindGF(binaryVideo);

    binaryVideo.bitmap.load(Paths.video('binary'));
    binaryVideo.play();

    setVar('matrix', matrix);
    setVar('binaryVideo', binaryVideo);
}

function onFormatChange():Void
{
    binaryVideo.setGraphicSize(FlxG.width * (1 / defaultCamZoom), FlxG.height * (1 / defaultCamZoom));
    binaryVideo.updateHitbox();
    binaryVideo.screenCenter();
}

function onTimeChange():Void
{
    if (binaryVideo.bitmap == null)
        return;

    if (binaryVideo.bitmap.time > 2700)
    {
        if (binaryVideo.bitmap != null)
            binaryVideo.bitmap.time = 0;
    }
}

game.setOnHScript('switchColors', function(newColor:FlxColor){
    matrix.color = newColor;
    binaryVideo.color = newColor;   
});

function onPause()
{
    binaryVideo.bitmap.pause();
}
    
function onResume()
{
    binaryVideo.bitmap.resume();
}