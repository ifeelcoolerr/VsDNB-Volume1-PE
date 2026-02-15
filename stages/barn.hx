import objects.BGSprite;

function onCreate()
{
    var bg:BGSprite = new BGSprite('backgrounds/barn/bg', -1380, -235);
    bg.scale.set(0.9, 0.9);
    bg.updateHitbox();
    addBehindGF(bg);

    var pole:BGSprite = new BGSprite('backgrounds/barn/pole', -1450, -400, 1.3, 1);
    addBehindGF(pole);

    var hay:BGSprite = new BGSprite('backgrounds/barn/bghayfront', 1300, 800, 1.3, 1);
    addBehindGF(hay);

    var light:BGSprite = new BGSprite('backgrounds/barn/barnlight', -250, 175, 1.1, 1.1);
    light.scale.set(3, 3);
    light.updateHitbox();
    light.screenCenter();
    add(light);
}