import objects.StrumNote; // hooray dave
import backend.Song;

var black:FlxSprite;
var vignette:FlxSprite;

var dave:Character;
var bambi:Character;

var daveStrumline:Strumline;

var baseStrumsDaveY = [];

var opponentCamGameActive:Bool;

// BAMBI'S VOICE LINES IS IN THE LUA FILE!!!

var forceVingette:Bool;

function onCreatePost()
{
    black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    black.scale.set(FlxG.width * 2, FlxG.height * 2);
    black.updateHitbox();
    black.scrollFactor.set();
    black.screenCenter();
    black.alpha = 0;
    add(black);

    vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
    vignette.screenCenter();
    vignette.scrollFactor.set();
    vignette.cameras = [camHUD];
    vignette.alpha = 0.0001;
    vignette.color = FlxColor.BLACK;
    add(vignette);
}

function moveExistingOpponentNotesToCamGame()
{
        for (note in game.notes)
        {
            if (!note.mustPress)
            {
                note.cameras = [game.camGame];
                note.visible = true;
                note.alpha = 1;
                game.add(note);
            }
        }
}

function onSpawnNote(note:Note)
{
    if (opponentCamGameActive){
        if (!note.mustPress)
            {
                note.cameras = [game.camGame];
                note.visible = true;
                note.alpha = 1;
                game.add(note);
            }
        }
}

function fixOpponentNotes() {
    for (note in game.notes) {
        if (!note.mustPress) {
            var dir = note.noteData;
            note.cameras = [game.camGame];
            note.scrollFactor.set(1, 1);
            note.alpha = 1;
            note.x = game.opponentStrums.members[dir].x;
            note.y = game.opponentStrums.members[dir].y;
        }
    }

    for (note in game.unspawnNotes) {
        if (!note.mustPress) {
            var dir = note.noteData;
            note.cameras = [game.camGame];
            note.scrollFactor.set(1, 1);
            note.x = game.opponentStrums.members[dir].x;
            note.y = game.opponentStrums.members[dir].y;
        }
    }
}


function onStepHit()
{
    if (forceVingette)
    {
        vignette.visible = false;
    }
    else
    {
        vignette.visible = true;
    }
    switch(curStep)
    {
        case 112:
            FlxTween.tween(black, {alpha: 0.6}, 0.5);
        case 128:
            FlxTween.tween(black, {alpha: 0}, 0.5);
        case 156:
            FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom + 0.2}, 0.25, {ease: FlxEase.backOut});
        case 608:
            FlxTween.tween(black, {alpha: 0.4}, 0.5);
        case 635:
            FlxTween.tween(game, {defaultCamZoom: 1.1}, 0.1, {ease: FlxEase.backInOut});
        case 640:
            FlxTween.tween(black, {alpha: 0}, 0.5);
        case 784 | 816:
            defaultCamZoom = FlxG.camera.zoom = 1; 
        case 896:
            FlxTween.tween(black, {alpha: 0.4}, 0.5);
        case 928:
            FlxTween.tween(black, {alpha: 0}, 0.5);
            FlxTween.tween(game, {defaultCamZoom: 0.8}, Conductor.stepCrochet / 1000, {ease: FlxEase.backIn});
        case 1168 | 1170 | 1172 | 1174 | 1176 | 1178:
            black.alpha += 0.1;
        case 1180:
            FlxTween.tween(black, {alpha: 1}, 0.5);
        case 1186:
            FlxTween.tween(black, {alpha: 0}, 0.5);
        case 1216 | 1280:
            FlxTween.tween(vignette, {alpha: 0.5}, 0.2);
        case 1248:
            FlxTween.tween(vignette, {alpha: 0}, 0.2);
        case 1296:
            FlxTween.tween(vignette, {alpha: 0.3}, 0.2);
        case 1312:
            FlxTween.tween(vignette, {alpha: 0}, 0.5);
        case 1440:
            forceVingette = true;
            opponentCamGameActive = true;
            if (opponentCamGameActive)
            {
                moveExistingOpponentNotesToCamGame();
                fixOpponentNotes();
            }
        case 1692:
            game.camGame.zoom = game.defaultCamZoom = 0.9;
        case 1888:
            forceVingette = false;
            FlxTween.tween(vignette, {alpha: 0.7}, 0.5);
            game.defaultCamZoom = 1.1;
        case 1952:
            game.defaultCamZoom = 0.9;
            FlxTween.tween(vignette, {alpha: 0.4}, 0.5);
        case 2080:
            FlxTween.tween(vignette, {alpha: 0}, 0.5);
    }
}