-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
emP = Tunnel.getInterface("nav_caminhao")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "gasolina-01" then
		spawnVehicle("tanker2",1198.22,-3237.73,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Combustível</b> liberada.")
	elseif data == "gasolina-02" then
		spawnVehicle("tanker2",1203.54,-3237.74,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Combustível</b> liberada.")

	elseif data == "diesel-01" then
		spawnVehicle("armytanker",1198.22,-3237.73,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Diesel</b> liberada.")
	elseif data == "diesel-02" then
		spawnVehicle("armytanker",1203.54,-3237.74,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Diesel</b> liberada.")

	elseif data == "show-01" then
		spawnVehicle("tvtrailer",1198.22,-3237.73,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Shows</b> liberada.")
	elseif data == "show-02" then
		spawnVehicle("tvtrailer",1203.54,-3237.74,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Shows</b> liberada.")

	elseif data == "madeira-01" then
		spawnVehicle("trailerlogs",1198.22,-3237.73,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Madeiras</b> liberada.")
	elseif data == "madeira-02" then
		spawnVehicle("trailerlogs",1203.54,-3237.74,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Madeiras</b> liberada.")

	elseif data == "carros-01" then
		spawnVehicle("tr4",1198.22,-3237.73,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Veículos</b> liberada.")
	elseif data == "carros-02" then
		spawnVehicle("tr4",1203.54,-3237.74,6.05)
		TriggerEvent("Notify","sucesso","Carga de <b>Veículos</b> liberada.")

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)

function spawnVehicle(name,x,y,z)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		local nveh = CreateVehicle(mhash,x,y,z+0.5,0,1594,true,false)
		local netveh = VehToNet(nveh)
		local id = NetworkGetNetworkIdFromEntity(nveh)

		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Citizen.Wait(1)
		end

		if NetworkDoesNetworkIdExist(netveh) then
			SetEntitySomething(nveh,true)
			if NetworkGetEntityIsNetworked(nveh) then
				SetNetworkIdExistsOnAllMachines(netveh,true)
			end
		end

		SetNetworkIdCanMigrate(id,true)
		SetVehicleNumberPlateText(NetToVeh(netveh),"CAMINHAO")
		Citizen.InvokeNative(0xAD738C3085FE7E11,NetToVeh(netveh),true,true)
		SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
		SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
		SetModelAsNoLongerNeeded(mhash)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(1)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1197.25,-3253.47,7.09,true)
		if distance <= 2 then
			DrawMarker(21,1197.25,-3253.47,7.09-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,230,100,100,0,0,0,1)
			if distance <= 2 then
				drawTxt("PRESSIONE  ~r~E~w~ PARA O ~y~ESCOLHER O SERVIÇO",4,0.5,0.90,0.50,255,255,255,200)
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
	end
end)

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