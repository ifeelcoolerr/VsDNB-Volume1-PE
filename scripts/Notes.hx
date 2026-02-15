var dadPeople:Array<String> = ['dave-angey', 'exbungo', 'baldi-3d', 'bambi-3d'];

function goodNoteHit(note:Note)
{
    if (!note.isSustainNote) return;
    if (note.parent == null) return;

    if (note.parent.sustainLength < 100) return;

    if (note.parent.tail[note.parent.tail.length - 1] == note)
        game.playerStrums.members[note.noteData].playAnim('pressed', true);
}

function goodNoteHitPre(note:Note)
{
    if (!note.isSustainNote) return;
    if (note.parent == null) return;

    if (note.parent.tail[note.parent.tail.length - 1] != note) return;

    if (note.extraData.get("playedConfirm") == true) return;

    note.extraData.set("playedConfirm", true);

    game.playerStrums.members[note.noteData].playAnim('confirm', true);
}

function onUpdate()
{
    if (dadPeople.contains(dad.curCharacter))
    {
        for (strum in opponentStrums.members) {
			strum.texture = 'noteSkins/3D Notes/NOTE_3D_strumline';
			strum.useRGBShader = false;
		}
    }

    if (dadPeople.contains(dad.curCharacter))
        doNoteShits();
}

function doNoteShits() {
	for (note in unspawnNotes) {
		if ((note.noteType != '3d_notes' && !note.mustPress)) {
			note.texture = 'noteSkins/3D Notes/3D_NOTE_assets';
			note.rgbShader.enabled = false;
		}
	}
}
