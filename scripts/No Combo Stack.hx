// This makes it so the numbers only stack, whilst the others do not.

var prevRating:FlxSprite;
var prevCombo:FlxSprite;

function goodNoteHit(n:Note)
{
    if (n.isSustainNote) return;

    if (prevRating != null)
    {
        prevRating.kill();
        FlxTween.cancelTweensOf(prevRating);
    }

    if (prevCombo != null)
    {
        prevCombo.kill();
        FlxTween.cancelTweensOf(prevCombo);
    }

    prevRating = game.comboGroup.members[game.comboGroup.length - (game.showCombo ? 2 : 4)];
    prevCombo  = game.comboGroup.members[game.comboGroup.length - 4];
}
