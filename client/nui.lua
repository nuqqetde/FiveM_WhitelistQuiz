-- NUI Callback für das Abrufen der Fragen
RegisterNUICallback('getQuestions', function(data, cb)
    TriggerServerEvent('whitelist:getQuestions')
    cb('ok')
end)

-- Event zum Empfangen der Fragen vom Server
RegisterNetEvent('whitelist:receiveQuestions')
AddEventHandler('whitelist:receiveQuestions', function(questions)
    SendNUIMessage({
        type = "setQuestions",
        questions = questions
    })
end) 