Tunnel = module("vrp", "lib/Tunnel") -- para comunicação entre o client e server
Proxy = module("vrp", "lib/Proxy") -- necessario para comunicação entre os arquivos client e server
vRP = Proxy.getInterface("vRP") -- é utilizado para funções do framework VRP

Proxy.addInterface("cafetao", cafetao) -- aqui você cria a proxy para que o server leia funções do client
Tunnel.bindInterface("cafetao", cafetao) -- aqui é criado a comunicação entre os dois arquivos
cafetao = Tunnel.getInterface("cafetao") -- para realizar chamada de funções que estão no server.lua

local work = false
local hore = false
local destino = 0 
local hooker
local vehicle
local carro = false


Citizen.CreateThread(function()
    while true do
        --TUDO AQUI RODA O TEMPO TODO 
        local timeDistance = 500
        local ped = GetPlayerPed(-1)
        local plycoords = GetEntityCoords(ped)
        distance = GetDistanceBetweenCoords(cfg.coordinit.x,cfg.coordinit.y,cfg.coordinit.z,plycoords.x,plycoords.y, plycoords.z ,true) 
        if distance <= 2 then
            timeDistance = 5
            if not work then
                DrawText3D(cfg.coordinit.x,cfg.coordinit.y,cfg.coordinit.z + 1.16, 'CAFETÃO',1.4, 1)  
                DrawText3D(cfg.coordinit.x,cfg.coordinit.y,cfg.coordinit.z + 1.0, 'PRESSIONE ~b~E~w~  PARA ~g~INICIAR~w~',0.9, 1)
                DrawMarker(25, cfg.coordinit.x,cfg.coordinit.y,cfg.coordinit.z - 0.95 , 0, 0, 0, 0, 0, 0, 2.501, 2.5001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 1)
                if IsControlJustPressed(0,38) then
                    work = true
                    initService()
                    TriggerServerEvent("colocar-uniforme:cafetao")
                    TriggerEvent('Notify',"importante","Vá até a frente do estabelecimento e pegue seu veículo.")
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timeDistance = 500      
        if work then
            timeDistance = 5
            local ped = GetPlayerPed(-1)
            local plycoords = GetEntityCoords(ped)
            distance = GetDistanceBetweenCoords(cfg.coordGetHore.x,cfg.coordGetHore.y,cfg.coordGetHore.z,plycoords.x,plycoords.y, plycoords.z ,true)
            if distance <= 40 then
                DrawMarker(25, cfg.coordGetHore.x,cfg.coordGetHore.y,cfg.coordGetHore.z - 0.95 , 0, 0, 0, 0, 0, 0, 2.501, 2.5001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 1)
            end            
            if distance <= 2 and not hore then
                if  IsPedSittingInAnyVehicle(ped) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local model = GetEntityModel(vehicle)
                    local displaytext = GetDisplayNameFromVehicleModel(model)
                    if displaytext == cfg.veiculo then
                        DrawText3D(cfg.coordGetHore.x,cfg.coordGetHore.y,cfg.coordGetHore.z + 1.0, 'PRESSIONE ~b~E~w~  PARA ~g~PEGAR~w~ UMA ACOMPANHANTE',0.9, 1)  
                        if IsControlJustPressed(0,38) then
                            RemoveBlip(blip)
                            destino = math.random(1,57)
                            CriaBlipEntrega(cfg.locais,destino,5)
                            getHore(plycoords,ped)
                        end
                    end
                else
                    DrawText3D(cfg.coordGetHore.x,cfg.coordGetHore.y,cfg.coordGetHore.z + 1.0, 'VOCÊ PRECISA PEGAR O VEICULO!',0.9, 1)
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
    while true do
        local timeDistance = 500   
        if work and destino > 0 then
            timeDistance = 5
            local ped = GetPlayerPed(-1)
            local plycoords = GetEntityCoords(ped)
            distance = GetDistanceBetweenCoords(cfg.locais[destino].x,cfg.locais[destino].y,cfg.locais[destino].z,plycoords.x,plycoords.y, plycoords.z ,true)
            if distance <= 40 then
                DrawMarker(25, cfg.locais[destino].x,cfg.locais[destino].y,cfg.locais[destino].z - 0.95 , 0, 0, 0, 0, 0, 0, 2.501, 2.5001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 1)
            end
            if distance <=2 and IsPedSittingInAnyVehicle(ped) and hore then
                DrawText3D(cfg.locais[destino].x,cfg.locais[destino].y,cfg.locais[destino].z + 1.0, 'PRESSIONE ~b~E~w~  PARA ~g~DEIXAR~w~ A ACOMPANHANTE',0.9, 1)  
                if IsControlJustPressed(0,38) then
                    leaveHore(plycoords,ped)
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
	while true do
      local timeDistance = 500
      if work then
		timeDistance = 5
		drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
        if IsControlJustPressed(0,168) then
            work = false
            hore = false
            destino = 0 
            DeleteVehicle(carro)
            carro = nil
            RemoveBlip(blip)
            TriggerServerEvent("tirar-uniforme:cafetao")
            TriggerServerEvent("trydeleteped",PedToNet(hooker))
            TriggerEvent("Notify","negado","Você saiu de serviço.")
        end
      end
	  Citizen.Wait(timeDistance)
	end
end)

function getHore()
    vehicle =  GetVehiclePedIsIn(PlayerPedId(), false)
    hook = math.random(1,3)
    modelRequest(cfg.pedlist[hook].model)
    hooker = CreatePed(4,cfg.pedlist[hook].hash,cfg.spawnHore.x,cfg.spawnHore.y,cfg.spawnHore.z,3374176,true,false)
	SetEntityInvincible(hooker,true)
    SetEntityVisible(hooker, true, 0)
    TaskEnterVehicle(hooker, vehicle, -1, 1, 1.0, 1, 0)
    hore = true
end

function initService(plycoords,ped)
    if not carro then
        while not HasModelLoaded(cfg.veiculo) do
            RequestModel(cfg.veiculo)
            Citizen.Wait(10)
        end
        carro = CreateVehicle(cfg.veiculo,cfg.veiculoCoords.x,cfg.veiculoCoords.y,cfg.veiculoCoords.z,53.0,true,false)
        NetworkFadeInEntity(carro,true)
        SetVehicleIsStolen(carro,false)
        SetVehicleNumberPlateText(carro,vRP.getRegistrationNumber())
        SetVehicleOnGroundProperly(carro)
        SetVehicleHasBeenOwnedByPlayer(carro,true)
        SetEntityInvincible(carro,false)
        SetEntityAsMissionEntity(carro,true,true)
        SetVehicleDirtLevel(carro,0.0)
        SetModelAsNoLongerNeeded(cfg.veiculo)
    end
end

function leaveHore(plycoords,ped)
    TaskLeaveVehicle(hooker, vehicle, 0)
    TaskGoToCoordAnyMeans(hooker, cfg.locais[destino].xp, cfg.locais[destino].yp ,cfg.locais[destino].zp , 1.0, 0, 0, 3374176, 1.0)
    removePeds(hooker)
    hore = false
    cafetao.pagar()
    destino = 0;
    RemoveBlip(blip)
    CriaBlipBoate(cfg.coordGetHore,5)
end



--# REMOVER O PRODUTO
function removePeds(hooker)
	SetTimeout(20000,function()
		TriggerServerEvent("trydeleteped",PedToNet(hooker))
	end)
end

-- ESCREVER NA TELA
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function modelRequest(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(10)
	end
end

