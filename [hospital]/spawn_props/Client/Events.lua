ObjectsSpawnned = {}

local spawnned = false

AddEventHandler('playerSpawned', function()
    if not spawnned then
        TriggerServerEvent('lg: loadProps')
    end

    spawnned = true
end)

RegisterNetEvent('lg: openPropMenu')
AddEventHandler('lg: openPropMenu', function(result)
    SendNUIMessage({
        list_props = result
    })
    SetNuiFocus(true, true)
    openned = true
end)

RegisterNetEvent('lg: createClientObject')
AddEventHandler('lg: createClientObject', function(data)
    newObject(data)
end)

RegisterNetEvent('lg: updateClientProp')
AddEventHandler('lg: updateClientProp', function(data)
    removeObject(data.id)
    newObject(data)
end)

RegisterNetEvent('lg: disableClientProp')
AddEventHandler('lg: disableClientProp', function(data)
   removeObject(data.id)
end)

RegisterNetEvent('lg: updateProp')
AddEventHandler('lg: updateProp', function(data)
    SendNUIMessage({
        element = data
    })
end)

RegisterNetEvent('lg: loadProps')
AddEventHandler('lg: loadProps', function(result)
    if result and #result > 0 then
        for i,k in pairs(result) do
            newObject(k)
        end
    end
end)

RegisterNetEvent('lg: changeStatus')
AddEventHandler('lg: changeStatus', function(data)
   SendNUIMessage({
       changeStatus = true,
       id = data.id,
       status = data.status
   })
end)

RegisterNetEvent('lg: removeClosestProp')
AddEventHandler('lg: removeClosestProp', function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    for i,k in pairs(ObjectsSpawnned) do
        local x = tonumber(k.pos_x)*1.0
        local y = tonumber(k.pos_y)*1.0
        local z = tonumber(k.pos_z)*1.0

        if #(vector3(x,y,z) - pos) < 1.5 then
            TriggerServerEvent('lg: deleteProp', {id = i})
        end
    end
end)

RegisterNetEvent('lg: removeAllProps')
AddEventHandler('lg: removeAllProps', function()
    for i,k in pairs(ObjectsSpawnned) do
        removeObject(i)
    end
end)

RegisterNetEvent('lg: loadFolders')
AddEventHandler('lg: loadFolders', function(result)
    SendNUIMessage({
        receiveFolders = true,
        folders = result
    })
end)

RegisterNetEvent('lg: openFolder')
AddEventHandler('lg: openFolder', function(result)
    SendNUIMessage({
        openFolder = true,
        folder_props = result
    })
end)

RegisterNetEvent('lg: disableAll')
AddEventHandler('lg: disableAll', function(result)
    for i,k in pairs(result) do
        removeObject(k.id)
    end
end)


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    TriggerServerEvent('lg: loadProps')
end)
    

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    
    for i,k in pairs(ObjectsSpawnned) do
        removeObject(i)
    end
end)
  
  