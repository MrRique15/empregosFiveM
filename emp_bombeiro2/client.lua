local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
srv = Tunnel.getInterface("emp_bombeiros")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local coordX = 1194.85
local coordY = -1477.90             --  1194.85,-1477.90 ,34.86
local coordZ = 34.86
local cdpegar = vector3(1194.88, -1483.70, 34.86)
local cdguardar = vector3(1194.85, -1482.15, 34.86)
local targetDistance = 0
local carro = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregas = {
	[1] = { x = 1216.5947265625, y = -1388.1318359375, z = 35.576366424561 }, 
	[2] = { x = 1320.5482177734, y = -1635.4110107422, z = 52.362888336182 }, 
	[3] = { x = 936.92126464844, y = -2101.169921875, z = 30.594915390015 }, 
	[4] = { x = 786.89886474609, y = -2157.3605957031, z = 29.448778152466 }, 
	[5] = { x = 459.72009277344, y = -1918.1689453125, z = 25.056262969971 }, 
	[6] = { x = 222.06094360352, y = -1584.7188720703, z = 29.392402648926 },
	[7] = { x = 33.423694610596, y = -1355.087890625, z = 29.425909042358 }, 
	[8] = { x = -307.20028686523, y = -1445.2783203125, z = 31.381128311157 }, 
	[9] = { x = 90.106369018555, y = -1311.0561523438, z = 29.383085250854 }, 
	[10] = { x = -406.69439697266, y = -2148.2678222656, z = 10.416791915894 }, 
	[11] = { x = -540.42388916016, y = -1187.6147460938, z = 18.647346496582 }, 
	[12] = { x = -687.76196289063, y = -1204.1257324219, z = 10.851398468018 }, 
	[13] = { x = -795.94934082031, y = -1092.2755126953, z = 10.940272331238 }, 
	[14] = { x = -595.85443115234, y = -951.11846923828, z = 22.486166000366 }, 
	[15] = { x = -749.21258544922, y = -944.37036132813, z = 18.092863082886 }, 
	[16] = { x = -1186.9077148438, y = -1417.9423828125, z = 4.4611716270447 }, 
	[17] = { x = -1295.0880126953, y = -1143.337890625, z = 5.8465852737427 }, 
	[18] = { x = -1348.943359375, y = -675.6025390625, z = 25.832304000854 }, 
	[19] = { x = -1632.1756591797, y = -422.62222290039, z = 39.725025177002 }, 
	[20] = { x = -1487.0194091797, y = -138.30928039551, z = 51.849723815918 },
	[21] = { x = -1283.5036621094, y = -407.40957641602, z = 35.546264648438 }, 
	[22] = { x = -1000.6226806641, y = -445.23300170898, z = 37.435005187988 }, 
	[23] = { x = -700.68402099609, y = -82.89143371582, z = 38.047676086426 }, 
	[24] = { x = -302.23614501953, y = -323.44012451172, z = 30.508916854858 },
	[25] = { x = -439.90338134766, y = 231.89184570313, z = 83.171005249023 }, 
	[26] = { x = 226.91203308105, y = 202.92845153809, z = 105.52341461182 },
	[27] = { x = 272.69012451172, y = -357.12121582031, z = 45.01815032959 }, 
	[28] = { x = 266.23468017578, y = -613.62078857422, z = 42.624530792236 }, 
	[29] = { x = 208.54907226563, y = -617.26104736328, z = 41.623512268066 },
	[30] = { x = 132.58274841309, y = -993.90228271484, z = 29.430418014526 },
	[31] = { x = 100.4156036377, y = -972.06701660156, z = 29.440570831299 },
	[32] = { x = 84.428672790527, y = -1016.7864379883, z = 29.394428253174 },
	[33] = { x = 392.83764648438, y = -993.45324707031, z = 29.480604171753 },
	[34] = { x = -70.266777038574, y = -1093.4261474609, z = 26.615776062012 },
	[35] = { x = -76.542381286621, y = -633.37548828125, z = 36.402027130127 },
	[36] = { x = 390.01586914063, y = 244.55842590332, z = 103.12211608887 },
	[37] = { x = -75.486083984375, y = -1797.9716796875, z = 28.057426452637 },
	[38] = { x = 1168.8255615234, y = -490.64633178711, z = 65.518707275391 },
	[39] = { x = 941.55291748047, y = -134.92991638184, z = 74.932037353516 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if not emservico then
			distancia = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordX,coordY,coordZ,true)
			if distancia <= 15 then
				kswait = 4
				DrawMarker(23,coordX,coordY,coordZ - 0.98,0,0,0,0,0.0,130.0,1.0,1.0,0.5,255,0,0,55,0,1,0,0)
				if distancia <= 0.5 then
					drawTxt("PRESSIONE ~r~E~w~ PARA INICIAR A MANUTENÇÃO DE HIDRANTES", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
					if IsControlJustPressed(0,38) then
						if srv.checkPermission() then
							emservico = true
							initService()
							TriggerServerEvent("colocar-uniforme:bombeiro")
							destino = math.random(1, #entregas)
							TriggerEvent("Notify","sucesso","Você pegou a rota de manutenção de hidrantes.")
							targetDistance = CriandoBlip(entregas, destino)
							-- vRP.CarregarObjeto("amb@world_human_clipboard@male@base", "base", "p_amb_clipboard_01", 50, 60309)
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
				DrawMarker(21,entregas[destino].x,entregas[destino].y,entregas[destino].z+0.5,0,0,0,0,180.0,130.0,1.0,1.0,1.0,255,0,0,100,1,0,0,1)

				-- Entrega
				if distance < 1 and not IsPedInAnyVehicle(ped) then
					DrawText3Ds(entregas[destino].x,entregas[destino].y,entregas[destino].z, "PRESSIONE ~r~E~w~ REPARAR O HIDRANTE")
					if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(PlayerPedId()) then
						-- Pega o ped e suas coordenadas
						local ped = PlayerPedId()
						local pedCoords = GetEntityCoords(ped)

						-- Aponta o PED na direção do hidrante
						SetEntityHeading(ped, GetHeadingFromVector_2d(entregas[destino].x - pedCoords.x, entregas[destino].y - pedCoords.y))

						-- Salva destino atual, remove o blip e inicia o reparo
						destinoantigo = destino
						RemoveBlip(blip)
						TriggerServerEvent('emp_bombeiros:reparar', targetDistance)
						
						-- Barra de progresso
						TriggerEvent('reparando',true)
						TriggerEvent("progress",8000,"reparando")
						SetTimeout(8000,function()
							processo = false
							TriggerEvent('reparando',false)

							-- Cancela animação ao concluir o reparo
							ClearPedTasks(ped)
						end)

						-- Sortear próximo destino
						while true do
							-- Checa destino redundante e define novo destino
							if destinoantigo == destino then
							destino = math.random(1, #entregas)
							else
								break
							end
							Citizen.Wait(1)
						end

						-- Definir próximo destino
						targetDistance = CriandoBlip(entregas, destino)
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
			local pDistance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), cdpegar, true)
			local gDistance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), cdguardar, true)
				if pDistance <= 20 then
					kswait = 4
					DrawMarker(23, cdpegar.x, cdpegar.y, cdpegar.z - 0.98, 0, 0, 0, 0, 180.0, 130.0, 1.0, 1.0, 1.0, 255, 99, 71, 60, 0, 0, 0, 0)
					DrawMarker(23, cdguardar.x, cdguardar.y, cdguardar.z - 0.98, 0, 0, 0, 0, 180.0, 130.0, 1.0, 1.0, 1.0, 255, 99, 71, 60, 0, 0, 0, 0)
					if pDistance <= 0.5 then
						drawTxt("PRESSIONE ~r~E~w~ PARA PEGAR SEUS EQUIPAMENTOS", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
						if IsControlJustPressed(0,38) then
							if srv.checkPermission() then
								srv.getEquips()
							else
								TriggerEvent("Notify","negado","Você não possui permissão pegar os equipamentos aqui.")
							end
						end
					end
				end
			if gDistance <= 0.5 then
				kswait = 4
				drawTxt("PRESSIONE ~r~E~w~ PARA GUARDAR SEUS EQUIPAMENTOS", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
				if IsControlJustPressed(0,38) then
					if srv.checkPermission() then
						srv.clearEquips()
					else
						TriggerEvent("Notify","negado","Você não possui permissão guardar os equipamentos aqui.")
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
      local timeDistance = 1000
      if emservico then
		timeDistance = 5
		drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
        if IsControlJustPressed(0,168) then
            emservico = false
			RemoveBlip(blip)
			DeleteVehicle(carro)
            carro = nil
            srv.clearEquips()
			TriggerServerEvent("tirar-uniforme:bombeiro")
            TriggerEvent("Notify","negado","Você saiu de serviço.")
        end
      end
	  Citizen.Wait(timeDistance)
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

function initService(plycoords,ped)
    if not carro then
        while not HasModelLoaded("firetruk") do
            RequestModel("firetruk")
            Citizen.Wait(10)
        end
        carro = CreateVehicle("firetruk",1200.66,-1467.55,34.86,0.0,true,false)
        NetworkFadeInEntity(carro,true)
        SetVehicleIsStolen(carro,false)
        SetVehicleNumberPlateText(carro,vRP.getRegistrationNumber())
        SetVehicleOnGroundProperly(carro)
        SetVehicleHasBeenOwnedByPlayer(carro,true)
        SetEntityInvincible(carro,false)
        SetEntityAsMissionEntity(carro,true,true)
        SetVehicleDirtLevel(carro,0.0)
        SetModelAsNoLongerNeeded("firetruk")
    end
end
