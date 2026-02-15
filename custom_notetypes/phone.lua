luaDebugMode = true
-- Most inconvenient way, its just a way to not make phone note's texture not get overrided by other notes
function onUpdatePost()
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'phone' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteSkins/NOTE_phone')
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'phone' then
        playAnim('dad', 'singSmash', true)
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if noteType ~= 'phone' then return end

    triggerEvent('Play Animation', 'singThrow', 'dad')
    if callMethod('boyfriend.hasAnimation', {'dodge'}) then
        triggerEvent('Play Animation', 'dodge', 'bf')
    else
        triggerEvent('Play Animation', 'hey', 'bf')
    end
    triggerEvent('Play Animation', 'cheer', 'gf')
end

function noteMiss(index, noteData, noteType, isSustain)
    if noteType ~= 'phone' then return end
    if isSustain then return end

    local strumID = noteData
    local strumPath = 'playerStrums.members['..strumID..']'

    setProperty(strumPath..'.alpha', 0)

    cancelTimer('restoreStrum'..strumID)
    runTimer('restoreStrum'..strumID, 1)

    playAnim('dad', 'singThrow', true)
end

function onTimerCompleted(tag)
    if string.find(tag, 'restoreStrum') then
        local strumID = tonumber((string.gsub(tag, 'restoreStrum', '')))
        local strumPath = 'playerStrums.members['..strumID..']'

        doTweenAlpha('restoreStrum'..strumID, strumPath, 1, 1, 'linear')
    end
end