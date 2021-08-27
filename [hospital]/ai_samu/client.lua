local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("ai_samu")


RegisterCommand("samu", function(source, args)
    if vRP.isInComa() then 
    	if emP.checkServices() then
    	    if emP.checkPayment() then
    	        TriggerEvent("Notify","sucesso","Você pagou $ 20000")
    		    TriggerEvent("knb:samu")
    		else
    		    TriggerEvent("Notify","negado","Você não possui dinheiro suficiente.")
    	    end
    	else
    		TriggerEvent("Notify","negado","Já existem paramédicos em serviço.")
    	end
    else
        TriggerEvent("Notify","negado","Você não pode utilizar este comando agora.")
    end
end, false)

AddEventHandler("knb:samu", function()
    player = GetPlayerPed(-1)
    playerPos = GetEntityCoords(player)
    
    
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player, 0.0, 5.0, 0.0)
    
    local targetVeh = GetTargetVehicle(player, inFrontOfPlayer)


    local driverhash = GetHashKey("s_m_m_paramedic_01")
    RequestModel(driverhash)
    local vehhash = GetHashKey("sprintersamu")
    RequestModel(vehhash)


    while not HasModelLoaded(driverhash) and RequestModel(driverhash) or not HasModelLoaded(vehhash) and RequestModel(vehhash) do
        RequestModel(driverhash)
        RequestModel(vehhash)
        Citizen.Wait(0)
    end

    if DoesEntityExist(targetVeh) then
    	if DoesEntityExist(samuVeh) then
			DeleteVeh(samuVeh, samuPed)
			SpawnVehicle(playerPos.x, playerPos.y, playerPos.x, vehhash, driverhash)
		else
			SpawnVehicle(playerPos.x, playerPos.y, playerPos.x, vehhash, driverhash)
		end
		GoToTarget(GetEntityCoords(targetVeh).x, GetEntityCoords(targetVeh).y, GetEntityCoords(targetVeh).z, samuVeh, samuPed, vehhash, targetVeh)
    end
end)

function SpawnVehicle(x, y, z, vehhash, driverhash)                                                     --Spawning Function
    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(x + math.random(-100, 100), y + math.random(-100, 100), z, 0, 3, 0)
    if found and HasModelLoaded(vehhash) and HasModelLoaded(vehhash) then
        samuVeh = CreateVehicle(vehhash, spawnPos, spawnHeading, true, false)                           --Car Spawning.
        ClearAreaOfVehicles(GetEntityCoords(samuVeh), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(samuVeh)
        samuPed = CreatePedInsideVehicle(samuVeh, 26, driverhash, -1, true, false)              		--Driver Spawning.
        samuBlip = AddBlipForEntity(samuVeh) 
        BeginTextCommandSetBlipName("STRING")
	    AddTextComponentString("SAMU")
	    EndTextCommandSetBlipName(samuBlip)--Blip Spawning.
        SetBlipFlashes(samuBlip, true)  
        SetBlipColour(samuBlip, 5)
    end
end

function DeleteVeh(vehicle, driver)
    SetEntityAsMissionEntity(vehicle, false, false)                                            			--Car Removal
    DeleteEntity(vehicle)
    SetEntityAsMissionEntity(driver, false, false)                                              		--Driver Removal
    DeleteEntity(driver)
    RemoveBlip(samuBlip)                                                                    			--Blip Removal
end

function GoToTarget(x, y, z, vehicle, driver, vehhash, target)
    TaskVehicleDriveToCoord(driver, vehicle, x, y, z, 17.0, 0, vehhash, 786603, 1, true)
    ShowAdvancedNotification("CHAR_CALL911", "~b~SAMU", "~r~Emergência", "Uma equipe está sendo enviada para sua localização.")
    enroute = true
    while enroute do
        Citizen.Wait(500)
        distanceToTarget = GetDistanceBetweenCoords(GetEntityCoords(target), GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z, true)
        if distanceToTarget < 20 then
            ShowAdvancedNotification("CHAR_DR_FRIEDLANDER", "~b~SAMU", "~r~Doutor Rogério", "Já estou chegando.")
            TaskVehicleTempAction(driver, vehicle, 27, 6000)
            GoToTargetWalking(target, vehicle, driver)
        end
    end
end

function GoToTargetWalking(target, vehicle, driver)
    while enroute do
        Citizen.Wait(500)
        deadplayer = GetEntityCoords(player)
        TaskGoToCoordAnyMeans(driver, deadplayer, 2.0, 0, 0, 786603, 0xbf800000)
        distanceToTarget = GetDistanceBetweenCoords(deadplayer, GetEntityCoords(driver).x, GetEntityCoords(driver).y, GetEntityCoords(driver).z, true)
        norunrange = false 
        if distanceToTarget <= 10 and not norunrange then -- stops ai from sprinting when close
            TaskGoToCoordAnyMeans(driver, deadplayer, 1.0, 0, 0, 786603, 0xbf800000)
            norunrange = true
        end
        if distanceToTarget <= 2 then
            TaskTurnPedToFaceCoord(driver, GetEntityCoords(target), -1)
            ShowAdvancedNotification("CHAR_DR_FRIEDLANDER", "~b~SAMU", "~r~Doutor Rogério", "O que aconteceu? Vou tentar reanimar você.")
            RequestAnimDict("mini@cpr@char_a@cpr_str")
			while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
			    Citizen.Wait(1000)
			end
			TaskPlayAnim(driver,"mini@cpr@char_a@cpr_str","cpr_pumpchest",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
            Citizen.Wait(10000)
            ClearPedTasks(driver)
            Reviver(vehicle, driver)
            ShowAdvancedNotification("CHAR_DR_FRIEDLANDER", "~b~SAMU", "~r~Doutor Rogério", "Tudo certo! Já vou indo.")
        end
        
    end
end

function Reviver(vehicle, driver)
	enroute = false
    norunrange = false
	FreezeEntityPosition(driver, false)
    Citizen.Wait(500)
    vRP.killGod()
	vRP.setHealth(150)
    TriggerEvent("Notify","sucesso","Reanimação efetuada com sucesso.")
    Citizen.Wait(5000)
    LeaveTarget(vehicle, driver)
end

function LeaveTarget(vehicle, driver)
	TaskVehicleDriveWander(driver, vehicle, 17.0, drivingStyle)
	SetEntityAsNoLongerNeeded(vehicle)
	SetPedAsNoLongerNeeded(driver)
	RemoveBlip(samuBlip)
	samuVeh = nil
	samuPed = nil
	targetVeh = nil
end

function GetTargetVehicle(player, dir)
    if vRP.isInComa() then 
        ped = GetPlayerPed(-1)
    end
    
    if DoesEntityExist(ped) then
        return ped
    else
        TriggerEvent("Notify","aviso","Você não pode utilizar este comando agora.")
    end
end



function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

