import flixel.addons.text.FlxTypeText;
import flixel.text.FlxTextBorderStyle;

import sys.FileSystem;
import tjson.TJSON;

var subtitlesData = [];
var subtitleIndex = 0;
var subtitlesEnabled = false;

var subtitle:Dynamic = null;

function onCreate()
{
    if (!FileSystem.exists(Paths.getPath('data/subtitles/' + PlayState.SONG.song.toLowerCase() + '.json')))
        return;

    subtitle = TJSON.parse(Paths.getTextFromFile('data/subtitles/' + PlayState.SONG.song.toLowerCase() + '.json'));
    subtitlesData = subtitle.subtitles ?? [];

    subtitlesEnabled = subtitlesData.length > 0;
}

function secondsToStep(sec:Float):Int
    return Conductor.getStep(sec * 1000);

function createTypeText(text:String, typeSpeed:Float, showTime:Float, subtitleSize:Int)
{
    var subtitles = new FlxTypeText((FlxG.width / 2) - 650, (FlxG.height / 2) - 200, FlxG.width, text, 36);
    subtitles.setFormat(Paths.font("comic-sans.ttf"), subtitleSize, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    subtitles.antialiasing = true;
    subtitles.borderSize = 2;
    subtitles.cameras = [camOther];
    subtitles.start(typeSpeed, false, false, [], function() {
        new FlxTimer().start(showTime, function(timer:FlxTimer) {
            FlxTween.tween(subtitles, {alpha: 0}, 0.5 / game.playbackRate, {onComplete: function(twn:FlxTween) {
                    remove(subtitles);
                    subtitles.destroy();
                }
            });
        });
    });
    add(subtitles);
}

function onStepHit()
{
    if (!subtitlesEnabled || subtitleIndex >= subtitlesData.length)
        return;

    var currentSubtitle = subtitlesData[subtitleIndex];
    var targetStep = secondsToStep(currentSubtitle.time);

    if (curStep >= targetStep)
    {
        createTypeText(currentSubtitle.key, subtitle.typeSpeed ?? 0.02, subtitle.duration ?? 1, currentSubtitle.subtitleSize ?? 36);
        subtitleIndex += 1;
    }
}