import objects.StrumNote;
import objects.HealthIcon;
import backend.Paths;
import flixel.FlxSprite;
import backend.Conductor;
import flixel.math.FlxBasePoint;
import objects.Character;

var baseStrumY = [];
var iterator:Int = 0;
var nightColor:FlxColor = 0xFF51557A;

var blackScreen:FlxSprite;
var whiteScreen:FlxSprite;
var vignette:FlxSprite;
var loopCount:Int = 0;
var loopTimer:FlxTimer;

var crazyZooming:Bool;
var crazyZooming2:Bool;

var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
var stupidx:Float = 0;
var stupidy:Float = 0; 
var updatevels:Bool = false;

var backgroundChar:Character;
var backgroundChar2:Character;
var gopoopoomode:Bool;

function onCountdownStarted() {
    var ind:Int = 0;
    for (strum in game.opponentStrums) {
        FlxTween.cancelTweensOf(strum);
        strum.alpha = 0;
        strum.y += 10;
        baseStrumY[ind] = strum.y;
        ind += 1;
    }
        
    for (strum in game.playerStrums) {
        FlxTween.cancelTweensOf(strum);
        strum.alpha = 0;
        strum.y += 10;
        baseStrumY[ind] = strum.y;
        ind += 1;
    }
}

function onCreatePost() {
    blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    blackScreen.scale.set(FlxG.width * 2, FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.alpha = 0.0001;
    add(blackScreen);

    whiteScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
    whiteScreen.scale.set(FlxG.width * 2, FlxG.height * 2);
    whiteScreen.updateHitbox();
    whiteScreen.scrollFactor.set();
    whiteScreen.screenCenter();
    whiteScreen.alpha = 0.0001;
    add(whiteScreen);

    vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
    vignette.screenCenter();
    vignette.scrollFactor.set();
    vignette.cameras = [camHUD];
    vignette.alpha = 0.0001;
    vignette.color = FlxColor.BLACK;
    add(vignette);

    backgroundChar = new Character(game.dad.x, game.dad.y, 'dave-splitathon', false);
    backgroundChar.visible = false;
    backgroundChar.color = nightColor;
    addBehindDad(backgroundChar);

    backgroundChar2 = new Character(game.dad.x - 225, game.dad.y + 245, 'bambi-splitathon', false);
    backgroundChar2.visible = false;
    backgroundChar2.color = nightColor;
    addBehindBF(backgroundChar2);
    
}

function onBeatHit() {
    if (camZooming && game.curBeat % 16 == 0 || crazyZooming) {
        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.03;
    }
    if (camZooming && game.curBeat % 2 == 0 || crazyZooming2) {
        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.03;
    }

    if (backgroundChar2.curCharacter == 'dave-splitathon' && backgroundChar2.curCharacter != 'bambi-splitathon')
    {
        backgroundChar2.dance();
    }
}

function onUpdate(elapsed:Float) {

    if (updatevels) {
        stupidx *= 0.98;
        stupidy += elapsed * 6;
        if (BAMBICUTSCENEICONHURHURHUR != null) {
            BAMBICUTSCENEICONHURHURHUR.x += stupidx;
            BAMBICUTSCENEICONHURHURHUR.y += stupidy;
        }
    }

    if (backgroundChar2.animation.curAnim != null &&
        backgroundChar2.animation.curAnim.name == "idle-transition" &&
        backgroundChar2.animation.curAnim.finished) {
        backgroundChar2.playAnim('idle', true);
    }

    if (backgroundChar.animation.curAnim != null &&
        backgroundChar.animation.curAnim.name == "interrupt2dissapoint" &&
        backgroundChar.animation.curAnim.finished) {
        backgroundChar.playAnim('dissapointedidle', true); // oops
    }
}

function loopCountTimer(loopTimes:Int, resetTime:Float, func:Void->Void) {
    loopCount = 0;
    loopTimer = new FlxTimer().start(0, function(timer:FlxTimer) {
        if (loopCount <= loopTimes) {
            func();
            loopCount += 1;
            timer.reset(resetTime);
        } else {
            loopTimer.cancel();
            loopTimer = null;
        }
    });
}

function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void {
    iconP2.animation.play("bambi-new", true);
    BAMBICUTSCENEICONHURHURHUR.animation.play(PlayState.SONG.player2, true, false, 1);
    stupidx = -5;
    stupidy = -5;
    updatevels = true;
}

function interpolateColor(c1:Int, c2:Int, t:Float):Int {
    if (t < 0) t = 0;
    if (t > 1) t = 1;

    var a1 = (c1 >> 24) & 0xFF;
    var r1 = (c1 >> 16) & 0xFF;
    var g1 = (c1 >> 8) & 0xFF;
    var b1 = c1 & 0xFF;

    var a2 = (c2 >> 24) & 0xFF;
    var r2 = (c2 >> 16) & 0xFF;
    var g2 = (c2 >> 8) & 0xFF;
    var b2 = c2 & 0xFF;

    var a = Std.int(a1 + (a2 - a1) * t);
    var r = Std.int(r1 + (r2 - r1) * t);
    var g = Std.int(g1 + (g2 - g1) * t);
    var b = Std.int(b1 + (b2 - b1) * t);

    return (a << 24) | (r << 16) | (g << 8) | b;
}

function splitathonFlare(fadeIn:Float, delayCount:Float, fadeOutTime:Float) {
    var toTween:Array<Dynamic> = [dadGroup, gf, boyfriend, backgroundChar, backgroundChar2];

    var luaSprites = [
        'flatgrass', 'hills', 'farmhouse', 'grassLand',
        'cornFence', 'cornFence2', 'bagType', 'sign', 'cornbagsplit',
        'picnic'
    ];

    for (name in luaSprites) {
        var spr = getLuaObject(name);
        if (spr != null)
            toTween.push(spr);
    }

    for (i in 0...toTween.length) {
        var spr = toTween[i];
        if (spr == null) continue;

        FlxTween.color(spr, fadeIn, nightColor, FlxColor.WHITE, {
            startDelay: i * delayCount,
            onComplete: function(tween:FlxTween) {
                FlxTween.color(spr, fadeOutTime, FlxColor.WHITE, nightColor, {ease: FlxEase.sineOut});
            }
        });
    }
}

function splitathonDuoFlare(fadeIn:Float, delayCount:Float, fadeOutTime:Float) {
    var toTween:Array<Dynamic> = [game.dad, game.gf, game.boyfriend, backgroundChar2, backgroundChar];

    var luaSprites = ['flatgrass', 'hills', 'farmhouse', 'grassLand', 'cornFence', 'cornFence2', 'bagType', 'sign', 'cornbagsplit', 'picnic'];
    for (name in luaSprites) {
        var spr = getLuaObject(name);
        if (spr != null)
            toTween.push(spr);
    }

    var targetColor = interpolateColor(nightColor, FlxColor.WHITE, 0.5);

    for (i in 0...toTween.length) {
        var spr = toTween[i];
        if (spr == null) continue;

        var delay = ([game.dad, game.gf, game.boyfriend].contains(spr)) ? 0 : i * delayCount;

        FlxTween.color(spr, fadeIn, nightColor, targetColor, {
            startDelay: delay,
            onComplete: function(tween:FlxTween) {
                FlxTween.color(spr, fadeOutTime, targetColor, nightColor, {ease: FlxEase.sineOut});
            }
        });
    }
}

function switchSplitathonSinger() {
    var dadVar = game.dad;
    var charExpression = backgroundChar2;

    game.dad = charExpression;
    backgroundChar2 = dadVar;

    game.dad.holdTimer = 0;
    backgroundChar2.holdTimer = 0;
}

function onStepHit() {
    if ((curStep > 2975 && curStep < 3745 && curStep % 16 == 0)
        || ((curStep > 4351 && curStep < 4607 || curStep > 4735 && curStep < 4863) && curStep % 32 == 0)) {
        splitathonFlare(0.2, 0.01, (Conductor.stepCrochet / 1250) * 8);
    }

    if (curStep > 5903 && curStep < 6128 || curStep > 6287 && curStep < 6640 || curStep > 6927 && curStep < 7408)
    {
        switch ((curStep - 16) % 32)
        {
            case 0:
                if (ClientPrefs.data.flashing)
                {   
                    triggerEvent('Add Camera Zoom', '0.1', '0.03');
                }
                splitathonDuoFlare(0.005, 0.01, (Conductor.stepCrochet / 1250) * 7);
            case 8:
                if (ClientPrefs.data.flashing)
                {   
                    triggerEvent('Add Camera Zoom', '0.075', '0.03');
                }
                splitathonDuoFlare(0.001, 0.003, (Conductor.stepCrochet / 1250) * 7);
        }
    }

    if (curStep > 6127 && curStep < 6161 || curStep > 6639 && curStep < 6673 || curStep > 7407 && curStep < 7441)
    {
        switch ((curStep - 16) % 32)
        {
            case 0:
                if (ClientPrefs.data.flashing)
                {
                    triggerEvent('Add Camera Zoom', '0.1', '0.04');
                }
                splitathonDuoFlare(0.001, 0.003, (Conductor.stepCrochet / 1250) * 7);
            case 4:
                if (ClientPrefs.data.flashing)
                { 
                    triggerEvent('Add Camera Zoom', '0.1', '0.02');
                }
            case 6:
                if (ClientPrefs.data.flashing)
                {
                    triggerEvent('Add Camera Zoom', '0.1', '0.02');
                }
                splitathonDuoFlare(0.001, 0.003, (Conductor.stepCrochet / 1250) * 7);
        }
        if ((curStep - 16) % 32 > 16 && (curStep - 16) % 2 == 0)
        {
            if (ClientPrefs.data.flashing)
            {
                triggerEvent('Add Camera Zoom', '0.04', '0.04');
            }
        }
    }

    switch(curStep)
    {
        case 124:
            for (strumLine in [game.playerStrums, game.opponentStrums])
            {
                for (i in 0...strumLine.members.length)
                {
                    var spr = strumLine.members[i];

                    spr.y -= (ClientPrefs.data.downScroll ? -300 : 300);
                    spr.alpha = 0;

                    FlxTween.tween(spr, {y: baseStrumY[i], alpha: 1}, 2, {ease: FlxEase.backOut, startDelay: i * 0.05});
                    FlxTween.angle(spr, -30 + (i * 10), 0, 2, {startDelay: iterator * 0.05});
                    
                    iterator++;
                }
            }
        case 128:
            camZooming = true;
        case 384:
            blackScreen.alpha = 1;
            defaultCamZoom = 1.1;

            FlxG.camera.flash();
            for (i in [healthBar, getLuaObject('healthBar.bg'), iconP1, iconP2, timeTxt, getLuaObject('scoreText'), getLuaObject('accuracyText'), getLuaObject('missesText'), getLuaObject('alarmClock'), getLuaObject('timeGauge'), getLuaObject('accuracyIcon'), getLuaObject('missesIcon'), getLuaObject('scoreIcon')]) {
                 if (i != null) {
                    FlxTween.tween(i, {alpha: 0}, 0.5);
                }
            }
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 0}, 0.5);
            }
        case 400: 
            for (i in [healthBar, getLuaObject('healthBar.bg'), iconP1, iconP2, timeTxt, getLuaObject('scoreText'), getLuaObject('accuracyText'), getLuaObject('missesText'), getLuaObject('alarmClock'), getLuaObject('timeGauge'), getLuaObject('accuracyIcon'), getLuaObject('missesIcon'), getLuaObject('scoreIcon')]) {
                 if (i != null) {
                    FlxTween.tween(i, {alpha: 1}, 0.5);
                }
            }
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 1}, 0.5);
            }
        case 408, 5640, 7720:
            loopCountTimer(4, (Conductor.stepCrochet / 1100) * 2, function() {
                blackScreen.alpha -= 0.22;
            });
        case 416, 7728:
            crazyZooming = true;
            camHUD.flash();
            blackScreen.alpha = 0;
            defaultCamZoom = 0.8;
            if (curStep == 7728) {
                backgroundChar2.playAnim('corn', true);
                game.defaultCamZoom = 0.8;
            }
        case 672, 7984:
            crazyZooming = false;
            if (curStep == 7984) {
                defaultCamZoom += 0.1;
            }
        case 928:
            game.defaultCamZoom += 0.2;
            FlxTween.tween(blackScreen, {alpha: 0.7}, 0.5, {ease: FlxEase.sineInOut});
        case 1056:
            game.defaultCamZoom -= 0.1;
            FlxTween.tween(blackScreen, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});   
        case 1184:
            game.defaultCamZoom -= 0.1;
            FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {ease: FlxEase.circOut});
        case 1952:
            game.defaultCamZoom += 0.1;
            FlxTween.tween(blackScreen, {alpha: 0.4}, 0.5, {ease: FlxEase.sineInOut});
        case 2208:
            game.defaultCamZoom -= 0.1;
            FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {ease: FlxEase.sineInOut});
        case 2384:
            FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.stepCrochet / 1000) * 80, {ease: FlxEase.quadIn});
        case 2464:
            FlxG.camera.flash();
            FlxTween.cancelTweensOf(whiteScreen);
            whiteScreen.alpha = 0;
            game.defaultCamZoom += 0.25;
                
            blackScreen.alpha = 1;
            FlxTween.tween(blackScreen, {alpha: 0.25}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.sineOut});
            FlxTween.tween(game, {defaultCamZoom: game.defaultCamZoom - 0.15}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.sineInOut});
        case 2976:
            game.defaultCamZoom -= 0.1;
            FlxTween.tween(blackScreen, {alpha: 0.3}, 0.5, {ease: FlxEase.sineInOut});
        case 3072:
            FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.stepCrochet / 1000) * 20, {
                ease: FlxEase.quadIn,
                onComplete: function(tween:FlxTween) {
                    FlxTween.tween(whiteScreen, {alpha: 0.6}, (Conductor.stepCrochet / 1000) * 12);
                }
            });
        case 3104:
            game.defaultCamZoom -= 0.1;
            game.camHUD.flash(FlxColor.WHITE, 0.5);
            FlxTween.cancelTweensOf(whiteScreen);
            whiteScreen.alpha = 0;
            FlxTween.tween(blackScreen, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
        case 3232:
            game.defaultCamZoom = 1.15;
            for (i in [healthBar, getLuaObject('healthBar.bg'), iconP1, iconP2, timeTxt, getLuaObject('scoreText'), getLuaObject('accuracyText'), getLuaObject('missesText'), getLuaObject('alarmClock'), getLuaObject('timeGauge'), getLuaObject('accuracyIcon'), getLuaObject('missesIcon'), getLuaObject('scoreIcon')]) {
                 if (i != null) {
                    FlxTween.tween(i, {alpha: 0.4}, 0.5);
                }
            }
            for (strum in game.playerStrums) {
                FlxTween.tween(strum, {alpha: 0.4}, 0.5);
            }
        case 3488:
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 0.4}, 0.5);
            }
            for (strum in game.playerStrums) {
                FlxTween.tween(strum, {alpha: 1}, 0.5);
            }
        case 3744:
            camZooming = false;
            game.defaultCamZoom -= 0.15;
            for (i in [healthBar, getLuaObject('healthBar.bg'), iconP1, iconP2, timeTxt, getLuaObject('scoreText'), getLuaObject('accuracyText'), getLuaObject('missesText'), getLuaObject('alarmClock'), getLuaObject('timeGauge'), getLuaObject('accuracyIcon'), getLuaObject('missesIcon'), getLuaObject('scoreIcon')]) {
                 if (i != null) {
                    FlxTween.tween(i, {alpha: 1}, 0.5);
                }
            }
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 1}, 0.5);
            }
        case 3760:
            FlxTween.tween(game.camHUD, {alpha: 0}, 2, {ease: FlxEase.quadOut});
        case 4000:
            game.defaultCamZoom = 0.9;
        case 4095:
            if (BAMBICUTSCENEICONHURHURHUR == null)
			{
				BAMBICUTSCENEICONHURHURHUR = new HealthIcon("dave-annoyed", false);
				BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
				add(BAMBICUTSCENEICONHURHURHUR);
				BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
				BAMBICUTSCENEICONHURHURHUR.x = -100;
				FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3);
				new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
			}
        case 4096:
            backgroundChar.visible = true;
            backgroundChar.playAnim('interrupted', true);
            FlxTween.tween(backgroundChar, {x: backgroundChar.x - 250, y: backgroundChar.y - 50}, 1, {
                ease: FlxEase.quadOut,
                    onComplete: function(tween:FlxTween) {
                        new FlxTimer().start(0.5, function(timer:FlxTimer) {
                            backgroundChar.playAnim('interrupt2dissapoint', true);
                        });
                    }
                });
            game.camHUD.alpha = 1;
            FlxG.camera.flash();
            game.camZooming = true;
        case 4156:
            FlxG.camera.zoom = 1.3;
            game.defaultCamZoom = 1.3;
        case 4160:
            game.defaultCamZoom = 1;
        case 4216:
            FlxG.camera.zoom = 0.8;
            game.defaultCamZoom = 0.8;
        case 4224:
            game.defaultCamZoom = 0.9;
        case 4284:
            FlxG.camera.zoom = 1.3;
            game.defaultCamZoom = 1.3;
        case 4288:
            game.defaultCamZoom = 0.8;
        case 4304:
            FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.stepCrochet / 1000) * 48, {ease: FlxEase.quadIn});
        case 4320:
            loopCountTimer(8, (Conductor.stepCrochet / 1000) * 4, function() {
                FlxG.camera.zoom += 0.1;
                game.defaultCamZoom += 0.1;
                vignette.alpha += 0.125;
            });
        case 4352:
            FlxG.camera.flash();
            FlxTween.cancelTweensOf(whiteScreen);
            whiteScreen.alpha = 0;
            vignette.alpha = 0;
            game.defaultCamZoom = 0.8;

        case 4608:
            game.defaultCamZoom = 0.8;
        case 5584:
            FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.stepCrochet / 1000) * 48, {ease: FlxEase.quadIn});
        case 4864:
            game.defaultCamZoom = 1;
            backgroundChar.playAnim('amusedidle', true);
        case 4992:
            game.camZooming = false;
        case 5120:
            game.camZooming = true;
            game.defaultCamZoom = 0.8;
        case 5376:
            game.camZooming = false;
            FlxTween.tween(blackScreen, {alpha: 0.3}, 0.5);
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 0}, 0.5);
            }
            game.defaultCamZoom = 1.1;
        case 5632:
            FlxTween.cancelTweensOf(whiteScreen);
            FlxTween.tween(whiteScreen, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
            blackScreen.alpha = 1;
        case 5648:
            game.defaultCamZoom = 1;
            camHUD.flash();
            blackScreen.alpha = 0;
            for (strum in game.playerStrums) {
                FlxTween.tween(strum, {alpha: 0}, 0.5);
            }
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 0}, 0.5);
            }
        case 5656, 5664, 5672, 5688, 5704, 5720, 5728, 5736, 5752, 5768:
            FlxTween.cancelTweensOf(camHUD);
            camHUD.alpha = 0.3;
            FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.expoOut});
        case 5676, 5680, 5696, 5702, 5708, 5712, 5740, 5744, 5760, 5766, 5772:
            FlxTween.cancelTweensOf(blackScreen);
            blackScreen.alpha = 0.3;
            FlxTween.tween(blackScreen, {alpha: 0}, 0.5, {ease: FlxEase.expoOut});
        case 5776:
            game.defaultCamZoom = 0.9;
            for (strum in game.playerStrums) {
                FlxTween.tween(strum, {alpha: 1}, 0.5);
            }
            for (strum in game.opponentStrums) {
                FlxTween.tween(strum, {alpha: 1}, 0.5);
            }
            game.camZooming = true;
            backgroundChar.playAnim('happyidle', true);
        case 5904:
            game.defaultCamZoom = 0.8;
        case 6032:
            game.defaultCamZoom = 1;
        case 6128:
            game.defaultCamZoom = 1.1;
        case 6160, 6672:
            game.defaultCamZoom = 0.9;
            camGame.flash(FlxColor.WHITE, 2);
            blackScreen.alpha = 1;
            FlxTween.tween(blackScreen, {alpha: 0}, (Conductor.stepCrochet / 1000) * 64, {ease: FlxEase.sineIn});
        case 6224, 6736:
            FlxTween.tween(whiteScreen, {alpha: 1}, (Conductor.stepCrochet / 1000) * 64, {ease: FlxEase.quadIn});
        case 6288, 6800:
            blackScreen.cameras = [game.camGame];
            camHUD.flash();
            FlxTween.cancelTweensOf(whiteScreen);
            whiteScreen.alpha = 0;

        switch (curStep) {
            case 6288:
                backgroundChar.visible = false;
                backgroundChar2.visible = true;
                backgroundChar2.playAnim('confused', true);
            case 6800:
                game.defaultCamZoom = 0.7;
                vignette.alpha = 1;
        }
        case 6544:
            game.defaultCamZoom = 1;
        case 6832, 6864, 6896:
            FlxTween.tween(vignette, {alpha: vignette.alpha - 0.25}, 0.5, {ease: FlxEase.sineOut});
            game.defaultCamZoom += 0.1;
        case 6928:
            game.camHUD.flash();
            FlxTween.cancelTweensOf(whiteScreen);
            whiteScreen.alpha = 0;
            vignette.alpha = 0;
            game.defaultCamZoom = 0.8;
                
            iconP2.changeIcon('the-duo');
        case 6960:
            backgroundChar2.playAnim('idle-transition', true);
        case 6992:
            game.defaultCamZoom = 1;
            switchSplitathonSinger();
        case 7056:
            game.defaultCamZoom = 0.9;
            switchSplitathonSinger();
        case 7248:
            switchSplitathonSinger();
        case 7328:
            switchSplitathonSinger();
        case 7376:
            game.defaultCamZoom = 1.1;
        case 7440:
            game.camZooming = false;
            FlxG.camera.flash(FlxColor.WHITE, 2);
            FlxTween.cancelTweensOf(whiteScreen);
            whiteScreen.alpha = 0;
            blackScreen.alpha = 1;
            FlxTween.tween(blackScreen, {alpha: 0}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.sineOut});
        case 7456:
            FlxTween.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
        case 7696:
            FlxG.camera.flash();
            blackScreen.alpha = 1;
            game.defaultCamZoom = 0.6;
            game.camZooming = true;

            iconP2.changeIcon('dave-annoyed');
        case 7714:
            FlxTween.tween(game.camHUD, {alpha: 1}, 0.5);
        case 8240:
            game.defaultCamZoom = 0.7;
            game.camZooming = false;
        case 8256:
            FlxTween.tween(game.camHUD, {alpha: 0}, 2, {ease: FlxEase.quadOut});
        case 8304:
            for (i in 0...opponentStrums.members.length)
            {
                var spr = opponentStrums.members[i];
                FlxTween.tween(spr, {x: spr.x - 600}, 1.5, {ease: FlxEase.expoIn});
                FlxTween.angle(spr, 0, i * -10, 1.5, {startDelay: i * 0.05});
            } 
            for (i in 0...playerStrums.members.length)
            {
                var spr = playerStrums.members[i];
                FlxTween.tween(spr, {x: spr.x + 600}, 1.5, {ease: FlxEase.expoIn});
                FlxTween.angle(spr, 0, i * -10, 1.5, {startDelay: (i * 0.05)});
            } 
        case 8368:
            game.defaultCamZoom = 0.9;
            game.camZooming = true;
            for (i in 0...opponentStrums.members.length)
            {
                var spr = opponentStrums.members[i];
                spr.alpha = 0;
                FlxTween.tween(spr, {x: spr.x + 600, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: (i * 0.1)});
                FlxTween.angle(spr, spr.angle, 0, 0.5, {startDelay: (i * 0.05)});
            }
            for (i in 0...playerStrums.members.length)
            {
                var spr = playerStrums.members[i];
                spr.alpha = 0;
                    FlxTween.tween(spr, {x: spr.x - 600, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: (i * 0.1)});
                    FlxTween.angle(spr, spr.angle, 0, 0.5, {startDelay: (i * 0.05)});
            }
            FlxTween.tween(game.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
        case 8624:
            game.defaultCamZoom = 0.8;
            game.camZooming = false;
    }
}



