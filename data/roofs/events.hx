var focusOnGF:Bool;
function onUpdatePost(elapsed)
{
    if (focusOnGF)
    {
        game.moveCameraToGirlfriend();
    }
}
function opponentNoteHitPre(note:Note)
{
    if (note.mustPress == false)
    {
        if (dad.animation.curAnim.name == "talk")
        {
            note.noAnimation = true;
        }
    }
}

function onStepHit()
    {
        switch (curStep)
        {
            case 12:
                FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom + 0.2}, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.backInOut});
            case 16:
                game.defaultCamZoom = 0.7;
            case 72:
                game.defaultCamZoom += 0.1;
            case 76:
                game.defaultCamZoom += 0.1;
            case 256:
                game.defaultCamZoom += 0.1;
            case 259, 262:
                game.defaultCamZoom += 0.05;
            case 266:
                FlxTween.tween(game, {defaultCamZoom: 0.7}, (Conductor.stepCrochet / 1250) * 2, {ease: FlxEase.backInOut});
            case 384:
                game.defaultCamZoom = 0.9;
            case 396:
                focusOnGF = true;
            case 400:
                game.defaultCamZoom = 0.6;
            case 448, 832:
                game.defaultCamZoom += 0.2;
            case 464, 848:
                game.defaultCamZoom -= 0.1;
            case 496, 880:
                game.defaultCamZoom += 0.1;
            case 512:
                FlxG.camera.zoom = game.defaultCamZoom = 1;
            case 528:
                game.dad.skipDance = true;
                game.dad.specialAnim = true;
                game.dad.playAnim('talk', true);
                
                focusOnGF = false;
                game.defaultCamZoom = 0.9;
            case 652:
                FlxTween.tween(game, {defaultCamZoom: 0.7}, (Conductor.stepCrochet / 1250) * 4, {ease: FlxEase.elasticInOut});
            case 600:
                game.dad.skipDance = false;
                game.dad.specialAnim = false;
                game.dad.dance();
            case 688:
                FlxTween.tween(game, {defaultCamZoom: 0.6}, (Conductor.stepCrochet / 1250) * 2, {ease: FlxEase.elasticOut});
            case 720:
                game.defaultCamZoom = 0.9;
            case 768:
                game.camGame.snapToTarget();
                game.defaultCamZoom = 0.8;
            case 771, 774:
                game.defaultCamZoom -= 0.05;
            case 776:
                focusOnGF = true;
            case 780:
                game.defaultCamZoom = 1;
            case 784:
                game.defaultCamZoom = 0.7;
            case 918:
                game.camGame.snapToTarget();
                focusOnGF = false;
        }
    }