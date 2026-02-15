function changeGF()
    local gfMap = {
        ['bambi-new-playable'] = 'bambi-haystack',
        ['bf-pixel'] = 'gf-pixel',
        ['bf-3d'] = 'gf-3d',
        ['dave-playable'] = 'dave-boombox',
        ['tristan-playable'] = 'playrobot-gf',
        ['tristan-golden'] = 'playrobot-gf',
        ['playrobot-playable'] = 'tristan-gf'
    }

    local gfCharacter = gfMap[boyfriendName]
    if gfCharacter then
        triggerEvent('Change Character', 'gf', gfCharacter)
    end

    setScrollFactor('gfGroup', 1, 1)
end