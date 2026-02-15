local ogWindowTitle = ''

function onCreate()
    ogWindowTitle = getPropertyFromClass('flixel.FlxG', 'stage.window.title')
end

function onCreatePost()
    setProperty('allowDebugKeys', false)

    local titles = {
        "when you realize you have school this monday",
        "industrial society and its future",
        "my ears burn",
        "i got that weed card",
        "my ass itch",
        "bruh",
        "alright instagram its shoutout time"
    }

    local choice = titles[getRandomInt(1, #titles)]
    setPropertyFromClass('flixel.FlxG', 'stage.window.title', choice)
end


function onUpdate(elapsed)
    if keyJustPressed('debug_1') then
        loadSong('terminal', 1)
    end
end

function onDestroy()
    if ogWindowTitle ~= '' then
        setPropertyFromClass('flixel.FlxG', 'stage.window.title', ogWindowTitle)
    end
end
