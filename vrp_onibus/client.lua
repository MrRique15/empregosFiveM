-- vRP TUNNEL/PROXY
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- RESOURCE TUNNEL/PROXY
vRPon = {}
Tunnel.bindInterface("vrp_onibus",vRPon)
Proxy.addInterface("vrp_onibus",vRPon)
ONserver = Tunnel.getInterface("vrp_onibus")

cfg = module("vrp_onibus", "cfg/config")

local inJob = false
local blip = nil
local descendo = 500
local finish = true

RegisterNetEvent('start:busjob')
AddEventHandler("start:busjob", function()
	vRP.notify("~g~Trabalho iniciado.~w~ Dirija até os pontos.")
	inJob = true
	local ponto = 1
	local rota = math.random(1,#cfg.rotas)
    while inJob do
		Wait(5)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if veh ~= 0 then
			v = cfg.rotas[rota]
				if v.pontos[ponto] then
					if (blip == nil)then
						blip = AddBlipForCoord(v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3])
						SetBlipRoute(blip, true)
					end
					local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3], Citizen.PointerValueInt(), Citizen.PointerValueInt() )
					local street1 = GetStreetNameFromHashKey(s1)
					drawTxt("~y~Próxima parada: ~w~"..street1,4,2,0.25,0.95,0.5,255,255,255,255)
					DrawMarker(20, v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3], 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 132, 252, 255,255, 0, 0, 0,0)
					if(Vdist(pos.x, pos.y, pos.z, v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3]) < 10.0)then
						if IsVehicleStopped(veh) then
							descendo = 500
							finish = true
							SetVehicleDoorOpen(veh,0,0,0)
							SetVehicleDoorOpen(veh,1,0,0)
							SetVehicleDoorOpen(veh,2,0,0)
							SetVehicleDoorOpen(veh,3,0,0)
							SetVehicleIndicatorLights(veh, 0, true)
							SetVehicleIndicatorLights(veh, 1, true)
							while descendo > 0 do
								Wait(1)
								descendo = descendo - math.random(1,2)
								DrawText3D(v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3], "~r~Aguarde "..math.floor((descendo+100)/100).." segundos",255,255,255)
								DrawMarker(20, v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3], 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 132, 252, 255,255, 0, 0, 0,0)
								if not IsVehicleStopped(veh) then
									descendo = 0
									finish = false
								end
							end
							SetVehicleDoorsShut(veh,false)
							SetVehicleIndicatorLights(veh, 0, false)
							SetVehicleIndicatorLights(veh, 1, false)
							if finish then
								ponto = ponto + 1
								RemoveBlip(blip)
								blip = nil
							end
						else
							DrawText3D(v.pontos[ponto][1], v.pontos[ponto][2], v.pontos[ponto][3], "Pare o ~y~veículo ~w~ para os passageiros descerem",255,255,255)
						end
					end
				else
					inJob = false
					ONserver.finishJob(#v.pontos)
					RemoveBlip(blip)
					blip = nil
				end
		else
			inJob = false
			vRP.notify("~r~Você cancelou o serviço.")
			RemoveBlip(blip)
			blip = nil
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		local timeDistance = 500
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if veh then
			local model = GetEntityModel(veh)
			for k, v in pairs(cfg.onibus) do
				if GetHashKey(v) == model and not inJob then
					timeDistance = 5
					drawTxt("Pressione ~y~[E]~w~ para iniciar uma rota com este onibus",4,1,0.5,0.87,0.5,255,255,255,255)
					if IsControlJustPressed(1, 51) then
						TriggerServerEvent("start:busjob")
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.00*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end