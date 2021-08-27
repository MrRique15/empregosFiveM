-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_tubarao")
PSserver = Tunnel.getInterface("vrp_tubarao","vrp_tubarao")
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local EntidadeSkin
local EntidadeTipo
local entityBlip = {}
local ProximoSpawn
local EntidadeViva = false
local entityHealth = {}
local entity = {}
local EntidadeSpawnada = true
local EntidadeRemovida = {}
local blipid = 0
local MissaoEmAndamento = false
local EntidadeTipo = {28}
local EntidadeSkin = {GetHashKey("a_c_deer")}
local proie = 1
local a = math.random(1, 10)
local CacadorVeiculo = false

local CoordenadasMissoes = {
    {x = 3839.9501953125,y = 4756.4873046875,z = 0.63276600837708},
    {x = 4060.6010742188,y = 4607.3696289063,z = -0.35087049007416},
    {x = 4000.1447753906,y = 4463.5712890625,z = 0.32227477431297},
    {x = 3901.4868164063,y = 4823.9736328125,z = -0.83160400390625},
    {x = 4038.9479980469,y = 4898.7836914063,z = 0.28605374693871},
    {x = 3843.9479980469,y = 4917.2875976563,z = -2.0620303153992},
    {x = 3648.4797363281,y = 4816.5693359375,z = -0.060442000627518},
    {x = 4086.3500976563,y = 4321.9760742188,z = 1.0775016546249},
    {x = 4153.1918945313,y = 4062.2294921875,z = -1.9204443693161},
    {x = 4261.2651367188,y = 4430.3911132813,z = -0.25099191069603}
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local blips = {
    {nome = "Caçador de Tubarão", cor = 30, id = 484, x = 3802.4013671875,y = 4441.2109375,z = 4.1565537452698 },   ------ 3802.40, 4441.21, 4.15
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, info.cor)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.nome)
        EndTextCommandSetBlipName(info.blip)
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local Coordenadas = GetEntityCoords(GetPlayerPed(-1))
        local Distancia = GetDistanceBetweenCoords(Coordenadas.x, Coordenadas.y, Coordenadas.z,3802.4013671875,4441.2109375,4.1565537452698, true)
        if Distancia < 10.0 then
            timeDistance = 5
            Opacidade = math.floor(255 - (Distancia * 20))
            DrawMarker(27, 3802.4013671875,4441.2109375,4.1565537452698-0.95, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 255, 255, 255, Opacidade, 0, 0, 0, 0)
            Texto3D(3802.4013671875,4441.2109375,4.1565537452698+0.8, "PRESSIONE ~b~ [ E ] ~w~PARA  INICIAR A CAÇAR DE TUBARAO", Opacidade)
        end
        Citizen.Wait(timeDistance)
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 500
        local Coordenadas = GetEntityCoords(GetPlayerPed(-1))
        local Distancia = GetDistanceBetweenCoords(Coordenadas.x, Coordenadas.y, Coordenadas.z, 3807.6318359375,4444.6713867188,3.8694088459015, true)
        if Distancia < 10.0 then
            timeDistance = 5
            Opacidade = math.floor(255 - (Distancia * 20))
            DrawMarker(27, 3807.6318359375,4444.6713867188,3.8694088459015-0.90, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 255, 255, 255, Opacidade, 0, 0, 0, 0)
            Texto3D(3807.6318359375,4444.6713867188,3.8694088459015+0.8, "PRESSIONE ~b~ [ E ] ~w~PARA PARAR DE CAÇAR TUBARAO", Opacidade)
        end
        Citizen.Wait(timeDistance)
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Texto3D(x,y,z, text, Opacidade)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.54, 0.54)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, Opacidade)
        SetTextDropshadow(0, 0, 0, 0, Opacidade)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    local EntidadeCoordenadas = {
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0},
        {x=0, y=0, z=0}
    }

    while true do
        local timeDistance = 500
        if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 3802.4013671875,4441.2109375,4.1565537452698, true) <= 1) then
            timeDistance = 5
            if (IsControlPressed(1, 38)) then
                if PSserver.checkPermission then
                    Wait(500)
                    MissaoEmAndamento = true
                    EntidadeTipo = {28,28,28,28,28}
                    EntidadeSkin = {
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger"),
                        GetHashKey("a_c_sharktiger")
                    }
                    EntidadeSpawnada = false
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"),1, true, true)
                    ProximoSpawn = AddBlipForCoord(CoordenadasMissoes[a].x,CoordenadasMissoes[a].y,CoordenadasMissoes[a].z)
                    SetNewWaypoint(CoordenadasMissoes[a].x,CoordenadasMissoes[a].y)
                    SetBlipColour(ProximoSpawn,1)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Presa")
                    EndTextCommandSetBlipName(ProximoSpawn)
                else
                    exports.pNotify:SendNotification({text = "Você não é um caçador de tubarão", type = "error", timeout = (6000),layout = "centerLeft"})
                end
            end
        end

        if (EntidadeSpawnada == false) then
            timeDistance = 5
            local SpawnPresa = math.random(1, 12)
            RequestModel(EntidadeSkin[proie])
            while not HasModelLoaded(EntidadeSkin[proie]) do
                Wait(1)
            end
            if (ProximoSpawn ~= nil) then
                RemoveBlip(ProximoSpawn)
            end
            entity[proie] = CreatePed(EntidadeTipo[SpawnPresa], EntidadeSkin[proie], CoordenadasMissoes[a].x, CoordenadasMissoes[a].y, CoordenadasMissoes[a].z, 0, true, true)
            SetEntityAsMissionEntity(entity[proie], true, true)
            TaskWanderStandard(entity[proie], 0, 0)
            entityBlip[proie] = AddBlipForEntity(entity[proie])
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Presa")
            EndTextCommandSetBlipName(entityBlip[proie])
            SetBlipSprite(entityBlip[proie],141)
            SetBlipColour(entityBlip[proie],2)
            EntidadeViva = true
            EntidadeSpawnada = true
        end

        if (MissaoEmAndamento == true and EntidadeSpawnada == true) then
            timeDistance = 5
            entityHealth[proie] = GetEntityHealth(entity[proie])
            blipid = entityBlip[proie]
            local vX , vY , vZ = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blipid, Citizen.ResultAsVector()))
            EntidadeCoordenadas[proie].x = vX
            EntidadeCoordenadas[proie].y = vY
            EntidadeCoordenadas[proie].z = vZ
            local Coordenadas = GetEntityCoords(GetPlayerPed(-1))
            local Distancia = GetDistanceBetweenCoords(Coordenadas.x, Coordenadas.y, Coordenadas.z, EntidadeCoordenadas[proie].x , EntidadeCoordenadas[proie].y , EntidadeCoordenadas[proie].z, true)
            Opacidade = math.floor(255 - (Distancia * 60))
            if (GetDistanceBetweenCoords( GetEntityCoords(GetPlayerPed(-1)),EntidadeCoordenadas[proie].x , EntidadeCoordenadas[proie].y , EntidadeCoordenadas[proie].z, true ) < 10) then
                if EntidadeViva == true then
                    Texto3D(EntidadeCoordenadas[proie].x , EntidadeCoordenadas[proie].y , EntidadeCoordenadas[proie].z, "Um tubarão bem ali, ~r~cuidado", Opacidade)
                else
                    Texto3D(EntidadeCoordenadas[proie].x , EntidadeCoordenadas[proie].y , EntidadeCoordenadas[proie].z, "Pressione ~y~[E] ~w~para pegar a carne", Opacidade)
                end
            end
            if (entityHealth[proie] == 0 and EntidadeViva == true) then
                SetBlipColour(entityBlip[proie],3)
                SetBlipSprite(entityBlip[proie],141)
                EntidadeViva = false
                EntidadeRemovida[proie] = false
            end

            if (GetDistanceBetweenCoords( GetEntityCoords(GetPlayerPed(-1)),EntidadeCoordenadas[proie].x , EntidadeCoordenadas[proie].y , EntidadeCoordenadas[proie].z, true ) < 1 and EntidadeViva == false) then
                if (IsControlPressed(1, 38)) then
                    TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_MEDIC_KNEEL", 0, 1)
                    Citizen.Wait(8000)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerServerEvent("zeus:ColhendoCarne")
                    RemoveBlip(entityBlip[proie])
                    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity[proie]))
                    EntidadeRemovida[proie] = true
                    EntidadeSpawnada = false
                    proie = math.random(1,12)
                    a = math.random(1, 10)
                    ProximoSpawn = AddBlipForCoord(CoordenadasMissoes[a].x,CoordenadasMissoes[a].y,CoordenadasMissoes[a].z)
                    SetNewWaypoint(CoordenadasMissoes[a].x,CoordenadasMissoes[a].y)
                    SetBlipColour(ProximoSpawn,1)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Caça")
                    EndTextCommandSetBlipName(ProximoSpawn)
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
