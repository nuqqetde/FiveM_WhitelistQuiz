-- Lade die Fragen aus der externen Datei
local allQuestions = LoadResourceFile(GetCurrentResourceName(), 'server/questions.lua')
allQuestions = load(allQuestions)()

-- Konstanten für Quiz-Einstellungen
local QUESTIONS_PER_QUIZ = 10  -- Anzahl der Fragen pro Quiz
local REQUIRED_CORRECT = 8     -- Mindestanzahl richtiger Antworten zum Bestehen
local COOLDOWN_TIME = 7200     -- Wartezeit in Sekunden (2 Stunden)

-- Speichere die Cooldown-Zeiten für jeden Spieler
local playerCooldowns = {}

-- Funktion zum Mischen eines Arrays (Fisher-Yates Shuffle)
local function shuffleArray(array)
    local arrayCount = #array
    for i = arrayCount, 2, -1 do
        local j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
    return array
end

-- Funktion zum Auswählen zufälliger Fragen
local function getRandomQuestions()
    local shuffledQuestions = shuffleArray(table.clone(allQuestions))
    local selectedQuestions = {}
    
    for i = 1, QUESTIONS_PER_QUIZ do
        selectedQuestions[i] = shuffledQuestions[i]
    end
    
    return selectedQuestions
end

-- Funktion zum Überprüfen des Cooldowns
local function isPlayerOnCooldown(source)
    if not playerCooldowns[source] then
        return false
    end
    
    local currentTime = os.time()
    local timeRemaining = playerCooldowns[source] - currentTime
    
    if timeRemaining <= 0 then
        playerCooldowns[source] = nil
        return false
    end
    
    return true, math.ceil(timeRemaining / 60) -- Rückgabe der verbleibenden Minuten
end

-- Überprüfe die Quiz-Antworten
RegisterNetEvent('whitelist:checkAnswers')
AddEventHandler('whitelist:checkAnswers', function(answers)
    local source = source
    
    -- Überprüfe ob der Spieler noch im Cooldown ist
    local onCooldown, remainingMinutes = isPlayerOnCooldown(source)
    if onCooldown then
        TriggerClientEvent('whitelist:cooldown', source, remainingMinutes)
        return
    end
    
    local correct = 0
    local playerQuestions = GetPlayerQuestions(source)

    for i, answer in ipairs(answers) do
        if playerQuestions[i].correctAnswer == answer then
            correct = correct + 1
        end
    end

    local passed = correct >= REQUIRED_CORRECT
    
    if passed then
        print(string.format("Spieler %s hat den Whitelist-Test bestanden! (%d/%d korrekt)", GetPlayerName(source), correct, QUESTIONS_PER_QUIZ))
        TriggerClientEvent('whitelist:status', source, true)
    else
        print(string.format("Spieler %s hat den Whitelist-Test nicht bestanden (%d/%d korrekt)", GetPlayerName(source), correct, QUESTIONS_PER_QUIZ))
        playerCooldowns[source] = os.time() + COOLDOWN_TIME
        TriggerClientEvent('whitelist:status', source, false)
        TriggerClientEvent('whitelist:cooldown', source, COOLDOWN_TIME / 60)
    end
end)

-- Speichere die Fragen für jeden Spieler
local playerQuestions = {}

function GetPlayerQuestions(source)
    if not playerQuestions[source] then
        playerQuestions[source] = getRandomQuestions()
    end
    return playerQuestions[source]
end

-- Event um die Fragen an den Client zu senden
RegisterNetEvent('whitelist:getQuestions')
AddEventHandler('whitelist:getQuestions', function()
    local source = source
    
    -- Überprüfe ob der Spieler noch im Cooldown ist
    local onCooldown, remainingMinutes = isPlayerOnCooldown(source)
    if onCooldown then
        TriggerClientEvent('whitelist:cooldown', source, remainingMinutes)
        return
    end
    
    local questions = GetPlayerQuestions(source)
    local questionsForClient = {}
    
    for i, q in ipairs(questions) do
        questionsForClient[i] = {
            question = q.question,
            options = q.options
        }
    end
    
    TriggerClientEvent('whitelist:receiveQuestions', source, questionsForClient)
end)

-- Wenn ein Spieler den Server verlässt, lösche seine Daten
AddEventHandler('playerDropped', function()
    local source = source
    playerQuestions[source] = nil
    playerCooldowns[source] = nil
end) 