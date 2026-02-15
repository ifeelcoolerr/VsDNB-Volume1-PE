function onMoveCamera(focus:String)
{
	if (focus == 'dad')
	{
        FlxTween.tween(game, {defaultCamZoom: 1}, (Conductor.crochet / 700 * game.gf.danceEveryNumBeats), {ease: FlxEase.backInOut});
	}
	else
	{
        FlxTween.tween(game, {defaultCamZoom: 0.9}, (Conductor.crochet / 700 * game.gf.danceEveryNumBeats), {ease: FlxEase.backInOut});
	}
}