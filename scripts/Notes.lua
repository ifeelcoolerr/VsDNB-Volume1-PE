luaDebugMode = true
local bf3dActive = false
local ogTexture
local ogUTexture
local ogUi

function onCountdownStarted()
    ogTexture = getPropertyFromGroup('playerStrums', 1, 'texture')
    ogUTexture = getPropertyFromGroup('unspawnNotes', 1, 'texture')
    ogUi = getPropertyFromClass('states.PlayState', 'stageUI')

    for i = 0, getProperty('strumLineNotes.length')-1 do
        setPropertyFromGroup('strumLineNotes', i, 'useRGBShader', false)
    end
end

function onUpdate()
    if not inGameOver then
        local isBf3d = boyfriendName == 'bf-3d'

        if isBf3d ~= bf3dActive then
            bf3dActive = isBf3d

            if bf3dActive then
                for i = 0, 4 do
                    setPropertyFromGroup('playerStrums', i, 'texture', 'noteSkins/3D Notes/NOTE_3D_strumline')
                end
                for i = 0, getProperty('unspawnNotes.length')-1 do
                    if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                        setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteSkins/3D Notes/3D_NOTE_assets')
                    end
                end
                setPropertyFromClass('states.PlayState', 'stageUI', 'ui/3D')
            else
                for i = 0, 4 do
                    setPropertyFromGroup('playerStrums', i, 'texture', ogTexture)
                end
                for i = 0, getProperty('unspawnNotes.length')-1 do
                    if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                        setPropertyFromGroup('unspawnNotes', i, 'texture', ogUTexture)
                    end
                end
                setPropertyFromClass('states.PlayState', 'stageUI', ogUi)
            end
        end
    end
end

function onSpawnNote(i, d, t, s)
    setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false)
end