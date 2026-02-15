import flixel.math.FlxBasePoint;
import flixel.group.FlxTypedGroup;
import flixel.sound.FlxSound;
import backend.MusicBeatState;
import Reflect;

var mathGameCompleted:Bool = false;

var blackFill:FlxSprite;
var whiteFill:FlxSprite;
var whiteFill2:FlxSprite;
var yctp:FlxSprite;
var baldi:FlxSprite;

var questionText:FlxText;
var inputField:FlxText;

var resultPos:Array<FlxBasePoint> = [
    new FlxBasePoint(260, 226),
    new FlxBasePoint(250, 323),
    new FlxBasePoint(250, 428)
];

var mathButtons = new FlxTypedGroup();
var mathButtonsData = [];

var resultGroup:FlxTypedGroup = new FlxTypedGroup();

var audioQueue = [];
var baldiAudio:FlxSound;

var extraMelody:FlxSound;

var curQuestion:Int = 0;
var num1:Int;
var num2:Int;
var sign:Int;
var solution:Float;
var operat:String;
var endState:String = '';
var endDelay:Float;
var failedGame:Bool;
var allowCountdown:Bool = false;
var isStoryMode:Bool = PlayState.isStoryMode;

// Shush don't tell anyone...
function runLuaCode(codeToRun)
{
    return new psychlua.FunkinLua(codeToRun);
}

function transition()
{
    var transt:FlxSprite = new FlxSprite(-2500, 0).loadGraphic(Paths.image('grad'));
    transt.scale.set(2, 2);
    add(transt);
    transt.cameras = [camOther];
    FlxTween.tween(transt, {x: 4400}, 1.25, {ease: FlxEase.easeOut});
}

function MathButton(x, y, id, clickFunc) {
    var sprite = new FlxSprite(x, y);
    mathButtonsData.push({ sprite: sprite, id: id, clickFunc: clickFunc });
    return sprite;
}

function MathSound(soundAsset, volume, looped) {
    return {
        soundAsset: soundAsset,
        volume: volume,
        looped: looped
    };
}

function queueAudio(sound)
{
    audioQueue.push(sound);
}
function unqueueAudio()
{
    audioQueue.remove(audioQueue[0]);
}

function clearQueue() {
    while (audioQueue.length > 0)
        unqueueAudio();

    baldiAudio.stop();
}

function playNextAudio() {
    if (audioQueue.length == 0)
        return;

    var soundToPlay = audioQueue[0];
    var asset = Reflect.field(soundToPlay, "soundAsset");
    var looped = Reflect.field(soundToPlay, "looped");
    var volume = Reflect.field(soundToPlay, "volume");

    baldiAudio = new FlxSound();
    baldiAudio.loadEmbedded(asset, looped, false, null);
    baldiAudio.volume = volume;

    unqueueAudio();
    baldiAudio.onComplete = function()
    { 
        playNextAudio(); 
    };
    baldiAudio.play();
}

function playExtraMelodyForQuestion(questionNumber:Int)
{
    if(extraMelody != null && extraMelody.playing)
        extraMelody.stop();

    var melodyPath:String = '';
    switch(questionNumber) {
        case 2:
            melodyPath = Paths.music('math/learn/learnNew_2');
        case 3:
            melodyPath = Paths.music('math/learn/learnNew_3');
        default:
            return;
    }

    extraMelody = new FlxSound();
    extraMelody.loadEmbedded(melodyPath, true, false, null);
    extraMelody.volume = 0.7;
    extraMelody.play();

    FlxG.sound.playMusic(Paths.music('math/learn/learnNew_1'), 1, true, null);
}


function onStartCountdown()
{
    if (!allowCountdown)
    {
        return Function_Stop;
    }
}

function onCreate()
{
    // this is so the volume keys don't conflict with the math keys
    FlxG.sound.muteKeys = [];
    FlxG.sound.volumeUpKeys = [];
    FlxG.sound.volumeDownKeys = [];


    PlayState.instance.allowDebugKeys = false;

    if (!FlxG.mouse.visible) 
        FlxG.mouse.visible = true;
        FlxG.mouse.load(Paths.image('backgrounds/math/CursorSprite').bitmap);

    camOther.zoom = 0.7;

    baldiAudio = new FlxSound();
    FlxG.sound.music.stop();
    FlxG.sound.playMusic(Paths.music('math/learn/learnNew_1'), 1, true, null);

    queueAudio(MathSound(Paths.sound('math/intro/BAL_Math_Intro1'), 1, false));
    queueAudio(MathSound(Paths.sound('math/intro/BAL_Math_Intro2'), 1, false));
    queueAudio(MathSound(Paths.sound('math/intro/BAL_Math_Intro3'), 1, false));
    queueAudio(MathSound(Paths.sound('math/yctp/BAL_YCTP_Intro1'), 1, false));
    queueAudio(MathSound(Paths.sound('math/yctp/BAL_YCTP_Intro2'), 1, false));

    Conductor.set_bpm(120);

    blackFill = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackFill.scale.set(10, 10);
    blackFill.scrollFactor.set();
    blackFill.cameras = [camOther];
    add(blackFill);

    whiteFill2 = new FlxSprite(195, 486.7).makeGraphic(754, 201, FlxColor.WHITE);
    whiteFill2.scrollFactor.set();
    whiteFill2.cameras = [camOther];
    add(whiteFill2);

    baldi = new FlxSprite(245, 523);
    baldi.frames = Paths.getSparrowAtlas('backgrounds/math/Baldi_MathGame_Sheet');
    baldi.animation.addByIndices('talkIdle', 'talk', [0], '', 0, false);
    baldi.animation.addByPrefix('talk', 'talk', 24);
    baldi.animation.addByPrefix('frown', 'frown', 30, false);
    baldi.setGraphicSize(169, 167);
    baldi.updateHitbox();
    baldi.antialiasing = false;
    baldi.scrollFactor.set();
    baldi.animation.play('talkIdle');
    baldi.cameras = [camOther];
    add(baldi);

    whiteFill = new FlxSprite(155, 230).makeGraphic(844, 264, FlxColor.WHITE);
    whiteFill.scrollFactor.set();
    whiteFill.cameras = [camOther];
    add(whiteFill);

    questionText = new FlxText(417, 239, 426, '', 1);
    questionText.setFormat(Paths.font('comic-sans.ttf'), 40, FlxColor.BLACK, 'left');
    questionText.scrollFactor.set();
    questionText.cameras = [camOther];
    add(questionText);

    inputField = new FlxText(508, 587, 514.7, "", 44);
    inputField.setFormat(Paths.font('comic-sans.ttf'), 50, FlxColor.BLACK, 'left');
    inputField.scrollFactor.set();
    inputField.cameras = [camOther]; 
    add(inputField);

    yctp = new FlxSprite(3, -125).loadGraphic(Paths.image('backgrounds/math/YCTP_Base'));
    yctp.setGraphicSize(1280, 969);
    yctp.updateHitbox();
    yctp.antialiasing = false;
    yctp.scrollFactor.set();
    yctp.cameras = [camOther];
    add(yctp);

    var buttonStuff = [
        ['7', 959, 140], ['8', 1041, 140], ['9', 1122, 140],
        ['4', 959, 221], ['5', 1040, 222], ['6', 1122, 221],
        ['1', 959, 304], ['2', 1041, 303], ['3', 1122, 303],
        ['clear', 959, 385], ['0', 1041, 385], ['minus', 1122, 384],
        ['ok', 960, 466]
    ];

    for (i in 0...buttonStuff.length) {
        var id = buttonStuff[i][0];
        var x = buttonStuff[i][1];
        var y = buttonStuff[i][2];
        var buttonID = id;

        var button = MathButton(x, y, buttonID, function()
        {
            if (buttonID == "ok" && endState == "")
                checkAnswer();
            else if (buttonID == "clear")
                inputField.text = "";
            else if (buttonID == "minus")
                inputField.text += "-";
            else if (buttonID != "ok" && buttonID != "clear")
                inputField.text += buttonID;
        });

        button.loadGraphic(Paths.image("backgrounds/math/buttons/btn_" + buttonID));
        button.setGraphicSize(Std.int(button.width * 1.22)); 
        button.updateHitbox();
        button.scrollFactor.set();
        button.cameras = [camOther];
        mathButtons.add(button);
        add(button);
    }

    resultGroup.cameras = [camOther];
    add(resultGroup);

    generateQuestion();
}

function onUpdate(elapsed:Float)
{
    if(FlxG.keys.justPressed.Q)
    {
        endSong();
    }

    for (i in 0...mathButtonsData.length)
    {
        var button = Reflect.field(mathButtonsData[i], "sprite");
        var id = Reflect.field(mathButtonsData[i], "id");
        var clickFunc = Reflect.field(mathButtonsData[i], "clickFunc");

        if (button == null) continue;

        if (FlxG.mouse.overlaps(button))
        {
            button.loadGraphic(Paths.image('backgrounds/math/buttons/btn_' + id + '_pressed'));
            button.setGraphicSize(Std.int(button.width * 1.22));
            button.updateHitbox();
            button.centerOffsets();
            if (FlxG.mouse.justPressed && clickFunc != null)
                clickFunc();
        }
        else
        {
            button.loadGraphic(Paths.image('backgrounds/math/buttons/btn_' + id));
            button.setGraphicSize(Std.int(button.width * 1.22));
            button.updateHitbox();
            button.centerOffsets();
        }
    }

    if (!baldiAudio.playing && audioQueue.length > 0)
        playNextAudio();

    if (!failedGame)
    {
        if (baldiAudio.playing && baldi.animation.curAnim.name != 'talk')
            baldi.animation.play('talk');
        else if (!baldiAudio.playing && baldi.animation.curAnim.name != 'talkIdle')
            baldi.animation.play('talkIdle');
    }

    if (endState != '') {
        if (endDelay > 0)
            endDelay -= elapsed;
        else {
            switch (endState) {
                case 'won':
                    new FlxTimer().start(1.9, endIt);
                    new FlxTimer().start(1.3, endIt2);
                case 'failed':
                    MusicBeatState.switchState(new PlayState());
            }
        }
    }
    var keyID = FlxG.keys.firstJustPressed();
    if (keyID > -1)
    {
        switch (keyID) {
            case 13:
                if (endState == '') checkAnswer();
            case 8:
                if (inputField.text.length > 0)
                    inputField.text = inputField.text.substr(0, inputField.text.length - 1);
                case 48: inputField.text += '0';
                case 49: inputField.text += '1';
                case 50: inputField.text += '2';
                case 51: inputField.text += '3';
                case 52: inputField.text += '4';
                case 53: inputField.text += '5';
                case 54: inputField.text += '6';
                case 55: inputField.text += '7';
                case 56: inputField.text += '8';
                case 57: inputField.text += '9';
                case 189: inputField.text += '-';
            }
    }
}

function generateQuestion()
{
    inputField.text = '';
    curQuestion += 1;

    sign = FlxG.random.int(0,2);
    num1 = FlxG.random.int(0,9);
    num2 = FlxG.random.int(0,9);

    if (sign == 0)
    {
        solution = num1 + num2;
        operat = '+';
        operatorAudio = 'Plus';
    }
    else if (sign == 1)
    { 
        solution = num1 - num2;
        operat = '-';
        operatorAudio = 'Minus'; 
    }
    else
    { 
        solution = num1 * num2;
        operat = '*';
        operatorAudio = 'Times'; 
    }

    questionText.text = 'SOLVE MATH Q' + curQuestion + ':\n\n' + num1 + operat + num2 + '=';

    queueAudio(MathSound(Paths.sound('math/problem/BAL_YCTP_Problem' + curQuestion), 1, false));
    queueAudio(MathSound(Paths.sound('math/number/BAL_Math_' + num1), 1, false));
    queueAudio(MathSound(Paths.sound('math/operations/BAL_Math_' + operatorAudio), 1, false));
    queueAudio(MathSound(Paths.sound('math/number/BAL_Math_' + num2), 1, false));
    queueAudio(MathSound(Paths.sound('math/operations/BAL_Math_Equals'), 1, false));

    playExtraMelodyForQuestion(curQuestion);
}

function queuePraise(randPraise:Int) {
    queueAudio(MathSound(Paths.sound('math/praise/BAL_Praise' + randPraise), 1, false));
    if (!baldiAudio.playing)
        playNextAudio();
}

function checkAnswer() {
    var inputValue = Std.parseFloat(inputField.text);
    var pos = resultPos[curQuestion-1];
    var result:FlxSprite = new FlxSprite(Reflect.field(pos,"x"),Reflect.field(pos,"y"));
    result.cameras = [camOther];

    if (inputValue == solution)
    {
        clearQueue();
        queuePraise(FlxG.random.int(1,6));
        result.loadGraphic(Paths.image('backgrounds/math/Check'));

        if (curQuestion >= 3)
        { 
            endDelay = 3;
            questionText.text = 'WOW! YOU EXIST!';
            endState = 'won';
        }
        else
            generateQuestion();
    }
    else
    {
        if(extraMelody != null) extraMelody.stop();
        FlxG.sound.playMusic(Paths.music('math/hang/mus_hang_'+FlxG.random.int(1,2)),1,false,null);
        endState = 'failed';
        endDelay = 3;
        failedGame = true;
        clearQueue();
        baldi.animation.play('frown');
        questionText.text = 'I HEAR MATH THAT BAD';
        result.loadGraphic(Paths.image('backgrounds/math/X'));
    }
    result.setGraphicSize(83,83);
    result.updateHitbox();
    resultGroup.add(result);
    insert(members.indexOf(yctp), resultGroup);
}


function endIt(e:FlxTimer = null)
{
    if (FlxG.mouse.visible) 
        FlxG.mouse.visible = false;
    
    if(extraMelody != null && extraMelody.playing)
        extraMelody.stop();
    
    PlayState.instance.allowDebugKeys = true;
    
    runLuaCode('loadSong("roofs", 1)');
}

function onDestroy()
{
    ClientPrefs.reloadVolumeKeys();
}