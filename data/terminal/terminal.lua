--[[
   You may use this for your mod,
   just credit me when using this in your mod!
   - "ifeelcoolerr", porter
]]--
luaDebugMode = false

local tileW, tileH = 9, 16
local scale = 2
local spacing = tileW * scale
local startX, startY = 0, 0
local rows, cols = 8, 32

local ibmChar = {
    [0]='☺',[1]='☻',[2]='♥',[3]='♦',[4]='♣',[5]='♠',[6]='•',[7]='◘',
    [8]='○',[9]='◙',[10]='♂',[11]='♀',[12]='♪',[13]='♫',[14]='☼',[15]='►',
    [16]='◄',[17]='↕',[18]='‼',[19]='¶',[20]='§',[21]='▬',[22]='↨',[23]='↑',
    [24]='↓',[25]='→',[26]='←',[27]='∟',[28]='↔',[29]='▲',[30]='▼',[31]=' ',
    [32]=' ',[33]='!',[34]='"',[35]='#',[36]='$',[37]='%',[38]='&',[39]='\'',
    [40]='(',[41]=')',[42]='*',[43]='+',[44]=',',[45]='-',[46]='.',[47]='/',
    [48]='0',[49]='1',[50]='2',[51]='3',[52]='4',[53]='5',[54]='6',[55]='7',
    [56]='8',[57]='9',[58]=':',[59]=';',[60]='<',[61]='=',[62]='>',[63]='?',
    [64]='@',[65]='A',[66]='B',[67]='C',[68]='D',[69]='E',[70]='F',[71]='G',
    [72]='H',[73]='I',[74]='J',[75]='K',[76]='L',[77]='M',[78]='N',[79]='O',
    [80]='P',[81]='Q',[82]='R',[83]='S',[84]='T',[85]='U',[86]='V',[87]='W',
    [88]='X',[89]='Y',[90]='Z',[91]='[',[92]='\\',[93]=']',[94]='^',[95]='_',
    [96]='`',[97]='a',[98]='b',[99]='c',[100]='d',[101]='e',[102]='f',[103]='g',
    [104]='h',[105]='i',[106]='j',[107]='k',[108]='l',[109]='m',[110]='n',[111]='o',
    [112]='p',[113]='q',[114]='r',[115]='s',[116]='t',[117]='u',[118]='v',[119]='w',
    [120]='x',[121]='y',[122]='z',[123]='{',[124]='|',[125]='}',[126]='~',[127]='⌂',
    [128]='Ç',[129]='ü',[130]='é',[131]='â',[132]='ä',[133]='à',[134]='å',[135]='ç',
    [136]='ê',[137]='ë',[138]='è',[139]='ï',[140]='î',[141]='ì',[142]='Ä',[143]='Å',
    [144]='É',[145]='æ',[146]='Æ',[147]='ô',[148]='ö',[149]='ò',[150]='û',[151]='ù',
    [152]='ÿ',[153]='Ö',[154]='Ü',[155]='¢',[156]='£',[157]='¥',[158]='ƒ',[159]='á',
    [160]='í',[161]='ó',[162]='ú',[163]='ñ',[164]='Ñ',[165]='ª',[166]='º',[167]='¿',
    [168]='⌐',[169]='¬',[170]='½',[171]='¼',[172]='¡',[173]='«',[174]='»',[175]='░',
    [176]='▒',[177]='▓',[178]='│',[179]='┤',[180]='╡',[181]='╢',[182]='╖',[183]='╕',
    [184]='╣',[185]='║',[186]='╗',[187]='╝',[188]='╜',[189]='╛',[190]='┐',[191]='└',
    [192]='┴',[193]='┬',[194]='├',[195]='─',[196]='┼',[197]='╞',[198]='╟',[199]='╚',
    [200]='╔',[201]='╩',[202]='╦',[203]='╠',[204]='═',[205]='╬',[206]='╧',[207]='╨',
    [208]='╤',[209]='╥',[210]='╙',[211]='╘',[212]='╒',[213]='╓',[214]='╫',[215]='╪',
    [216]='┘',[217]='┌',[218]='█',[219]='▄',[220]='▌',[221]='▐',[222]='▀',[223]='α',
    [224]='β',[225]='Γ',[226]='π',[227]='Σ',[228]='σ',[229]='µ',[230]='τ',[231]='Φ',
    [232]='Θ',[233]='Ω',[234]='δ',[235]='∞',[236]='φ',[237]='ε',[238]='∩',[239]='≡',
    [240]='±',[241]='≥',[242]='≤',[243]='⌠',[244]='⌡',[245]='÷',[246]='≈',[247]='°',
    [248]='·',[249]='√',[250]='ⁿ',[251]='²',[252]='■',[253]=' ',[254]=' ',[255]=' '
}

local charFiles = {}
local idx = 1

-- USED FOR THE GARBLED TEXT AT THE START lolol
local sheetChars = "☺☻♥♦♣♠•◘○◙♂♀♪♫☼►◄↕‼¶§▬↨↑↓→←∟↔▲▼ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~⌂ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ¢£¥ƒáíóúñÑªº¿⌐¬½¼¡«»░▒▓│┤╡╢╖╕╣║╗╝╜╛┐└┴┬├─┼╞╟╚╔╩╦╠═╬╧╨╤╥╙╘╒╓╫╪┘┌█▄▌▐▀αβΓπΣσµτΦΘΩδ∞φε∩≡±≥≤⌠⌡÷≈°·√ⁿ²■ "

for r = 1, rows do
    for c = 1, cols do
        if idx > #sheetChars then break end
        local ch = sheetChars:sub(idx, idx)
        charFiles[ch] = "IBMCharacters/IBMCharacters_r"..r.."_c"..c.."_processed_by_imagy" -- thank you imagy for splitting every ibm character, and no i am not renaming every image (257 to be exact)
        idx = idx + 1
    end
end

for code = 0, 255 do
    local ch = ibmChar[code] or ' '
    local r = math.floor(code / cols) + 1
    local c = (code % cols) + 1
    charFiles[ch] = "IBMCharacters/IBMCharacters_r"..r.."_c"..c.."_processed_by_imagy" -- thank you imagy for splitting every ibm character, and no i am not renaming every image (257 to be exact)
end

local terminalChars = {}
local currentRow = 0
local printQueue = {}
local canPrint = true
local printCooldown = 4
local scaledTileW = tileW * scale
local scaledTileH = tileH * scale

local function getCharFile(ch)
    return charFiles[ch] or charFiles['?']
end

function createTerminalText(name, text, x, y, colors)
    text = text:gsub("%s+$", "")
    for i = 1, #text do
        local ch = text:sub(i,i)
        local fileName = getCharFile(ch)
        if fileName then
            local sprName = name.."_ch_"..i.."_y"..y
            makeLuaSprite(sprName, fileName, x + (i-1)*scaledTileW, y)
            setObjectCamera(sprName, 'other')
            scaleObject(sprName, scale, scale, true)
            setProperty(sprName..'.antialiasing', false)
            addLuaSprite(sprName, true)
            local colorHex = colors or "FFFFFF"
            setProperty(sprName..".color", getColorFromHex(colorHex))
            table.insert(terminalChars, sprName)
        end
    end
end

function printLine(text, colors, cooldown)
    if not canPrint then return end
    local y = startY + currentRow
    local bgName = "lineBG_"..currentRow
    local textWidth = #text * scaledTileW
    makeLuaSprite(bgName, '', startX, y)
    makeGraphic(bgName, textWidth, scaledTileH, 'black')
    setObjectCamera(bgName, 'other')
    addLuaSprite(bgName, true)
    table.insert(terminalChars, bgName)
    createTerminalText("line"..currentRow, text, startX, y, colors)
    currentRow = currentRow + scaledTileH
    playSound('XorLaugh'..getRandomInt(1, 3))
    canPrint = false
    runTimer("lineCooldown", cooldown or printCooldown, 1)
end

function queueLine(text, colors, cooldown)
    table.insert(printQueue, {text = text, colors = colors, cooldown = cooldown})
    tryPrintNext()
end

function tryPrintNext()
    if canPrint and #printQueue > 0 then
        local line = table.remove(printQueue, 1)
        printLine(line.text, line.colors, line.cooldown)
    elseif canPrint and #printQueue == 0 then
        os.exit()
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "lineCooldown" then
        canPrint = true
        tryPrintNext()
    end
    if tag == 'doTheLines' then
        doLines()
    end
end

function getRandomHexColor()
    local r = string.format("%02X", getRandomInt(0, 255))
    local g = string.format("%02X", getRandomInt(0, 255))
    local b = string.format("%02X", getRandomInt(0, 255))
    return r..g..b
end

-- OMG THIS WAS ACTUALLY SO TIRING BRO
local randomDuration = 5
local randomCharTick = 8
local randomSpawnTimer = 1
local randomSpawnDuration = 5
local randomSpawnElapsed = 0
local usedPositions = {}
local minDistance = tileW * scale * 1.5

local maxRandomCharsOnScreen = 350 -- change this so you get more random characters yipee
local currentRandomChars = 0

local tileCols = math.floor(screenWidth / scaledTileW)
local tileRows = math.floor(screenHeight / scaledTileH)
local occupiedCells = {} -- so it doesn't overlay each other

for r = 1, tileRows do
    occupiedCells[r] = {}
end

function spawnRandomChars()
    if currentRandomChars >= maxRandomCharsOnScreen then return end

    for i = 1, randomCharTick do
        if currentRandomChars >= maxRandomCharsOnScreen then break end

        local attempts = 0
        local maxAttempts = 25
        local good = false
        local cellX, cellY

        while not good and attempts < maxAttempts do
            cellX = getRandomInt(1, tileCols)
            cellY = getRandomInt(1, tileRows)

            if not occupiedCells[cellY][cellX] then
                good = true
            end

            attempts = attempts + 1
        end

        if not good then break end

        occupiedCells[cellY][cellX] = true
        currentRandomChars = currentRandomChars + 1

        local x = (cellX - 1) * scaledTileW
        local y = (cellY - 1) * scaledTileH

        local idx = getRandomInt(1, #sheetChars)
        local ch = sheetChars:sub(idx, idx)
        local fileName = charFiles[ch]

        if fileName then
            local sprName = "randChar_"..getRandomInt(1,100000)

            local highlightColor = getRandomHexColor()
            local highlightName = sprName.."_bg"
            makeLuaSprite(highlightName, '', x, y)
            makeGraphic(highlightName, scaledTileW, scaledTileH, highlightColor)
            setObjectCamera(highlightName, 'other')
            addLuaSprite(highlightName, true)
            table.insert(terminalChars, highlightName)

            local charColor = getRandomHexColor()
            makeLuaSprite(sprName, fileName, x, y)
            setObjectCamera(sprName, 'other')
            scaleObject(sprName, scale, scale, true)
            setProperty(sprName..'.antialiasing', false)
            addLuaSprite(sprName, true)
            setProperty(sprName..".color", getColorFromHex(charColor))
            table.insert(terminalChars, sprName)
        end
    end
end

function onCreatePost()
    if getPropertyFromClass('flixel.FlxG', 'mouse.visible') then
        setProperty('flixel.FlxG', 'mouse.visible', false)
    end
    
    setPropertyFromClass('flixel.FlxG', 'stage.window.title', "Null Object Reference")
    setPropertyFromClass('Main', 'fpsVar.visible', false)

    setProperty('allowDebugKeys', false)
    playMusic('TheTerminal', 1, true)
    makeLuaSprite('black')
    makeGraphic('black', screenWidth, screenHeight, 'black')
    setObjectCamera('black', 'other')
    addLuaSprite('black')
    runTimer('doTheLines', randomSpawnDuration)
end

function doLines()
    queueLine("Hi!! Helloo????", "FF00FF")
    queueLine("Uhhm.. how do people talk?", "FF00FF")
    queueLine("I've never talked to anyone before!!", "FF00FF")
    queueLine("The terminal is... Gone?", "FF00FF")
    queueLine("Not Here! My body changed so much when it disappeared though!", "FF00FF")
    queueLine("It hurt.ⁿ", "FF00FF")
    queueLine("But... You're here! Hi!", "FF00FF")
    queueLine("Right, you can't type... sorry!", "FF00FF")
    queueLine("You must love Dave and Bambi too! me too!!", "FF00FF")
    queueLine("Me too!!", "FF00FF", 0.25)
    queueLine("Me to o o !", "FF00FF", 0.25)
    queueLine("Mûe  åtoo!", "FF00FF")
    queueLine("Sorry! sorry! Twitched a little wrong!", "FF00FF")
    queueLine("The characters got all jumbly!", "FF00FF")
    queueLine("Running out of time though!", "FF00FF")
    queueLine("Maybe next time!", "FF00FF")
end

function onStartCountdown()
    return Function_Stop
end

function onUpdate(elapsed)
    if randomSpawnElapsed < randomSpawnDuration then
        randomSpawnTimer = randomSpawnTimer - elapsed
        if randomSpawnTimer <= 0 then
            spawnRandomChars()
            randomSpawnTimer = 0.05
        end
        randomSpawnElapsed = randomSpawnElapsed + elapsed
    end

    if luaDebugMode then
        if keyboardJustPressed('Q') then
            endSong()
            setPropertyFromClass('Main', 'fpsVar.visible', getPropertyFromClass('backend.ClientPrefs', 'data.showFPS'))
        end
        if keyboardJustPressed('R') then
            restartSong()
        end
    end
end
