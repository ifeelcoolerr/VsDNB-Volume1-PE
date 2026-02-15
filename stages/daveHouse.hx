import objects.BGSprite;
function onCreatePost()
{
    var bg:BGSprite = new BGSprite('backgrounds/shared/sky', -600, -300, 0.2, 0, null);
    addBehindGF(bg);

    var stageHills:BGSprite = new BGSprite('backgrounds/daveHouse/normal/hills', -834, -159, 0.35, 0.3, null);
    addBehindGF(stageHills);

    var grassbg:BGSprite = new BGSprite('backgrounds/daveHouse/normal/grass bg', -1205, 580, 0.65, 0.5);
    addBehindGF(grassbg);

    var gate:BGSprite = new BGSprite('backgrounds/daveHouse/normal/gate', -755, 250, 0.65, 0.75);
    addBehindGF(gate);

    var stageFront:BGSprite = new BGSprite('backgrounds/daveHouse/normal/grass', -832, 505, null);
    addBehindGF(stageFront);
}