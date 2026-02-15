function onCreate()
    setProperty('allowDebugKeys', false)
end

function onUpdate(elapsed)
    if keyJustPressed('debug_1') then
        loadSong('Vs-Dave-Rap-Two')
    end
end