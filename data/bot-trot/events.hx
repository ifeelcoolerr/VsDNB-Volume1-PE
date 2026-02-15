import flixel.math.FlxMath;
import flixel.math.FlxBasePoint;
import openfl.filters.ColorMatrixFilter;
import objects.Note;
import objects.Character;

enum BGType
{
    Room; Studio; Matrix;
}

var curBg:BGType = BGType.Room;

var greyscaleAmt:Float = 0.25;
var normal:Array<Float> = [
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0
];
var dark:Array<Float> = [
    0.7, 0, 0, 0, 0,
    0, 0.7, 0, 0, 0,
    0, 0, 0.7, 0, 0,
    0, 0, 0, 0.7, 0
];
var sepia:Array<Float> = [
    0.44, 0.44, 0.44, 0, 0,
    0.26, 0.26, 0.26, 0, 0,
    0.08, 0.08, 0.08, 0, 0,
    0, 0, 0, 1, 0
];
var colorMatrixShader:ColorMatrixFilter = new ColorMatrixFilter();

var blackHUD:FlxSprite;
var blackGame:FlxSprite;

var vignette:FlxSprite;

var bfSingTimer:FlxTimer = null;

var MATRIX_COLORS:Array<FlxColor> = [FlxColor.GREEN, FlxColor.BLUE, FlxColor.LIME, FlxColor.CYAN];

var matrixColorIndex = 0;

var alphaEcho:Float = 1;
var echoOffset:Float = 0.9;
var canFadeNotes:Bool = false;

var bfGhost:Character;

var playerStrumsDefaultX = [];
var dadDefaultY = [];

function onCreatePost()
{
    game.defaultCamZoom -= 0.1;

    blackHUD = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    blackHUD.scale.set(FlxG.width * 2, FlxG.height * 2);
    blackHUD.updateHitbox();
    blackHUD.screenCenter();
    blackHUD.cameras = [game.camHUD];
    blackHUD.alpha = 0.999;
    game.add(blackHUD);
        
    blackGame = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    blackGame.scale.set(FlxG.width * 4, FlxG.height * 4);
    blackGame.updateHitbox();
    blackGame.screenCenter();
    blackGame.alpha = 0.00001;
    game.add(blackGame);
        
    vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
    vignette.setGraphicSize(FlxG.width + 5, FlxG.height + 5);
    vignette.updateHitbox();
    vignette.screenCenter();
    vignette.scrollFactor.set();
    vignette.cameras = [game.camHUD];
    vignette.alpha = 0;
    vignette.color = FlxColor.BLACK;
    game.add(vignette);
}

function onCountdownStarted()
{
    for (i in 0...game.playerStrums.length)
    {
        playerStrumsDefaultX.push(game.playerStrums.members[i].x);
    }

    dadDefaultY.push(game.dad.y);
}

function goodNoteHit(note:Note)
{
    bfGhost.playAnim(singAnimations[note.noteData], true);
    bfGhost.holdTimer = 0;
}

function onSongStart()
{
    bfGhost = new Character(0, 0, game.boyfriend.curCharacter, true);
    bfGhost.scrollFactor.set();
    bfGhost.cameras = [game.camHUD];
    bfGhost.scale.set(2, 2);
    bfGhost.alpha = 0.3;
    game.add(bfGhost);

    bfGhost.x = - bfGhost.width;
    bfGhost.y = (FlxG.height - bfGhost.height) / 2;
    bfGhost.visible = false;
    bfGhost.flipX = !boyfriend.flipX;

    colorMatrixShader.matrix = getGreyscale();
    game.camGame.filters = [colorMatrixShader];
    game.camHUD.filters = [colorMatrixShader];

    tweenMatrix(normal, (Conductor.stepCrochet / 1250) * 110, FlxEase.quadIn);
        
    FlxTween.tween(blackHUD, {alpha: 0}, (Conductor.stepCrochet / 1250) * 110, {ease: FlxEase.quadIn});
    FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom + 0.2}, (Conductor.stepCrochet / 1250) * 110, {ease: FlxEase.quadIn});

    for (key in bfGhost.animOffsets.keys()) {
        bfGhost.animOffsets[key][0] *= bfGhost.scale.x;
        bfGhost.animOffsets[key][1] *= bfGhost.scale.y;
    }
}

function tweenMatrix(toMatrix:Array<Float>, time:Float, ease:FlxEase)
{
    var matrix = colorMatrixShader.matrix;
        
    for (i in 0...matrix.length) {
        FlxTween.num(matrix[i], toMatrix[i], time, {ease: ease}, function(num:Float) {
            matrix[i] = num;
                
            colorMatrixShader.matrix = matrix;
        });
    }
}

function getGreyscale():Array<Float>
{
    return [
        greyscaleAmt, greyscaleAmt, greyscaleAmt, 0, 0,
        greyscaleAmt, greyscaleAmt, greyscaleAmt, 0, 0,
        greyscaleAmt, greyscaleAmt, greyscaleAmt, 0, 0,
        0, 0, 0, 1, 0
    ];
}

var timer = ['alarmClock', 'timerBG', 'timer'];

var spacing = Note.swagWidth;

function onStepHit()
{
    switch(curStep)
    {
        case 112:
            game.defaultCamZoom += 0.2;
            triggerEvent('Play Animation', 'game', 'dad');
        case 128:
            game.defaultCamZoom -= 0.2;
         case 256:
            game.defaultCamZoom += 0.1;
        case 384, 896:
            game.defaultCamZoom = 0.65;
            if (curStep == 896) {
                FlxTween.tween(vignette, {alpha: 0.8}, 0.5);
            } else {
                game.camHUD.filters = [];
                FlxTween.tween(vignette, {alpha: 1}, 0.5);
            }
        case 512:
            game.defaultCamZoom = 0.8;
            tweenMatrix(dark, 0.5, FlxEase.backOut);
            FlxTween.tween(vignette, {alpha: 0}, 0.5);
        case 640:
            game.defaultCamZoom = 0.7;
        case 768, 832:
            game.defaultCamZoom = 0.9;
        case 800:
            game.defaultCamZoom -= 0.2;
        case 864:
            game.defaultCamZoom = 0.65;
        case 1024:
            tweenMatrix(normal, 0.5, FlxEase.backOut);
            FlxTween.tween(vignette, {alpha: 0}, 0.5);
        case 1088:
            FlxTween.tween(blackHUD, {alpha: 1}, 0.5, {onComplete: function(tween:FlxTween) {
                FlxG.camera.zoom = game.defaultCamZoom = 0.7;
                switchToStudio();
                game.dad.y += 150;
                    
                colorMatrixShader.matrix = sepia;
                                        
                bfSingTimer = new FlxTimer().start(0, function(t:FlxTimer) 
                {
                    triggerEvent('Play Animation', singAnimations[FlxG.random.int(0, singAnimations.length-1)], 'bf');
                    bfSingTimer.reset(0.1);
                });
            }});

            game.boyfriend.cameraPosition[0] = 50;
            game.boyfriend.cameraPosition[1] = 70;
        case 1099:
            FlxTween.tween(blackHUD, {alpha: 0}, 0.5);
            game.camHUD.filters = [colorMatrixShader];
        case 1130:
            boyfriend.playAnim('singDOWNmiss', true);
            bfSingTimer.cancel();
        case 1134:
            triggerEvent('Play Animation', 'messedUp', 'dad');
        case 1408:
            game.defaultCamZoom += 0.1;
            FlxTween.tween(vignette, {alpha: 0.6}, 0.5);
        case 1600:
            transitionToMatrix();

            game.boyfriend.cameraPosition[0] = -100;
            game.boyfriend.cameraPosition[1] = 100;
        case 1664:
            tweenMatrix(normal, 0.5, FlxEase.quadIn);
            FlxTween.tween(blackHUD, {alpha: 0}, 0.5);
            FlxTween.tween(vignette, {alpha: 0}, 0.5);
                
            switchToMatrix();
        case 1824:
            if (!ClientPrefs.data.middleScroll)
            {
                for (i in 0...game.playerStrums.length)
                {
                    FlxTween.tween(game.playerStrums.members[i], {x: 412 + (i * 112)}, 1 / game.playbackRate, {ease: FlxEase.sineInOut, startDelay: 0.25 + (i * 0.05)});
                }

                for (name in timer) {
                    var spr = getVar(name);
                    if (spr != null) {
                        FlxTween.tween(spr, {x: spr.x - 300}, 1, {ease: FlxEase.sineInOut});
                    }
                }
                FlxTween.tween(timeTxt, {x: timeTxt.x - 300}, 1, {ease: FlxEase.sineInOut});
            }
        case 2164:
            bfGhost.visible = true;
            FlxTween.tween(bfGhost, {x: FlxG.width}, (Conductor.stepCrochet * 140) / 1000, {onComplete: function(t:FlxTween) {
                bfGhost.visible = false;
            }});
        case 1884, 1924, 1964, 2004, 2044, 2084, 2104, 2124, 2144:
            switchMatrixColors();
        case 2324:
            switchBackToRoom();        
    }
}

function onBeatHit()
{
    if (curBeat % 2 == 0)
    {
        if(bfGhost.animation.curAnim.finished)
            bfGhost.dance();
    }
}

function switchToStudio()
{
    curBg = BGType.Studio;

    getVar('backWall').visible = true;
    getVar('micSetup').visible = true;
    getVar('studio').visible = true;
    getVar('speakersLeft').visible = true;
    getVar('speakersRight').visible = true;
    getVar('keyboard').visible = true;
    getVar('couch').visible = true;

    getVar('room').visible = false;

    gf.visible = false;

    triggerEvent('Change Character', 'dad', 'playrobot-studio');
}

function transitionToMatrix()
{
    getVar('matrix').visible = true;
    getVar('binaryVideo').visible = true;

    getVar('matrix').alpha = 0;
    getVar('binaryVideo').alpha = 0;

    var transitionTime = (Conductor.stepCrochet / 1000) * 224;

    curBg = BGType.Matrix;

    for (i in [game.dad, game.gf])
    {
        if (i != null)
        {
            FlxTween.tween(i, {alpha: 0}, transitionTime);
        }
    }

    for (i in 0...opponentStrums.members.length)
    {
        var spr = opponentStrums.members[i];
        if (spr != null) FlxTween.tween(spr, {alpha: 0}, transitionTime);
    }

    var studioStageBGs = ['backWall', 'micSetup', 'studio', 'speakersLeft', 'speakersRight', 'keyboard', 'couch'];

    for (name in studioStageBGs) {
        var spr = getVar(name);

        if (spr != null) {
            FlxTween.tween(spr, {alpha: 0}, transitionTime);
        }
    }

    FlxTween.tween(game.iconP2, {alpha: 0}, transitionTime);

    var curZoom:Float = game.defaultCamZoom;
    FlxTween.tween(game, {defaultCamZoom: curZoom - 0.2}, transitionTime);
}

function switchToMatrix()
{
    getVar('matrix').visible = true;
    getVar('binaryVideo').visible = true;

    var matrixStage = ['matrix', 'binaryVideo'];

    for (name in matrixStage) {
        var spr = getVar(name);
        if (spr != null) {
            FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 160);
        }
    }
}

function switchMatrixColors()
{
    matrixColorIndex = (matrixColorIndex + 1 > MATRIX_COLORS.length - 1) ? 0 : matrixColorIndex + 1;       
    switchColors(MATRIX_COLORS[matrixColorIndex]);
}

function switchBackToRoom()
{
    curBg = BGType.Room;
        
    game.dad.y = dadDefaultY;
        
    game.defaultCamZoom = 0.7;

    triggerEvent('Change Character', 'dad', 'playrobot');
    triggerEvent('Play Animation', 'confused', 'dad');

    getVar('room').visible = true;
    getVar('room').alpha = 1;

    gf.visible = true;

    var transitionTime:Float = 1;

    FlxTween.tween(getVar('matrix'), {alpha: 0}, transitionTime);
    FlxTween.tween(getVar('binaryVideo'), {alpha: 0}, transitionTime);

    for (i in [game.dad, game.gf])
    {
        FlxTween.tween(i, {alpha: 1}, transitionTime);
    }

    for (i in 0...opponentStrums.members.length)
    {
        var spr = opponentStrums.members[i];
        if (spr != null) FlxTween.tween(spr, {alpha: 1}, transitionTime);
    }

    for (name in timer) {
        var spr = getVar(name);
        if (spr != null) {
            FlxTween.tween(spr, {x: spr.x + 300}, 1, {ease: FlxEase.sineInOut});
        }
    }
    FlxTween.tween(timeTxt, {x: timeTxt.x + 300}, 1, {ease: FlxEase.sineInOut});

    FlxTween.tween(game.iconP2, {alpha: 1}, transitionTime);

    for (i in 0...game.playerStrums.length)
    {
        FlxTween.tween(game.playerStrums.members[i], {x: playerStrumsDefaultX[i]}, 1 / game.playbackRate, {ease: FlxEase.sineInOut, startDelay: 0.25 + (i * 0.05)});
    }
}
