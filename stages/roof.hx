import objects.BGSprite;

function onCreate()
{
    var sky:BGSprite = new BGSprite('backgrounds/roofs/gmsky', -355, -170, 0.7, 0.7);
    sky.setGraphicSize(Std.int(sky.width * 2));
    sky.antialiasing = false;
    addBehindGF(sky);
        
    var trees:BGSprite = new BGSprite('backgrounds/roofs/backtrees', -355, -170, 0.8, 0.8);
    trees.setGraphicSize(Std.int(trees.width * 1.5));
    trees.antialiasing = false;
    addBehindGF(trees);

    var roof:BGSprite = new BGSprite('backgrounds/roofs/gm_house5', -216, 381, 1, 1);
    roof.setGraphicSize(Std.int(roof.width * 1.5));
    roof.antialiasing = false;
    addBehindGF(roof);
}