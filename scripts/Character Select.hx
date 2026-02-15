/*
 * Hi guys, its me "ifeelcoolerr", the one who coded this script.
 * I allow you to use this script and mess with it as long you credit me.
 * This is 90% my code and 10% from 3.0's source code.
 * So I would feel appreciated if you would credit me. Thank you.
 * - "ifeelcoolerr"
*/

/*
 * My Character Select isn't based on Volume 1's Source code,
 * heck, this was made before the source code was released.
 * So I had to code by using some of 3.0's and what i've seen.
*/

import backend.MusicBeatState;

import flixel.effects.FlxFlicker;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxTextBorderStyle;

import objects.Character;
import objects.HealthIcon;

import states.PlayState;
import states.FreeplayState;

import shaders.RGBPalette;
import shaders.RGBShaderReference;

/*
 * Returns a new instance of lua.
*/
function runLuaCode(code:String)
{
    return new psychlua.FunkinLua(code);
}

/*
 * HScript-iris does not support classes (unlike codename's hscript),
 * So a way around it is to make a function.
 * It works but with certain caveats.
*/

/*
 * Used for Character Select's Character.
 * @param name The Character's JSON.
 * @param forms The Forms that the Character has. Uses the "CharacterForm" function.
*/
function CharacterInSelect(name, forms)
{
    var self = {};
    self.name = name;
    self.forms = forms;
    return self;
}

/*
 * Used for the Character's Form.
 * @param name The Character's JSON.
 * @param polishedName The Character's Actual Name.
 * @param color The Character's Text Color.
 * @param noteType The Note Type the character should use.
 * @param gfIconPath The Path to Girlfriend's icon, Defaults to "gf"
 * @param gfX GF's icon X position.
 * @param gfY GF's icon Y position.
*/
function CharacterForm(name, polishedName, color, ?noteType, ?music, ?gfIconPath, ?gfX, ?gfY)
{
    if (noteType == null) noteType = '';
    if (music == null) music = 'characterSelect/charSelect-normal';
    if (gfIconPath == null) gfIconPath = 'gf';
    var self = {};
    self.name = name;
    self.polishedName = polishedName;
    self.color = color;
    self.noteType = noteType;
    self.music = music;
    self.gfIconPath = gfIconPath;
    self.gfX = gfX;
    self.gfY = gfY;
    return self;
}

/*
 * Used for Character Portrait.
 * @param name The name and path for the character portrait.
 * @param x The X Position of the Portrait.
 * @param y The Y Position of the Portrait.
*/
function CharacterIcon(name, x, y)
{
    var self = {};

    self.name = name;
    self.x = x;
    self.y = y;

    return self;
}

/*
 * Songs that will be excluded from using the Character Select.
*/
var excludeSongs:Array<String> = ['Backseat', 'MathGameState', 'terminal', 'Vs-Dave-Rap', 'Vs-Dave-Rap-Two', 'Backseat Character Select', 'endingDave', 'endingBambi'];

/*
 * Not really songPosition and curBeat, just a way to mimmick them.
*/
var songPositionFromTemu:Float = 0;
var curBeatFromTemu:Int = 0;

/*
 * The background image.
*/
var bg:FlxSprite;

/*
 * The Character used in Character Select.
*/
var char:Character;

/*
 * The currently selected character.
*/
var current:Int = 0;

/*
 * The Character Select Text.
*/
var characterText:FlxText;

/*
 * Current Character's X Position.
*/
var baseCharX:Float = -60;

/*
 * Current Character's Y Position.
*/
var baseCharY:Float = 270;

/*
 * Current Character's Character Scale.
*/
var baseCharScale:Float = 1.15;

/*
 * The row that it is currently in.
*/
var currentRow:Int = 0;

/*
 * The column that it is currently in.
*/
var currentCol:Int = 0;

/*
 * Used for the portraits and detecting which grid it is in.
*/
var gridWidth:Int = 3;
var gridHeight:Int = 3;

/*
 * The Previously Selected Character.
*/
var prevSelected:Int = -1;

/*
 * The Current Page.
*/
var currentPage:Int = 1;

/*
 * Character Select Portrait.
*/
var portrait:FlxSprite;

/*
 * Girlfriend Icon for the corresponding character.
*/
var gfIcon:HealthIcon;

/*
 * A group, used for "gfIcon" and "portrait".
*/
var portraitsIcon:Dynamic = null;

/*
 * The Strums.
*/
var strummies:Dynamic = null;

/*
 * Text for which Page of character's its in.
*/
var page:FlxText;

/*
 * Used for maze, it fixes there being duplicate characters.
*/
var charVisible:Bool = false;

/*
 * Detects if the player has pressed enter or not.
*/
var PressedTheFunny:Bool = false;

/*
 * Detects if the player has selected a character.
*/
var selectedCharacter:Bool = false;

/*
 * Used for Character Forms.
*/
var currentSelectedCharacter = null;

/*
 * The current selected icon, used for playing the portrait animations.
*/
var currentSelectedIcon = null;

/*
 * Girlfriend Icon Group.
*/
var gfIconGroup:FlxTypedGroup;

/*
 * The Music it should play.
*/
var targetMusic:String = null;

/*
 * How long the music transition fade in is.
*/
var fadeInSpeed:Float = 0.02;

/*
 * A bool for debug purposes, if you press "R", the script will restart. Used for testing purposes.
*/
var debug:Bool = true;

/*
 * It makes that so the player does not spam the back button when switching to FreeplayState.
*/
var noSpamming:Bool = true;

/*
 * A shortcut for ClientPrefs's Downscroll, detects if the player has enabled Downscroll or not.
*/
var downScroll:Bool = ClientPrefs.data.downScroll;

/*
 * Character Select Variable:
 * CharacterInSelect: The name of the character (JSON Name), Forms (Which leads to Character Form)
 * CharacterForm: The name (JSON Name), Character Name (Put any name you want), Color Name, Note Type (Optional), Character Music Path (Optional), GF Icon Path, Girlfriend xPos (Optional), Girlfriend yPos (Optional)
*/
var characters = [
    CharacterInSelect("bf", [
        CharacterForm("bf", "Boyfriend", 0xFF31B0D1, null, "characterSelect/charSelect-normal", "gf", -100, 150),
    ]),
    CharacterInSelect("bf-pixel", [
        CharacterForm("bf-pixel", "Pixel Boyfriend", 0xFF7BD6F6, 'pixel', "characterSelect/charSelect-bf-pixel", "gf-pixel", 200, 150),
    ]),
    CharacterInSelect("bf-3d", [
        CharacterForm("bf-3d", "3D Boyfriend", 0xFF3788C9, '3D', "characterSelect/charSelect-bf-3d", "gf-3d", 500, 150),
    ]),
    CharacterInSelect("dave", [
        CharacterForm("dave-playable", "Dave", 0xFF1C73FF, null, "characterSelect/charSelect-dave", "dave-boombox", -100, 450)
    ]),
    CharacterInSelect("tristan-golden", [
        CharacterForm("tristan-golden", "Golden Tristan", 0xFFBF0F, null, "characterSelect/charSelect-tristan-golden", "playrobot-gf", 200, 450)
    ]),
    CharacterInSelect("bambi", [
        CharacterForm("bambi-new-playable", "Bambi", 0xFF25BF37, null, "characterSelect/charSelect-bambi-new", "bambi-haystack", 500, 450)
    ]),
    CharacterInSelect("tristan-playable", [
        CharacterForm("tristan-playable", "Tristan", 0xFFFF130F, null, "characterSelect/charSelect-tristan", "playrobot-gf", -100, 750)
    ]),
    CharacterInSelect("playrobot-playable", [
        CharacterForm("playrobot-playable", "Playrobot", 0xFFFFC300, null, "characterSelect/charSelect-playrobot-player", "tristan", 200, 750)
    ]),
];

/*
 * Character Icon Variable:
 * Add the character portrait with "CharacterIcon", located in "selectMenu/ui/portraits".
 * Adjust the offset of the Icon. (x, y)
*/
var charIcons = [
    CharacterIcon('bf', 650, -60),
    CharacterIcon('pixel', 760, -59),
    CharacterIcon('3d', 860, -60),
    CharacterIcon('dave', 650, 50),
    CharacterIcon('golden', 760, 50),
    CharacterIcon('bambi', 860, 50),
    CharacterIcon('tristan', 650, 150),
    CharacterIcon('playrobot', 760, 150)
];

/*
 * A shortcut for the current character.
*/
currentSelectedCharacter = characters[current];

/*
 * A shortcut for the current character icon.
*/
currentSelectedIcon = charIcons[current];

/*
 * Should Countdown be triggered?
*/
var allowCountdown:Bool = false;

/*
 * A shortcut for PlayState's "isStoryMode".
*/
var isStoryMode:Bool = PlayState.isStoryMode;

function onStartCountdown()
{
    if(!isStoryMode)
    {
        if(!excludeSongs.contains(PlayState.SONG.song))
        {
            if(!allowCountdown)
            {
                return Function_Stop;
            }
        }
        return Function_Continue;
    }
}

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
            iconSprite.scale.set(1.2, 1.2);  // selected
        }
        else
        {
            iconSprite.animation.play('unselected', true);
            iconSprite.scale.set(1, 1);  // unselected
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
            iconData.sprite.scale.set(1.2, 1.2);
        }
        else if (i == prevSelected && iconData.sprite.animation.curAnim.name != 'transitionU')
        {
            var prevIcon = iconData;
            prevIcon.sprite.animation.play('transitionU');
            prevIcon.sprite.scale.set(1, 1);
        }
        else
        {
            iconData.sprite.scale.set(1, 1);
        }
    }
    prevSelected = current;
    updateGFIconPosition();
}


function updateGFIconPosition()
{
    if (currentSelectedIcon != null && currentSelectedIcon.sprite != null && gfIcon != null)
    {
        var iconSprite = currentSelectedIcon.sprite;
        var gfForm = currentSelectedCharacter.forms[0];

        gfIcon.x = iconSprite.x + gfForm.gfX;
        gfIcon.y = iconSprite.y + gfForm.gfY;

        if (gfIcon.frames == null || gfIcon.frames.name != gfForm.gfIconPath)
        {
            gfIcon.changeIcon(gfForm.gfIconPath);
        }
    }
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
                FlxTween.tween(iconData.sprite, {alpha: 0.3}, 0.5, {ease: FlxEase.circOut});
        }
    }
}

function playCharacterMusic(musicPath:String)
{
    if (musicPath == null || musicPath == "") return;

    if (FlxG.sound.music != null)
        FlxG.sound.music.stop();

    FlxG.sound.playMusic(Paths.music(musicPath), 0, true);
    targetMusic = musicPath;
}

function transition()
{
    var transt:FlxSprite = new FlxSprite(-2500, 0).loadGraphic(Paths.image('grad'));
    transt.scale.set(2, 2);
    add(transt);
    transt.cameras = [camOther];
    FlxTween.tween(transt, {x: 2400}, 1.25, {ease: FlxEase.easeOut});
}

function onCreate()
{
    if(!excludeSongs.contains(PlayState.SONG.song))
    {
        if (isStoryMode)
        {
            return;
        }
        
        game.camOther.zoom = 0.75;
        
        buildMusic();
        buildBackground();
        buildCharacters();
        buildCharacterText();
        buildGroupIcons();
        
        createAndPositionIcons();
        updateGFIconPosition();
        generateCharacterArrows(false, true);
    }
}

function buildMusic()
{
    FlxG.sound.playMusic(Paths.music(currentSelectedCharacter.forms[0].music), 1, true);
}

function buildBackground()
{
    bg = new FlxSprite(-69420, -69420).loadGraphic(Paths.image('selectMenu/charSelect/charSelectBg'));
    bg.scale.set(0.92, 0.92);
    bg.screenCenter();
    bg.antialiasing = ClientPrefs.data.antialiasing;
    bg.cameras = [camOther];
    add(bg);
}

function buildCharacters()
{
    char = new Character(-60, 270, 'bf', true);
    char.scale.set(1.15, 1.15);
    char.cameras = [camOther];
    add(char);

    for (key in char.animOffsets.keys()) {
        char.animOffsets[key][0] *= char.scale.x;
        char.animOffsets[key][1] *= char.scale.y;
    }
}

function buildCharacterText()
{
    characterText = new FlxText(-50, -50, 0, currentSelectedCharacter.forms[0].polishedName);
    characterText.font = 'Comic Sans MS Bold';
    characterText.setFormat(Paths.font("comic-sans.ttf"), 90, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    characterText.autoSize = false;
    characterText.fieldWidth = 1080;
    characterText.borderSize = 5;
    characterText.color = currentSelectedCharacter.forms[0].color;
    characterText.cameras = [camOther];
    characterText.antialiasing = ClientPrefs.data.antialiasing;
    add(characterText);

    page = new FlxText(940, -120, 0, 'Page 1/' + currentPage);
    page.font = 'Comic Sans MS Bold';
    page.setFormat(Paths.font("comic-sans.ttf"), 30, FlxColor.WHITE, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    page.borderSize = 3;
    page.cameras = [camOther];
    page.antialiasing = ClientPrefs.data.antialiasing;
    add(page);
}

function buildGroupIcons()
{
    portraitsIcon = new FlxTypedGroup();
    portraitsIcon.cameras = [camOther];

    strummies = new FlxTypedGroup();
	strummies.cameras = [camOther];
		
    add(strummies);
    add(portraitsIcon);

    gfIconGroup = new FlxTypedGroup();
    gfIconGroup.cameras = [camOther];
    add(gfIconGroup);
    
    gfIcon = new HealthIcon(0, 0, 'gf');
    gfIcon.cameras = [camOther];
    gfIcon.flipX = true;
    gfIconGroup.add(gfIcon);
}

function onCreatePost()
{
    if(!excludeSongs.contains(PlayState.SONG.song))
    {
        if (isStoryMode)
        {
            return;
        }

        // precaching music stuff (doesn't work idk why)
        Paths.music("characterSelect/charSelect-normal");
        Paths.music("characterSelect/charSelect-bf-pixel");
        Paths.music("characterSelect/charSelect-dave");
        Paths.music("characterSelect/charSelect-tristan");
        Paths.music("characterSelect/charSelect-bambi-new");
        Paths.music("characterSelect/charSelect-tristan-golden");
        Paths.music("characterSelect/charSelect-playrobot-player");

        boyfriend.visible = false;
        gf.visible = false;
    }
}

function generateCharacterArrows(noteType:String = "", regenerate:Bool)
{
    if(regenerate)
    {
        if(strummies.length > 0)
        {
            strummies.forEach(function(babyArrow)
            {
                remove(babyArrow);
                strummies.remove(babyArrow);
            });
        }
    }
    for(i in 0...4)
    {
        var babyArrow:FlxSprite = new FlxSprite(-500, FlxG.height - 40);
        var noteAsset:String = 'noteSkins/NOTE_assets';
        switch(noteType)
        {
            case 'pixel':
                noteAsset = 'noteSkins/NOTE_assets_pixel';
            case '3D':
                noteAsset = 'noteSkins/3D Notes/NOTE_3D_strumline';
        }
        babyArrow.frames = Paths.getSparrowAtlas(noteAsset);
		babyArrow.animation.addByPrefix('green', 'arrowUP');
		babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
		babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
		babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

        if (noteType == 'pixel' || noteType == '3D')
            babyArrow.antialiasing = false;
        else
            babyArrow.antialiasing = ClientPrefs.data.antialiasing;
		
        if (noteType == 'pixel')
		    babyArrow.setGraphicSize(Std.int(babyArrow.width * 8));
        else
            babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.95));

        var spacing = 150;
        babyArrow.x += spacing * i;
        if (downScroll)
        {
            babyArrow.y = FlxG.height - 80;
        }
        else
        { 
            babyArrow.y = -40;
            characterText.y = FlxG.height - 50;
        }

		switch (Math.abs(i))
		{
			case 0:
				babyArrow.animation.addByPrefix('static', 'arrowLEFT');
				babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
				babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
			case 1:
				babyArrow.animation.addByPrefix('static', 'arrowDOWN');
				babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
				babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
			case 2:
				babyArrow.animation.addByPrefix('static', 'arrowUP');
				babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
				babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
			case 3:
				babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
				babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
				babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
		}
		babyArrow.scrollFactor.set();
		babyArrow.ID = i;
	
		babyArrow.animation.play('static');
		babyArrow.x += 20;
		babyArrow.x += ((FlxG.width / 3.5));
		babyArrow.y -= 10;
		babyArrow.alpha = 0;

		var baseDelay:Float = regenerate ? 0 : 0.5;
		FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: baseDelay + (0.2 * i)});
		babyArrow.cameras = [camOther];
		strummies.add(babyArrow);
    }
}

function playArrowAnim(dir:Int)
{
    if (!allowCountdown)
    {
        var arrow:FlxSprite = strummies.members[dir];
        if (arrow != null)
        {
            var rgb:RGBPalette = new RGBShaderReference(arrow, new RGBPalette());
            var colors = ClientPrefs.data.arrowRGB;

            if (currentSelectedCharacter.forms[0].noteType == 'pixel')
            {
                rgb.r = colors[dir][0];
                rgb.g = colors[dir][1];
                rgb.b = colors[dir][2];
            }

            arrow.animation.play("confirm", true);
            arrow.centerOffsets();

            var timer = new FlxTimer();
            timer.start(0.1 / game.playbackRate, function(_ : FlxTimer)
            {
                arrow.animation.play("static", true);
                arrow.centerOffsets();
                arrow.shader = null;
            });
        }
    }
}

function onUpdate(elapsed:Float)
{
    if(!excludeSongs.contains(PlayState.SONG.song))
    {
        if (isStoryMode || allowCountdown)
        {
            return;
        }

        if (debug)
        {
            if(!allowCountdown)
            {
                if (FlxG.keys.justPressed.R)
                {
                    MusicBeatState.switchState(new PlayState());
                }
            }
        }

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
            if (!allowCountdown && noSpamming && !PressedTheFunny)
            {
                noSpamming = false;
                FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
                MusicBeatState.switchState(new FreeplayState());
            }
        }

        if (targetMusic != null && FlxG.sound.music != null)
        {
            FlxG.sound.music.volume += fadeInSpeed;
            if (FlxG.sound.music.volume >= 1)
            {
                FlxG.sound.music.volume = 1;
                targetMusic = null;
            }
        }

        songPositionFromTemu += elapsed * 1000;
        curBeatFromTemu = Std.int(songPositionFromTemu / (500));

        if (char != null && !selectedCharacter)
        {
            if (curBeatFromTemu % 2 == 0 && char.animation.curAnim.finished)
                char.dance();
        }
    
        if(!selectedCharacter)
        {
            if(controls.NOTE_LEFT_P && !FlxG.keys.pressed.LEFT)
            {
                char.playAnim('singLEFT', true);
                playArrowAnim(0);
            }
            if(controls.NOTE_DOWN_P && !FlxG.keys.pressed.DOWN)
            {
                char.playAnim('singDOWN', true);
                playArrowAnim(1);
            }
            if(controls.NOTE_UP_P && !FlxG.keys.pressed.UP)
            {
                char.playAnim('singUP', true);
                playArrowAnim(2);
            }
            if(controls.NOTE_RIGHT_P && !FlxG.keys.pressed.RIGHT)
            {
                char.playAnim('singRIGHT', true);
                playArrowAnim(3);
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
            new FlxTimer().start(1.3, endIt2);
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
            if (FlxG.keys.justPressed.UP)
            { 
                moveSelection(0, -1);
                updateIconSelection(); 
            }
            if (FlxG.keys.justPressed.DOWN)
            { 
                moveSelection(0, 1);
                updateIconSelection();
            }
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

// Add your character offsets, x, y and scale.

var characterOffsets:Map<String, {x:Float, y:Float, scale:Float}> = [
    'bf' => {x: 0, y: 0, scale: 1.15},
    'bf-pixel' => {x: 200, y: 140, scale: 7},
    'bf-3d' => {x: -70, y: -190, scale: 1.1},
    'bambi-new-playable' => {x: 10, y: 80, scale: 1.2},
    'dave-playable' => {x: 0, y: -200, scale: 1.1},
    'tristan-playable' => {x: 50, y: -50, scale: 1.1},
    'tristan-golden' => {x: 50, y: -50, scale: 1.1},
    'playrobot-playable' => {x: -50, y: -100, scale: 1.15}
];

function UpdateBF()
{
    var newSelectedCharacter = characters[current];
    if (currentSelectedCharacter.forms[0].noteType != newSelectedCharacter.forms[0].noteType)
	{
		generateCharacterArrows(newSelectedCharacter.forms[0].noteType, true);
	}
    currentSelectedCharacter = newSelectedCharacter;
	characterText.text = currentSelectedCharacter.forms[0].polishedName;
    characterText.x = -50;
    var len = characterText.text.length;
    if (len > 5)
    {
        characterText.x -= (len - 5) * 10; 
    }
    characterText.color = currentSelectedCharacter.forms[0].color;
    playCharacterMusic(currentSelectedCharacter.forms[0].music);
    char.changeCharacter(currentSelectedCharacter.forms[0].name);
    char.x = baseCharX;
    char.y = baseCharY;

    var cfg = characterOffsets.get(char.curCharacter);
    if (cfg != null)
    {
        char.x += cfg.x;
        char.y += cfg.y;
        char.scale.set(cfg.scale, cfg.scale);
    }
    insert(members.indexOf(characterText), char);

    if (char.curCharacter != 'bf-pixel')
    {
        for (key in char.animOffsets.keys())
        {
            char.animOffsets[key][0] *= char.scale.x;
            char.animOffsets[key][1] *= char.scale.y;
        }
    }
}

function endIt2(e:FlxTimer = null)
{
    transition();
}

function endIt(e:FlxTimer = null)
{
    allowCountdown = true;
    startCountdown();
    endCharacterSelect();
}


/*
 * Called when Character Select Ends.
*/

var nightColor:FlxColor = 0xFF51557A;

function endCharacterSelect()
{
    game.camOther.zoom = 1;
    
    if (char.curCharacter != 'bf')
    {
        triggerEvent('Change Character', 'bf', currentSelectedCharacter.forms[0].name);
    }
    boyfriend.visible = true;
    // unefficent way to do this, but if it works, it works
    runLuaCode('callScript("scripts/Change Girlfriend.lua", "changeGF", {})');
    gf.visible = true;
    if (PlayState.SONG.song == 'Splitathon' || PlayState.SONG.song == 'Glitch' || PlayState.SONG.song == 'Indignancy')
    {
        boyfriend.color = nightColor;
        gf.color = nightColor;
    }
    if (PlayState.SONG.song == 'Bonus-Song')
    {
        runLuaCode('callScript("stages/inside-house", "changeCouch", {})');
    }
    if (PlayState.SONG.song.toLowerCase() == 'roofs')
    {
        runLuaCode('callScript("data/roofs/baldi-change.lua", "changeChar", {})');
    }
    strummies.destroy();
    portraitsIcon.destroy();
    bg.destroy();
    char.destroy();
    characterText.destroy();
    gfIconGroup.destroy();
}
