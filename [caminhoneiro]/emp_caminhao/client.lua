local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_caminhao")

vSERVER = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local random = 0
local modules = ""
local servico = false
local servehicle = nil
local CoordenadaX = 1159.38
local CoordenadaY = -3273.07
local CoordenadaZ = 5.90
local CoordenadaX2 = 0.0
local CoordenadaY2 = 0.0
local CoordenadaZ2 = 0.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIESEL
-----------------------------------------------------------------------------------------------------------------------------------------
local diesel = {
	[1] = { ['x'] = 43.06, ['y'] = 2803.80, ['z'] = 57.87 }, -- 7.59km
	[2] = { ['x'] = 243.15, ['y'] = 2602.41, ['z'] = 45.11 }, --7.27km
	[3] = { ['x'] = 1059.15, ['y'] = 2660.69, ['z'] = 39.55 }, -- 7.25km
	[4] = { ['x'] = 1990.22, ['y'] = 3763.54, ['z'] = 32.18 }, -- 8.34km
	[5] = { ['x'] = 81.23, ['y'] = 6334.27, ['z'] = 31.22 }, --13.10km
	[6] = { ['x'] = 2770.81, ['y'] = 1439.26, ['z'] = 24.51 } --6.96km
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAS
-----------------------------------------------------------------------------------------------------------------------------------------
local gas = {
	[1] = { ['x'] = -2530.05, ['y'] = 2325.91, ['z'] = 33.05 }, --9.17km
	[2] = { ['x'] = -2082.05, ['y'] = -319.80, ['z'] = 13.05 }, --5.77km
	[3] = { ['x'] = -1413.47, ['y'] = -279.95, ['z'] = 46.33 }, -- 4.94km
	[4] = { ['x'] = 280.64, ['y'] = -1259.95, ['z'] = 29.21 }, --3.00KM
	[5] = { ['x'] = 1208.38, ['y'] = -1402.58, ['z'] = 35.22 }, --2.83km
	[6] = { ['x'] = 1181.46, ['y'] = -334.74, ['z'] = 69.17 }, --3.80km
	[7] = { ['x'] = 2567.72, ['y'] = 362.65, ['z'] = 108.45 }, --5.11km
	[8] = { ['x'] = 183.97, ['y'] = -1554.69, ['z'] = 29.20 }, --2.73km
	[9] = { ['x'] = -331.75, ['y'] = -1479.03, ['z'] = 30.54 }, --3.15km
	[10] = { ['x'] = 2534.50, ['y'] = 2588.13, ['z'] = 37.94 }, --7.53km
	[11] = { ['x'] = 2684.40, ['y'] = 3261.81, ['z'] = 55.24 }, --7.83km
	[12] = { ['x'] = -1803.10, ['y'] = 800.33, ['z'] = 138.51 } --6.25km
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARS
-----------------------------------------------------------------------------------------------------------------------------------------
local cars = {
	[1] = { ['x'] = -774.19, ['y'] = -254.45, ['z'] = 37.10 }, -- 4.57km
	[2] = { ['x'] = -231.64, ['y'] = -1170.94, ['z'] = 22.83 }, --3.40km
	[3] = { ['x'] = 925.59, ['y'] = -8.79, ['z'] = 78.76 }, --4.15km
	[4] = { ['x'] = -506.18, ['y'] = -2191.37, ['z'] = 6.53 }, --3.58km
	[5] = { ['x'] = 1209.15, ['y'] = 2712.03, ['z'] = 38.00 }, -- 7.12km
	[6] = { ['x'] = -72.97, ['y'] = -1090.45, ['z'] = 25.95 } --3.35km
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WOODS
-----------------------------------------------------------------------------------------------------------------------------------------
local woods = {
	[1] = { ['x'] = -581.20, ['y'] = 5317.28, ['z'] = 70.24 }, -- 11.11km
	[2] = { ['x'] = 2701.74, ['y'] = 3450.62, ['z'] = 55.79 }, -- 8.08km
	[3] = { ['x'] = 1203.52, ['y'] = -1309.33, ['z'] = 35.22 }, -- 2.90km
	[4] = { ['x'] = 16.99, ['y'] = -386.11, ['z'] = 39.32 } -- 4.09km
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWS
-----------------------------------------------------------------------------------------------------------------------------------------
local show = {
	[1] = { ['x'] = 1994.91, ['y'] = 3061.17, ['z'] = 47.04 }, -- 8km
	[2] = { ['x'] = -1397.32, ['y'] = -581.99, ['z'] = 30.28 }, -- 4.70km
	[3] = { ['x'] = -552.43, ['y'] = 303.34, ['z'] = 83.21 }, -- 5.76km
	[4] = { ['x'] = -227.52, ['y'] = -2051.27, ['z'] = 27.62 } -- 2.76km
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- /PACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pack",function(source,args)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
	local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

	if distance <= 50.1 and not servico then
		if args[1] == "diesel" then
			servico = true
			modules = args[1]
			servehicle = -1207431159
			random = emP.getTruckpoint(modules)
			CoordenadaX2 = diesel[random].x
			CoordenadaY2 = diesel[random].y
			CoordenadaZ2 = diesel[random].z
			CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			TriggerEvent("Notify","importante","Entrega de <b>Diesel</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
		elseif args[1] == "gas" then
			servico = true
			modules = args[1]
			servehicle = 1956216962
			random = emP.getTruckpoint(modules)
			CoordenadaX2 = gas[random].x
			CoordenadaY2 = gas[random].y
			CoordenadaZ2 = gas[random].z
			CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			TriggerEvent("Notify","importante","Entrega de <b>Combustível</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
		elseif args[1] == "cars" then
			servico = true
			modules = args[1]
			servehicle = 2091594960
			random = emP.getTruckpoint(modules)
			CoordenadaX2 = cars[random].x
			CoordenadaY2 = cars[random].y
			CoordenadaZ2 = cars[random].z
			CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			TriggerEvent("Notify","importante","Entrega de <b>Veículos</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
		elseif args[1] == "woods" then
			servico = true
			modules = args[1]
			servehicle = 2016027501
			random = emP.getTruckpoint(modules)
			CoordenadaX2 = woods[random].x
			CoordenadaY2 = woods[random].y
			CoordenadaZ2 = woods[random].z
			CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			TriggerEvent("Notify","importante","Entrega de <b>Madeiras</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
		elseif args[1] == "show" then
			servico = true
			modules = args[1]
			servehicle = -1770643266
			random = emP.getTruckpoint(modules)
			CoordenadaX2 = show[random].x
			CoordenadaY2 = show[random].y
			CoordenadaZ2 = show[random].z
			CriandoBlip(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			TriggerEvent("Notify","importante","Entrega de <b>Shows</b> iniciada, pegue o caminhão, a carga e vá até o destino marcado.")
		else
			TriggerEvent("Notify","aviso","<b>Disponíveis:</b> diesel, cars, show, woods e gas")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX2,CoordenadaY2,CoordenadaZ2)
			local distance = GetDistanceBetweenCoords(CoordenadaX2,CoordenadaY2,cdz,x,y,z,true)
			if distance <= 100.0 then
				kswait = 4
				DrawMarker(39,CoordenadaX2,CoordenadaY2,CoordenadaZ2-0.80,0,0,0,0.0,0,0,0.5,0.5,0.4,0,0,255,100,1,0,0,1)
				if distance <= 5.9 then
					if IsControlJustPressed(0,38) then
						local vehicle = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
						if GetEntityModel(vehicle) == servehicle then
							emP.checkPayment(random,modules,parseInt(GetVehicleBodyHealth(GetPlayersLastVehicle())))
							vSERVER.deleteVehicles(vehicle)
							RemoveBlip(blips)
							servico = false
						end
					end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function getVehicleInDirection(coordsfrom,coordsto)
	local handle = CastRayPointToPoint(coordsfrom.x,coordsfrom.y,coordsfrom.z,coordsto.x,coordsto.y,coordsto.z,10,PlayerPedId(),false)
	local a,b,c,d,vehicle = GetRaycastResult(handle)
	return vehicle
end

function CriandoBlip(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Carga")
	EndTextCommandSetBlipName(blips)
end