-- CODE BY MOONLIGHT PSYCH ENGINE GO SUB TO THEM
holdingSpace = false
holdingShift = false

function onCountdownTick(counter)
    if counter == 4 then
        if getModSetting('gimmickWarnings') then
            makeLuaSprite('shapeNoteWarning', 'ui/shapeNoteWarning', 0, screenHeight * 2)
            setObjectCamera('shapeNoteWarning', 'hud')
            setScrollFactor('shapeNoteWarning', 1, 1)
            setProperty('shapeNoteWarning.alpha', 0)
            setProperty('shapeNoteWarning.antialiasing', false)
            addLuaSprite('shapeNoteWarning', true)

            doTweenAlpha('shapeNoteWarningA', 'shapeNoteWarning', 1, 1)
            doTweenY('shapeNoteWarningY', 'shapeNoteWarning', 450, 1, 'backOut')
        
            setObjectOrder('shapeNoteWarning', 999, 'uiGroup')
        end
    end
end

function onCountdownStarted()
	ogTexture = getPropertyFromGroup('playerStrums', 1, 'texture')
	
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'shape' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'noteSkins/NOTE_assets_Shape_optimized')
			setPropertyFromGroup('unspawnNotes', i, 'antialiasing', false)
			--small fix
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
				callMethod('unspawnNotes['..i..'].animation.play', {getPropertyFromClass('objects.Note', 'colArray')[getProperty('unspawnNotes['..i..'].noteData')+1 % 4]..'hold', true})
			else
				setPropertyFromGroup('unspawnNotes', i, 'offset.x', 2)
			end
		end
		setPropertyFromGroup('unspawnNotes', i, 'copyAlpha', false)
	end
end

function onUpdate()
	if not inGameOver then
        holdingSpace = keyboardPressed('SPACE')
        holdingShift = keyboardPressed('SHIFT')

		for i = 0,3 do
            local tex = (holdingSpace or holdingShift) and 'noteSkins/Shape_notes' or ogTexture
            setPropertyFromGroup('playerStrums', i, 'texture', tex)
        end

		for i = 0, getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'mustPress') then
                if getPropertyFromGroup('notes', i, 'noteType') == 'shape' then
                    local coolAlpha = (holdingSpace or holdingShift) and 1 or 0.5
                    setPropertyFromGroup('notes', i, 'alpha', (not getPropertyFromGroup('notes', i, 'isSustainNote') and coolAlpha * getPropertyFromGroup('notes', i, 'multAlpha') or 0.5))
                    setPropertyFromGroup('notes', i, 'blockHit', not (holdingSpace or holdingShift))
                else
                    local coolAlpha = (holdingSpace or holdingShift) and 0.5 or 1
                    setPropertyFromGroup('notes', i, 'alpha', (not getPropertyFromGroup('notes', i, 'isSustainNote') and coolAlpha * getPropertyFromGroup('notes', i, 'multAlpha') or 0.5))
                    setPropertyFromGroup('notes', i, 'blockHit', (holdingSpace or holdingShift))
                end
            end
        end
	end
end

function onTweenCompleted(tag)
    if tag == 'shapeNoteWarningY' then
        runTimer('disappear', 2)
    end

    if tag == 'shapeNoteWarningY2' then
        removeLuaSprite('shapeNoteWarning')
    end
end

function onTimerCompleted(tag)
    if tag == 'disappear' then
        doTweenAlpha('shapeNoteWarningA2', 'shapeNoteWarning', 0, 1)
        doTweenY('shapeNoteWarningY2', 'shapeNoteWarning', screenHeight * 2, 1, 'backIn')
    end
end