// Literally most of these code are taken from my character select script.

import backend.MusicBeatState;
import backend.Difficulty;

import states.PlayState;
import states.FreeplayState;

import objects.Character;

import flixel.effects.FlxFlicker;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxTextBorderStyle;

function onStartCountdown()
{
    return Function_Stop;
}

function runLuaCode(code:String)
{
    return new psychlua.FunkinLua(code);
}

function CharacterInSelect(name, forms)
{
    var self = {};
    self.name = name;
    self.forms = forms;
    return self;
}

function CharacterForm(name, polishedName, color)
{
    var self = {};
    self.name = name;
    self.polishedName = polishedName;
    self.color = color;
    return self;
}

function CharacterIcon(name, x, y)
{
    var self = {};

    self.name = name;
    self.x = x;
    self.y = y;

    return self;
}

var selectLogo:FlxSprite;
var char:Character;
var current:Int = 0;
var characterText:FlxText;
var prevSelected:Int = -1;
var portrait:FlxSprite;
var portraitsIcon;
var noSpamming:Bool = true;
var PressedTheFunny:Bool = false;
var selectedCharacter:Bool = false;
var currentSelectedCharacter = null;
var currentSelectedIcon = null;
var elapsedTime:Float = 0;
var baseSelectY:Float = 0;
var currentRow:Int = 0;
var currentCol:Int = 0;
var portraitsIcon;

var characters = [
    CharacterInSelect("playrobot-backseat", [
        CharacterForm("playrobot-backseat", "Playrobot", 0xFFFFC300),
    ]),
    CharacterInSelect("tristan-backseat", [
        CharacterForm("tristan-backseat", "Tristan", 0xFFFF130F),
    ]),
];

var charIcons = [
    CharacterIcon('playrobot', 750, 350),
    CharacterIcon('tristan', 800, 350),
];

var gridWidth:Int = charIcons.length;
var gridHeight:Int = 1;

function createAndPositionIcons()
{
    var spacingX = 180;
    var spacingY = 180;

    for (i in 0...charIcons.length)
    {
        var iconData = charIcons[i];
        var col = i % gridWidth;
        var row = Std.int(i / gridWidth);

        var startX = iconData.x;
        var startY = iconData.y;

        var iconSprite = new FlxSprite(startX + col * spacingX, startY + row * spacingY);
        iconSprite.frames = Paths.getSparrowAtlas('selectMenu/ui/portraits/' + iconData.name + '_portrait');

        iconSprite.animation.addByPrefix('unselected', 'unselected_' + iconData.name, 24, false);
        iconSprite.animation.addByPrefix('selected', 'selected_' + iconData.name, 24, false);
        iconSprite.animation.addByPrefix('transitionS', 'transitions_' + iconData.name, 30, false);
        iconSprite.animation.addByPrefix('transitionU', 'transitionu_' + iconData.name, 24, false);

        iconSprite.antialiasing = ClientPrefs.data.antialiasing;
        iconSprite.cameras = [camOther];
        portraitsIcon.add(iconSprite);

        charIcons[i].sprite = iconSprite;

        if (i == current)
        {
            iconSprite.animation.play('selected', true);
            iconSprite.scale.set(0.9, 0.9);  // selected
        }
        else
        {
            iconSprite.animation.play('unselected', true);
            iconSprite.scale.set(0.8, 0.8);  // unselected
        }
    }
}

function updateIconSelection()
{
    if (prevSelected == current)
        return;

    for (i in 0...charIcons.length)
    {
        var iconData = charIcons[i];

        if (iconData.sprite == null)
            continue;

        if (i == current && iconData.sprite.animation.curAnim.name != 'transitionS')
        {
            iconData.sprite.animation.play('transitionS');
            iconData.sprite.scale.set(0.9, 0.9);  // selected
        }
        else if (i == prevSelected && iconData.sprite.animation.curAnim.name != 'transitionU')
        {
            var prevIcon = iconData;
            prevIcon.sprite.animation.play('transitionU');
            prevIcon.sprite.scale.set(0.8, 0.8); // unselected
        }
        else
        {
            iconData.sprite.scale.set(0.8, 0.8); // unselected
        }
    }
    prevSelected = current;
}

function highlightSelectedCharacter()
{
    for (i in 0...charIcons.length)
    {
        var iconData = charIcons[i];
        if (iconData.sprite != null)
        {
            if (i == current)
                FlxFlicker.flicker(iconData.sprite, 0, 0.05, true, true);
            else
                FlxTween.tween(iconData.sprite, { alpha: 0.3 }, 0.5, { ease: FlxEase.circOut });
        }
    }
}

function onCreate()
{
    FlxG.sound.playMusic(Paths.music('playerSelect/playerSelect-backseat'), 1, true);
    
    currentSelectedCharacter = characters[current];
    currentSelectedIcon = charIcons[current];

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('selectMenu/playerSelect/backseat/bg'));
    bg.scale.set(0.7, 0.7);
    bg.updateHitbox();
    bg.screenCenter();
    bg.camera = game.camOther;
    bg.antialiasing = ClientPrefs.data.antialiasing;
    add(bg);

    selectLogo = new FlxSprite(800, 25).loadGraphic(Paths.image('selectMenu/playerSelect/backseat/select_logo'));
    selectLogo.scale.set(0.8, 0.8);
    selectLogo.updateHitbox();
    selectLogo.camera = game.camOther;
    selectLogo.antialiasing = ClientPrefs.data.antialiasing;
    add(selectLogo);

    char = new Character(60, 150, 'playrobot-backseat', true);
    char.cameras = [camOther];
    add(char);

    characterText = new FlxText(100, 50, 0, currentSelectedCharacter.forms[0].polishedName);
    characterText.font = 'Comic Sans MS Bold';
    characterText.setFormat(Paths.font("comic-sans.ttf"), 60, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    characterText.autoSize = false;
    characterText.fieldWidth = 1080;
    characterText.borderSize = 3;
    characterText.color = currentSelectedCharacter.forms[0].color;
    characterText.cameras = [camOther];
    characterText.antialiasing = ClientPrefs.data.antialiasing;
    add(characterText);

    baseSelectY = selectLogo.y;

    portraitsIcon = new FlxTypedGroup();
    portraitsIcon.cameras = [camOther];
    add(portraitsIcon);

    createAndPositionIcons();
}

function onUpdate(elapsed:Float)
{
    elapsedTime += elapsed;
    selectLogo.y = baseSelectY + Math.sin(elapsedTime * 3) * 5;

    for (i in 0...charIcons.length)
    {   
        var iconData = charIcons[i];
        if (iconData.sprite == null) continue;

        var anim = iconData.sprite.animation.curAnim;
        if (anim == null) continue;

        if (anim.name == 'transitionU' && anim.finished)
        {
            if (i != current)
            {
                iconData.sprite.animation.play('unselected', true);
            }
        }
    }
    
    if (controls.BACK)
    {
        if (noSpamming && !PressedTheFunny)
        {
            noSpamming = false;
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
            MusicBeatState.switchState(new FreeplayState());
        }
    }

    if (controls.ACCEPT)
    {
        if(PressedTheFunny)
        {
            return;
        }
        else
        {
            PressedTheFunny = true;
        }
        selectedCharacter = true;
        var heyAnimation:Bool = char.animation.getByName("hey") != null; 
        char.playAnim(heyAnimation ? 'hey' : 'singUP', true);
		FlxG.sound.music.fadeOut(1.9, 0);
		FlxG.sound.play(Paths.sound('confirmMenu'));
        highlightSelectedCharacter();
		new FlxTimer().start(1.9, endIt);
    }
    if (!selectedCharacter)
    {
        if (FlxG.keys.justPressed.LEFT) 
        { 
            moveSelection(-1, 0);
            updateIconSelection();
        }
        if (FlxG.keys.justPressed.RIGHT)
        { 
            moveSelection(1, 0);
            updateIconSelection(); 
        }    
    } 
}

function moveSelection(dx:Int, dy:Int)
{
    var newCol = currentCol + dx;
    var newRow = currentRow + dy;

    if (newCol < 0) 
    {
        newCol = gridWidth - 1; newRow--; 
    }
    else if (newCol >= gridWidth)
    { 
        newCol = 0; newRow++; 
    }

    if (newRow < 0)
        newRow = gridHeight - 1;
    else if (newRow >= gridHeight)
        newRow = 0;

    var newIndex = newRow * gridWidth + newCol;

    if (newIndex >= characters.length)
        return;

    currentRow = newRow;
    currentCol = newCol;
    current = newIndex;

    UpdateBF();
    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
}

function UpdateBF()
{
    var newSelectedCharacter = characters[current];
    currentSelectedCharacter = newSelectedCharacter;
	characterText.text = currentSelectedCharacter.forms[0].polishedName;
    characterText.color = currentSelectedCharacter.forms[0].color;
	char.destroy();
	char = new Character(60, 150, currentSelectedCharacter.forms[0].name, true);
	char.cameras = [camOther];
    insert(members.indexOf(characterText), char);
}

function endIt(e:FlxTimer = null)
{
    if (current == 0)
        Difficulty.list = ['playrobot'];
    else
        Difficulty.list = ['tristan'];

    runLuaCode('loadSong("backseat")');
}