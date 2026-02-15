function onCreatePost()
    setProperty('camFollow.x', getMidpointX('gf'))
    setProperty('camFollow.y', getMidpointY('gf')/7)
end

function onCountdownTick(counter)
    local introSoundAssets = {
        default = {'default/intro3', 'default/intro2', 'default/intro1', 'default/introGo'},
        pixel = {'pixel/intro3-pixel', 'pixel/intro2-pixel', 'pixel/intro1-pixel', 'pixel/introGo-pixel'},
        dave = {'dave/intro3', 'dave/intro2', 'dave/intro1', 'dave/introGo'},
        bambi = {'bambi/intro3', 'bambi/intro2', 'bambi/intro1', 'bambi/introGo'},
        overdriving = {'dave/intro1', 'dave/intro2', 'dave/intro3', 'dave/introGo'},
        baldi = {'baldi/intro3', 'baldi/intro2', 'baldi/intro1', 'baldi/introGo'},
        exbungo = {'evil/intro3', 'evil/intro2', 'evil/intro1', 'evil/introGo'},
        playrobot = {'playrobot/intro3', 'playrobot/intro2', 'playrobot/intro1', 'playrobot/introGo'}
    }

    local songToSoundSet = {
        ['Warmup'] = 'dave', ['House'] = 'dave', ['Insanity'] = 'dave', ['Polygonized'] = 'dave', ['Splitathon'] = 'dave',
        ['Bonus-Song'] = 'dave', ['Vs-Dave-Rap'] = 'dave', ['Vs-Dave-Rap-Two'] = 'dave',

        ['Blocked'] = 'bambi', ['Corn Theft'] = 'bambi', ['Glitch'] = 'bambi',
        ['Maze'] = 'bambi', ['Mealie'] = 'bambi', ['Supernovae'] = 'bambi',
        ['Master'] = 'bambi', ['Cheating'] = 'bambi',

        ['Roofs'] = 'baldi',
        ['Kabunga'] = 'exbungo',
        ['Bot Trot'] = 'playrobot'
    }

    local key = (songName:lower() == 'kabunga') and 'Kabunga' or songName

    local soundAssetsAlt = introSoundAssets[songToSoundSet[key] or 'default']

    if counter >= 0 and counter <= 3 then
        playSound('countdown/' .. soundAssetsAlt[counter + 1], 0.6)
        cameraSetTarget(counter % 2 == 0 and 'boyfriend' or 'dad')
    end
end
