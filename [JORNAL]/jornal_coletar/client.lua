local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
srv = Tunnel.getInterface("jornal_coletar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
-- Variáveis da compra
local comprando = false
local PosCompraX = -175.01
local PosCompraY = -1273.22
local PosCompraZ = 32.6
local seller = false

-- Variáveis do processo
local processo = false
local PosProcessoX = -577.57
local PosProcessoY = -938.2
local PosProcessoZ = 23.88

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPRA DOS CARTUCHOS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if not comprando then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(PosCompraX,PosCompraY,PosCompraZ)
			local distance = GetDistanceBetweenCoords(PosCompraX,PosCompraY,cdz,x,y,z,true)
			if distance <= 30.0 then
				kswait = 4
				DrawMarker(23,PosCompraX,PosCompraY,PosCompraZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,217,217,25,50,0,0,0,0)
				if distance <= 1.2 and not comprando then
					drawTxt("PRESSIONE ~b~E~w~ PARA COMPRAR", 4, 0.5, 0.80, 0.70, 255, 255, 255, 180)
					drawTxt("~b~CUSTO: $50 POR CARTUCHO DE IMPRESSORA", 4, 0.5, 0.85, 0.50, 255, 255, 255, 180)
					if IsControlJustPressed(0,38) then
						if srv.checkPermission() then
							if srv.comprarCartucho() then
								print('teste')
								comprando = true
								TriggerEvent('cancelando',true)
								TriggerEvent("progress",2000,"comprando")
								SetTimeout(2000,function()
									comprando = false
									TriggerEvent('cancelando',false)
								end)
							end
						else
							TriggerEvent("Notify","negado","Você não possui permissão para comprar cartucho.")
						end
					end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPRESSÃO DOS JORNAIS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if not processo then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(PosProcessoX,PosProcessoY,PosProcessoZ)
			local distance = GetDistanceBetweenCoords(PosProcessoX,PosProcessoY,cdz,x,y,z,true)
			if distance <= 30.0 then
				kswait = 4
				DrawMarker(23,PosProcessoX,PosProcessoY,PosProcessoZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,0,0,50,0,0,0,0)
				if distance <= 1.2 and not processo then
					drawTxt("PRESSIONE  ~r~E~w~  PARA IMPRIMIR JORNAIS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						if srv.checkPermission() then
							if srv.imprimirJornais() then
								processo = true
								TriggerEvent('cancelando',true)
								TriggerEvent("progress", 10000, "imprimindo jornais")
								SetTimeout(10000,function()
									processo = false
									TriggerEvent('cancelando',false)
									TriggerEvent("Notify","sucesso","10 jornais impressos.")
								end)
							end
						else
							TriggerEvent("Notify","negado","Você não possui permissão para este serviço.")
						end
					end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEFINE EXTRAS AO ENTRAR NA RUMPO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			kswait = 4
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped)
			if IsVehicleModel(vehicle,GetHashKey("rumpo")) then
				if GetVehicleLivery(vehicle) ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
					if srv.checkPermission() then
						SetVehicleLivery(vehicle,0)
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