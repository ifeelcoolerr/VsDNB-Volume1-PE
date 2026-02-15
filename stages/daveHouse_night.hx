import objects.BGSprite;
var nightColor:FlxColor = 0xFF51557A;
var bg:BGSprite;
var stageHills:BGSprite;
var grassbg:BGSprite;
var gate:BGSprite;
var stageFront:BGSprite;
function onCreate()
{
    bg = new BGSprite('backgrounds/shared/sky_night', -600, -300, 0.2, 0, null);
    addBehindGF(bg);

    stageHills = new BGSprite('backgrounds/daveHouse/night/hills', -834, -159, 0.35, 0.3, null);
    addBehindGF(stageHills);

    grassbg = new BGSprite('backgrounds/daveHouse/night/grass bg', -1205, 580, 0.65, 0.5);
    addBehindGF(grassbg);

    gate = new BGSprite('backgrounds/daveHouse/night/gate', -755, 250, 0.65, 0.75);
    addBehindGF(gate);

    stageFront = new BGSprite('backgrounds/daveHouse/night/grass', -832, 505, null);
    addBehindGF(stageFront);

    boyfriendGroup.color = nightColor;
    dadGroup.color = nightColor;
    gfGroup.color = nightColor;
    stageHills.color = nightColor;
    grassbg.color = nightColor;
    gate.color = nightColor;
    stageFront.color = nightColor;

    setVar('gate', gate);
}