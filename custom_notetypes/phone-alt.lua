function onCreatePost()
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'phone-alt' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteSkins/NOTE_phone')
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'phone-alt' then
        if noteData == 0 then
            playAnim('dad', 'singLEFT-alt', true)
        elseif noteData == 3 then
            playAnim('dad', 'singRIGHT-alt', true)
        end
    end
end
