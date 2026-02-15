function onCreate()
    setProperty('allowDebugKeys', false)
end

function onUpdate(elapsed)
    if keyJustPressed('debug_1') then
        loadSong('kabunga', 1)
    end
end