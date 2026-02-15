var shakeCam:Bool;

function onUpdate(elapsed:Float)
{
    if (shakeCam && ClientPrefs.data.flashing)
    {
        FlxG.camera.shake(0.010, 0.010);
    }
}

function onStepHit()
{
    switch (curStep)
    {
        case 848:
            shakeCam = false;
        case 132, 612, 740, 771, 836:
            shakeCam = true;
        case 144, 624, 752, 784:
            shakeCam = false;
    }
}