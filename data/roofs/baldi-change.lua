function onCreate()
    addCharacterToList('baldi-3d', 'dad')
end

function changeChar()
    if boyfriendName == 'bf-3d' and gfName == 'gf-3d' then
        triggerEvent('Change Character', 'Dad', 'baldi-3d')
        loadGraphic('alarmClock', 'ui/timer-3d')
    end
end