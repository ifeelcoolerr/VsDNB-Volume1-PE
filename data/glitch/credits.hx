import flixel.text.FlxTextBorderStyle;

var credits:FlxText;

function onCreate()
{
    credits = new FlxText(4, game.healthBar.y + 50, 0, 'Original song Made by DeadShadow and PixelGH!', 16);
    credits.setFormat(Paths.font('comic.ttf'), 16, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    credits.scrollFactor.set();
    credits.borderSize = 1.25;
    credits.antialiasing = true;
    credits.cameras = [game.camHUD];
    game.add(credits);
}