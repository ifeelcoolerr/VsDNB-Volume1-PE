import objects.BGSprite;

var backWall:BGSprite;
var micSetup:BGSprite;
var studio:BGSprite;
var speakersLeft:FlxSprite;
var speakersRight:FlxSprite;
var keyboard:BGSprite;
var couch:BGSprite;

function onCreatePost()
{
    backWall = new BGSprite('backgrounds/playrobot/studio/backwall', -180, 100, 0.8, 0.8);
    backWall.scale.set(1.2, 1.2);
    backWall.updateHitbox();
    addBehindGF(backWall);

    micSetup = new BGSprite('backgrounds/playrobot/studio/mic_setup', 750, 270);
    micSetup.scale.set(1.2, 1.2);
    micSetup.updateHitbox();
    addBehindGF(micSetup);

    studio = new BGSprite('backgrounds/playrobot/studio/music_studio', -1080, -150);
    studio.scale.set(1.2, 1.2);
    studio.updateHitbox();
    add(studio);

    speakersLeft = new FlxSprite(-380, 550);
    speakersLeft.frames = Paths.getSparrowAtlas('backgrounds/playrobot/studio/speaker');
    speakersLeft.animation.addByPrefix('idle', 'bgspeak', 24, false);
    speakersLeft.flipX = true;
    speakersLeft.antialiasing = ClientPrefs.data.antialiasing;
    add(speakersLeft);

    speakersRight = new FlxSprite(1440, 550);
    speakersRight.frames = Paths.getSparrowAtlas('backgrounds/playrobot/studio/speaker');
    speakersRight.animation.addByPrefix('idle', 'bgspeak', 24, false);
    speakersRight.antialiasing = ClientPrefs.data.antialiasing;
    add(speakersRight);

    keyboard = new BGSprite('backgrounds/playrobot/studio/blagdog', 95, 750);
    keyboard.scale.set(1.2, 1.2);
    keyboard.updateHitbox();
    add(keyboard);

    couch = new BGSprite('backgrounds/playrobot/studio/foregroundcouch', 970, 950);
    couch.scale.set(1.2, 1.2);
    couch.updateHitbox();
    add(couch);

    insert(members.indexOf(boyfriendGroup), studio);
    insert(members.indexOf(boyfriendGroup), keyboard);

    backWall.visible = false;
    micSetup.visible = false;
    studio.visible = false;
    speakersLeft.visible = false;
    speakersRight.visible = false;
    keyboard.visible = false;
    couch.visible = false;

    setVar('backWall', backWall);
    setVar('micSetup', micSetup);
    setVar('studio', studio);
    setVar('speakersLeft', speakersLeft);
    setVar('speakersRight', speakersRight);
    setVar('keyboard', keyboard);
    setVar('couch', couch);

    remove(dadGroup, true);
    add(dadGroup);
}

function onBeatHit()
{
    if (curBeat % 2 == 0)
    {
        speakersLeft.animation.play('idle', true);
        speakersRight.animation.play('idle', true);
    }
}