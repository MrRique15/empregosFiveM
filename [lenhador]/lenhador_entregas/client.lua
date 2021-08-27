local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("lenhador_entregas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = 1218.51
local CoordenadaY = -1266.94
local CoordenadaZ = 36.42
local quantidade = 0
local carro = nil
local iniciarCoords = {x = 1211.53, y = -1262.47, z = 35.23}
-- 1218.74, -1266.87, 36.42
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 1408.65, ['y'] = -734.98, ['z'] = 67.69 },
	[2] = { ['x'] = -1129.48, ['y'] = -953.32, ['z'] = 6.63 },
	[3] = { ['x'] = 1561.41, ['y'] = -1693.56, ['z'] = 89.21 },
	[4] = { ['x'] = 557.64, ['y'] = -2328.00, ['z'] = 5.82 },
	[5] = { ['x'] = -1097.71, ['y'] = -1649.72, ['z'] = 4.39 },
	[6] = { ['x'] = -2016.37, ['y'] = 559.32, ['z'] = 108.30 },
	[7] = { ['x'] = -663.58, ['y'] = 222.33, ['z'] = 81.95 },
	[8] = { ['x'] = 141.28, ['y'] = -379.58, ['z'] = 43.25 },
	[9] = { ['x'] = 23.99, ['y'] = -619.81, ['z'] = 35.34 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 5 then
				timeDistance = 5
				DrawMarker(21,CoordenadaX,CoordenadaY,CoordenadaZ-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,230,100,100,0,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~PEGAR A ROTA",4,0.5,0.90,0.50,255,255,255,200)
					if IsControlJustPressed(0,38) then
						servico = true
						selecionado = math.random(9)
						CriandoBlip(locs,selecionado)
						emP.Quantidade()
						if not carro then
							criaCarro()
						end
						TriggerEvent("Notify","sucesso","Você entrou em serviço.")
						TriggerServerEvent("colocar-uniforme:madeira")
						TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Toras de Madeira</b>.")
					end
				end
			end
		elseif servico then
			timeDistance = 5
			drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
			if IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blips)
				guardarCarro()
				TriggerServerEvent("tirar-uniforme:madeira")
				TriggerEvent("Notify","negado","Você saiu de serviço.")
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if servico then
			timeDistance = 5
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)
			local vehicle = GetPlayersLastVehicle()
			if distance <= 5 and GetEntityModel(vehicle) == -667151410 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,230,100,100,0,0,0,1)
				if distance <= 2.2 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR AS ~y~TORAS DE MADEIRA",4,0.5,0.90,0.50,255,255,255,200)
					if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
						if emP.checkPayment() then
							RemoveBlip(blips)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(9)
								else
									break
								end
								Citizen.Wait(1)
							end
							CriandoBlip(locs,selecionado)
							TriggerEvent("Notify","importante","Vá até o próximo local e entregue <b>"..quantidade.."x Toras de Madeira</b>.")
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		
		Citizen.Wait(timeDistance)
	end
end)

RegisterNetEvent("quantidade-tora")
AddEventHandler("quantidade-tora",function(status)
    quantidade = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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

function criaCarro()
	if not carro then
		while not HasModelLoaded("ratloader") do
			RequestModel("ratloader")
			Citizen.Wait(10)
		end
		carro = CreateVehicle("ratloader",iniciarCoords.x,iniciarCoords.y,iniciarCoords.z,170.0,true,false)
		NetworkFadeInEntity(carro,true)
		SetVehicleIsStolen(carro,false)
		SetVehicleNumberPlateText(carro,vRP.getRegistrationNumber())
		SetVehicleOnGroundProperly(carro)
		SetVehicleHasBeenOwnedByPlayer(carro,true)
		SetEntityInvincible(carro,false)
		SetEntityAsMissionEntity(carro,true,true)
		SetVehicleDirtLevel(carro,0.0)
		SetModelAsNoLongerNeeded("ratloader")
	end
end

function guardarCarro()
	TriggerServerEvent("trydeleteveh",VehToNet(carro))
    carro = nil
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Madeira")
	EndTextCommandSetBlipName(blips)
end