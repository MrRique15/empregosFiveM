local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
srv = Tunnel.getInterface("jornal_entregas")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local coordX = -589.29
local coordY = -935.85
local coordZ = 23.88
local segurandoJornal = false
local targetDistance = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregas = {
	[1] = { x = 256.62, y = -2023.69, z = 19.27 }, 
	[2] = { x = 427.55, y = -1841.83, z = 28.47 }, 
	[3] = { x = 489.68, y = -1714.02, z = 29.71 }, 
	[4] = { x = 222.89, y = -1702.78, z = 29.7 }, 
	[5] = { x = 46.17, y = -1864.26, z = 23.28 }, 
	[6] = { x = -31.96, y = -1846.16, z = 26.19 },
	[7] = { x = 1272.43, y = -705.38, z = 64.73 }, 
	[8] = { x = 1371.16, y = -562.33, z = 74.34 }, 
	[9] = { x = 962.16, y = -657.41, z = 57.46 }, 
	[10] = { x = 908.19, y = -497.38, z = 58.46 }, 
	[11] = { x = 1032.47, y = -416.13, z = 65.95 }, 
	[12] = { x = -995.19, y = -967.02, z = 2.55 }, 
	[13] = { x = -869.46, y = -1103.64, z = 6.45 }, 
	[14] = { x = -1010.87, y = -1224.75, z = 5.82 }, 
	[15] = { x = -1159.04, y = -1100.61, z = 6.54 }, 
	[16] = { x = -1108.71, y = -1527.61, z = 6.78 }, 
	[17] = { x = -1097.81, y = -1673.3, z = 8.4 }, 
	[18] = { x = -1753.15, y = -724.14, z = 10.42 }, 
	[19] = { x = -1980.12, y = -520.47, z = 14.75 }, 
	[20] = { x = -1963.33, y = 622.74, z = 121.47 },
	[21] = { x = -1921.1, y = 187.4, z = 84.1 }, 
	[22] = { x = -1296.18, y = 628.44, z = 137.85 }, 
	[23] = { x = -745.05, y = 813.81, z = 213.34 }, 
	[24] = { x = -353.77, y = 664.59, z = 169.0 },
	[25] = { x = 327.96, y = 503.28, z = 152.05 }, 
	[26] = { x = 1280.1, y = -1588.4, z = 51.98 },
	[27] = { x = 1276.89, y = -1629.5, z = 54.54 }, 
	[28] = { x = 1411.49, y = -1490.8, z = 60.66 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if not emservico then 
			distancia = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordX,coordY,coordZ,true)
			if distancia <= 10 then
				kswait = 4
				DrawMarker(23,coordX,coordY,coordZ - 1,0,0,0,0,0.0,130.0,1.0,1.0,0.5,255,25,25,55,0,1,0,0)
				if distancia <= 1 then
					drawTxt("PRESSIONE ~r~E~w~ PARA INICIAR A ENTREGA DE JORNAIS", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
					if IsControlJustPressed(0,38) then
						if srv.checkPermission() then
							emservico = true
							vRP.CarregarObjeto("amb@world_human_clipboard@male@base", "base", "p_amb_clipboard_01", 50, 60309)
							destino = math.random(1, #entregas)
							TriggerEvent("Notify","sucesso","Você pegou a rota de entrega de jornais.<br>Entregue no endereço marcado no mapa.")
							targetDistance = CriandoBlip(entregas, destino)
						else
							TriggerEvent("Notify","negado","Você não possui permissão para este serviço.")
						end
					end
				end
			end
		else
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),entregas[destino].x,entregas[destino].y,entregas[destino].z,true)
			if distance <= 50 then
				kswait = 4
				DrawMarker(21,entregas[destino].x,entregas[destino].y,entregas[destino].z+0.10,0,0,0,0,180.0,130.0,1.0,1.0,1.0,211,176,72,100,1,0,0,1)
				-- Pegar o jornal na mão
				if not segurandoJornal then
					vRP.CarregarObjeto("","","ng_proc_paper_news_meteor", 50, 0xFA70, 0.10, 0, 0.0, 30.0)
					segurandoJornal = true
				end

				-- Entrega do jornal
				if distance < 3 then
					DrawText3Ds(entregas[destino].x,entregas[destino].y,entregas[destino].z, "PRESSIONE ~r~E~w~ ENTREGAR O JORNAL")
					if IsControlJustPressed(0,38) then
						-- Deixar o jornal no chão
						obj = CreateObject(GetHashKey("ng_proc_paper_news_meteor"), entregas[destino].x+0.5,entregas[destino].y,entregas[destino].z, true, true, true)
						PlaceObjectOnGroundProperly(obj)
						SetEntityRotation(obj, 0.00, 0.00, 360.00)

						-- Definir próximo destino
						destinoantigo = destino
						RemoveBlip(blip)
						TriggerServerEvent('jornal_entregas:itensReceber', targetDistance)

						-- Sortear próximo destino
						while true do
							if destinoantigo == destino then
							destino = math.random(1, #entregas)
							else
									break
							end
							Citizen.Wait(1)
						end

						-- Definir próximo destino
						targetDistance = CriandoBlip(entregas, destino)

						segurandoJornal = false
					end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if emservico then
			kswait = 4
			if IsControlJustPressed(0,168) then
				emservico = false
				RemoveBlip(blip)
			end
		end
		Citizen.Wait(kswait)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
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

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function CriandoBlip(entregas,destino)
	-- Adicionar blip destino
	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Jornais")
	EndTextCommandSetBlipName(blip)

	-- Calcular distância da rota
	posicaoAtual = GetEntityCoords(PlayerPedId())
	targetDistance = math.ceil(CalculateTravelDistanceBetweenPoints(posicaoAtual,entregas[destino].x,entregas[destino].y,entregas[destino].z,true))
	return targetDistance
end
