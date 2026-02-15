local lastScore = 0

function onCreate()
    if not isStoryMode then return end
    initSaveData('scoreCheckDave')
end

function onUpdateScore()
    if not isStoryMode then return end
    lastScore = score
end

function onEndSong()
    if not isStoryMode then return end

    setDataFromSave('scoreCheckDave', 'score', score)
    flushSaveData('scoreCheckDave')

    loadSong('endingDave', 1)
    return Function_Stop
end
