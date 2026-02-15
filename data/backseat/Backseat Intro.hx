import flixel.group.FlxTypedSpriteGroup;

var black:FlxSprite;
var cardGroup:FlxTypedSpriteGroup;
var card:FlxSprite;
var title:FlxText;
var titleDescription:FlxText;

function onCreate()
{
    game.skipCountdown = true;

    game.camHUD.alpha = 0;

    black = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    black.scale.set(FlxG.width * 2, FlxG.height * 2);
    black.updateHitbox();
    black.screenCenter();
    black.cameras = [game.camOther];
    add(black);
        
    cardGroup = new FlxTypedSpriteGroup();
    cardGroup.cameras = [game.camOther];
    cardGroup.scrollFactor.set();
    add(cardGroup);

    cardGroup.alpha = 0;

    buildCard();
}

function onStepHit()
{
    switch (curStep)
    {
        case 4:
            cardGroup.forEach(function(s:FlxSprite) {
                FlxTween.tween(s, {alpha: 1}, 0.5);
            }, true);
        case 32:
            FlxTween.tween(game.camHUD, {alpha: 1}, 0.5);
            cardGroup.forEach(function(s:FlxSprite) {
                FlxTween.tween(s, {alpha: 0}, 0.5);
            }, true);
            FlxTween.tween(black, {alpha: 0}, 0.5);
    }
}

function buildCard()
{
    card = new FlxSprite();
    card.frames = Paths.getSparrowAtlas('endings/backseat');
    card.animation.addByPrefix('idle', 'backseat', 24);
    card.animation.play('idle', true);
    card.screenCenter();
    card.y -= 100;
    cardGroup.add(card);

    title = new FlxText(0, 460, 0, 'Meanwhile...');
    title.setFormat(Paths.font('comic-sans.ttf'), 55, FlxColor.WHITE, 'center');
    title.screenCenter(0x01);
    cardGroup.add(title);

    titleDescription = new FlxText(0, 550, 0, 'During Dave\'s Week.');
    titleDescription.setFormat(Paths.font('comic-sans.ttf'), 24, FlxColor.WHITE, 'center');
    titleDescription.screenCenter(0x01);
    cardGroup.add(titleDescription);

    titleDescription.antialiasing = ClientPrefs.data.antialiasing;
    title.antialiasing = ClientPrefs.data.antialiasing;
    card.antialiasing = ClientPrefs.data.antialiasing;
}