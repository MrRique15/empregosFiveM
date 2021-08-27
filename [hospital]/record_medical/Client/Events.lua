oppened = false
RegisterNetEvent("lg:openRecord")
AddEventHandler("lg:openRecord", function(result)
    local count = 0
    
    if result then
        count = result.consultations
    end

    SendNUIMessage({
        open = true,
        countConsultations = count
    })
    oppened = true
end)

RegisterNetEvent("lg:getConsultations")
AddEventHandler("lg:getConsultations", function(result)
    SendNUIMessage({
        loadedResult = true,
        result = result
    })
end)

RegisterNetEvent("lg:getPacient")
AddEventHandler("lg:getPacient", function(result)
    SendNUIMessage({
        loadedPacient = true,
        result = result
    })
end)