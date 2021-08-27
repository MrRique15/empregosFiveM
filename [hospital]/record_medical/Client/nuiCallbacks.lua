RegisterNUICallback('getRegisterId', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 10)
        openNUI(true)

        if value then
            SendNUIMessage({
                registerId = value
            })
        end
    else
        local value = InsertValue('Type something', '', 10)

        if value then
            SendNUIMessage({
                registerId = value
            })
        end
    end
    cb('ok')
end)

RegisterNUICallback('getRegisterName', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 32)
        openNUI(true)

        if value then
            SendNUIMessage({
                registerName = value
            })
        end
    else
        local value = InsertValue('Type something', '', 32)

        if value then
            SendNUIMessage({
                registerName = value
            })
        end
    end

    cb('ok')
end)

RegisterNUICallback('getRegisterSangue', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 200)
        openNUI(true)

        if value then
            SendNUIMessage({
                registerSangue = value
            })
        end
    else
        local value = InsertValue('Type something', '', 200)

        if value then
            SendNUIMessage({
                registerSangue = value
            })
        end
    end

    cb('ok')
end)

RegisterNUICallback('getRegisterMotivo', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 200)
        openNUI(true)

        if value then
            SendNUIMessage({
                registerMotivo = value
            })
        end
    else
        local value = InsertValue('Type something', '', 200)

        if value then
            SendNUIMessage({
                registerMotivo = value
            })
        end
    end

    cb('ok')
end)

RegisterNUICallback('getRegisterDescripton', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 200)
        openNUI(true)

        if value then
            SendNUIMessage({
                registerDescription = value
            })
        end
    else
        local value = InsertValue('Type something', '', 200)

        if value then
            SendNUIMessage({
                registerDescription = value
            })
        end
    end

    cb('ok')
end)

RegisterNUICallback('register', function(data, cb)
    TriggerServerEvent('lg:registerConsult', data)
    cb('ok')
end)

RegisterNUICallback('searchId', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 10)
        openNUI(true)

        TriggerServerEvent('lg:getIdConsultations',value)
    else
        local value = InsertValue('Type something', '', 10)

        TriggerServerEvent('lg:getIdConsultations',value)
    end

    cb('ok')
end)

RegisterNUICallback('searchName', function(data, cb)
    if hiddenWhenWriting then
        openNUI(false)
        local value = InsertValue('Type something', '', 100)
        openNUI(true)

        TriggerServerEvent('lg:getNameConsultations',value)
    else
        local value = InsertValue('Type something', '', 100)

        TriggerServerEvent('lg:getNameConsultations',value)
    end
    
    cb('ok')
end)

RegisterNUICallback('searchAll', function(data, cb)
    TriggerServerEvent('lg:getAllConsultations')

    cb('ok')
end)

RegisterNUICallback('getPacient', function(data, cb)
    TriggerServerEvent('lg:getPacient', data)

    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SendNUIMessage({open=false})
    oppened = false

    cb('ok')
end)

