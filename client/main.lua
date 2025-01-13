local isWhitelisted = false
local characterCreated = false
local cooldownMinutes = 0

-- Event wenn Charakter erstellt wurde
RegisterNetEvent('character:created')
AddEventHandler('character:created', function()
    characterCreated = true
    if not isWhitelisted then
        ShowWhitelistQuiz()
    end
end)

-- Zeige das Quiz-Interface
function ShowWhitelistQuiz()
    if cooldownMinutes > 0 then
        return
    end
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "showQuiz"
    })
end

-- NUI Callback wenn Quiz abgeschlossen
RegisterNUICallback('quizComplete', function(data, cb)
    local answers = data.answers
    TriggerServerEvent('whitelist:checkAnswers', answers)
    cb('ok')
end)

-- Event wenn Whitelist-Status aktualisiert wird
RegisterNetEvent('whitelist:status')
AddEventHandler('whitelist:status', function(status)
    isWhitelisted = status
    if status then
        SetNuiFocus(false, false)
        TriggerEvent('whitelist:passed')
    else
        if cooldownMinutes <= 0 then
            ShowWhitelistQuiz()
        end
    end
end)

-- Event für Cooldown-Updates
RegisterNetEvent('whitelist:cooldown')
AddEventHandler('whitelist:cooldown', function(minutes)
    cooldownMinutes = minutes
    SendNUIMessage({
        type = "hidequiz"
    })
    SetNuiFocus(false, false)
end)

-- Verhindere Spieler-Spawn wenn nicht whitelisted
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not isWhitelisted and characterCreated then
            DisableAllControlActions(0)
            if cooldownMinutes > 0 then
                DrawText2D(string.format("Du musst %d Minuten warten, bevor du den Test erneut versuchen kannst!", cooldownMinutes), 0.5, 0.8)
                -- Reduziere den Cooldown jede Minute
                if (GetGameTimer() % 60000) < 50 then -- Prüfe etwa jede Minute
                    cooldownMinutes = cooldownMinutes - 1
                end
            else
                DrawText2D("Bitte beantworte zuerst den Whitelist-Fragebogen!", 0.5, 0.8)
            end
        end
    end
end)

-- Hilfsfunktion zum Anzeigen von Text
function DrawText2D(text, x, y)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end 