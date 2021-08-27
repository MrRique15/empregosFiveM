local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("emp_bebidas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local Teleport = {
	["Bahamas"] = {
		positionFrom = { ['x'] = -1391.18, ['y'] = -597.87, ['z'] = 30.32, ['perm'] = "manager.permissao" },
		positionTo = { ['x'] = -1390.31, ['y'] = -600.21, ['z'] = 30.32, ['perm'] = "manager.permissao" }
	},

	["vanilla"] = {
		positionFrom = { ['x'] = 133.03, ['y'] = -1293.80, ['z'] = 29.27, ['perm'] = "manager.permissao" },
		positionTo = { ['x'] = 132.47, ['y'] = -1287.51, ['z'] = 29.27, ['perm'] = "manager.permissao" }
	}
}
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		for k,v in pairs(Teleport) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.positionFrom.x,v.positionFrom.y,v.positionFrom.z)
			local distance = GetDistanceBetweenCoords(v.positionFrom.x,v.positionFrom.y,cdz,x,y,z,true)
			local bowz,cdz2 = GetGroundZFor_3dCoord(v.positionTo.x,v.positionTo.y,v.positionTo.z)
			local distance2 = GetDistanceBetweenCoords(v.positionTo.x,v.positionTo.y,cdz2,x,y,z,true)

			if distance <= 10 then
				kswait = 4
				DrawMarker(23, v.positionFrom.x,v.positionFrom.y,v.positionFrom.z - 0.98,0,0,0,0,0.0,130.0,1.0,1.0,0.5,255,255,255,50,0,1,0,0)
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) and func.checkPermission(v.positionTo.perm) then
						SetEntityCoords(PlayerPedId(),v.positionTo.x,v.positionTo.y,v.positionTo.z-0.50)
					end
				end
			end

			if distance2 <= 10 then
				kswait = 4
				DrawMarker(23,v.positionTo.x,v.positionTo.y,v.positionTo.z - 0.98,0,0,0,0,0,0,1.0,1.0,1.0,255,255,255,50,0,0,0,0)
				if distance2 <= 1.2 then
					if IsControlJustPressed(0,38) and func.checkPermission(v.positionFrom.perm) then
						SetEntityCoords(PlayerPedId(),v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.50)
					end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local emservico = false
local permissao = false
local produto = false
local targetDistance = 0
local entregas = {
	[1] = { x = 132.25004577637, y = -1462.0676269531, z = 29.357034683228 },
	[2] = { x = 176.77886962891, y = -1438.1135253906, z = 29.241640090942 },
	[3] = { x = 980.28009033203, y = -1397.1497802734, z = 31.685367584229 },
	[4] = { x = 1199.4670410156, y = -501.80770874023, z = 65.18009185791 },
	[5] = { x = 1241.4829101563, y = -366.85955810547, z = 69.08219909668 },
	[6] = { x = 927.24975585938, y = 44.975994110107, z = 80.899871826172 },
	[7] = { x = 538.43988037109, y = 101.37275695801, z = 96.523872375488 },
	[8] = { x = 219.87796020508, y = 304.89468383789, z = 105.58235168457 },
	[9] = { x = 224.53616333008, y = 336.22912597656, z = 105.68883514404 },
	[10] = { x = 78.843894958496, y = 289.22882080078, z = 110.21019744873 },
	[11] = { x = -40.898422241211, y = 227.95634460449, z = 107.96778869629 },
	[12] = { x = -242.08255004883, y = 279.72793579102, z = 92.039520263672 },
	[13] = { x = -362.01391601563, y = 277.99996948242, z = 86.421905517578 },
	[14] = { x = -627.91986083984, y = 239.03355407715, z = 81.89282989502 },
	[15] = { x = -2299.337890625, y = 336.72076416016, z = 174.60159301758 },
	[16] = { x = -1273.9298095703, y = 316.04525756836, z = 65.511779785156 },
	[17] = { x = -1366.02734375, y = 56.603065490723, z = 54.098495483398 },
	[18] = { x = -1471.6677246094, y = -330.82223510742, z = 44.816104888916 },
	[19] = { x = -1539.3118896484, y = -606.72436523438, z = 31.298673629761 },
	[20] = { x = -1858.9436035156, y = -346.13800048828, z = 49.837749481201 },
	[21] = { x = -2194.193359375, y = -388.35177612305, z = 13.470425605774 },
	[22] = { x = -1592.3852539063, y = -1005.3702392578, z = 13.021019935608 },
	[23] = { x = -1037.7095947266, y = -1397.2241210938, z = 5.5531711578369 },
	[24] = { x = -1183.69921875, y = -884.28424072266, z = 13.79988193512 },
	[25] = { x = -657.64471435547, y = -679.06524658203, z = 31.475275039673 },
	[26] = { x = -819.3818359375, y = 267.83065795898, z = 86.394622802734 },
	[27] = { x = -519.953125, y = -677.83520507813, z = 33.671138763428 },
	[28] = { x = 386.27560424805, y = -325.21160888672, z = 46.865547180176 },
	[29] = { x = 375.74600219727, y = -335.76095581055, z = 48.161388397217 },
	[30] = { x = 43.940990447998, y = -998.39642333984, z = 29.335536956787 },
	[31] = { x = 273.60064697266, y = -832.86315917969, z = 29.410961151123 },
	[32] = { x = 793.87915039063, y = -735.56207275391, z = 27.962997436523 },
	[33] = { x = 445.84140014648, y = -1241.6580810547, z = 30.277307510376 },
	[34] = { x = 493.79800415039, y = -1541.513671875, z = 29.287794113159 },
	[35] = { x = 410.45541381836, y = -1910.7429199219, z = 25.453128814697 },
	[36] = { x = 125.8801574707, y = -1537.6137695313, z = 29.171922683716 },
	[37] = { x = 169.52180480957, y = -1634.0166015625, z = 29.291667938232 },
	[38] = { x = -509.50421142578, y = -23.100587844849, z = 45.608951568604 },
	[39] = { x = 1401.3969726563, y = 1127.7244873047, z = 114.33447265625 },
	[40] = { x = 1015.3650512695, y = 144.00903320313, z = 80.990440368652 },
	[41] = { x = 287.57498168945, y = -963.95776367188, z = 29.418626785278 },
	[42] = { x = 2580.9682617188, y = 464.93685913086, z = 108.62738800049 },
	[43] = { x = -60.879703521729, y = 360.4255065918, z = 113.0563659668 },
	[44] = { x = 170.03045654297, y = -567.61730957031, z = 43.872875213623 },
	[45] = { x = -1311.8201904297, y = -1336.9522705078, z = 4.6349229812622 },
	[46] = { x = -1819.7301025391, y = -1187.5340576172, z = 14.304765701294 },
	[47] = { x = -3024.4165039063, y = 80.152709960938, z = 11.608117103577 },
	[48] = { x = 301.39227294922, y = 203.02040100098, z = 104.39264678955 },
	[49] = { x = 1139.0966796875, y = -962.67230224609, z = 47.528652191162 },
	[50] = { x = 871.48071289063, y = -2100.4543457031, z = 30.476907730103 }
}
local locs = {
	{ x = -568.50, y = 291.64, z = 79.17, perm = 'tequilala.permissao', item = 'coqueteltequilala' }, -- Tequi-La-La
	{ x = -1386.79, y = -589.57, z = 30.32, perm = 'bahamas.permissao', item = 'coquetelbahamas' },
	{ x = 92.73, y = -1291.88, z = 29.27, perm = 'vanilla.permissao', item = 'coquetelvanilla' }
}
local items = {
	{ ['tipo'] = 0, ['x'] = 2443.40, ['y'] = 4672.25, ['z'] = 33.33, ['text'] = "LARANJA", ['item'] = "laranja", ['perm'] = "bahamas.permissao" },
	{ ['tipo'] = 0, ['x'] = 2122.15, ['y'] = 4861.72, ['z'] = 41.10, ['text'] = "LIMÃO", ['item'] = "limao", ['perm'] = "tequilala.permissao" },
	{ ['tipo'] = 0, ['x'] = 1900.36, ['y'] = 4979.10, ['z'] = 49.20, ['text'] = "MORANGO", ['item'] = "morango", ['perm'] = "vanilla.permissao" },

	{ ['tipo'] = 1, ['x'] = 129.58, ['y'] = -1284.22, ['z'] = 29.27, ['text'] = "COQUETEL VANILLA", ['item'] = "coquetelvanilla", ['perm'] = "vanilla.permissao" },
	{ ['tipo'] = 1, ['x'] = -1392.011, ['y'] = -602.028, ['z'] = 30.319, ['text'] = "COQUETEL BAHAMAS", ['item'] = "coquetelbahamas", ['perm'] = "bahamas.permissao" },
	{ ['tipo'] = 1, ['x'] = -561.629, ['y'] = 288.012, ['z'] = 82.176, ['text'] = "COQUETEL TEQUILALA", ['item'] = "coqueteltequilala", ['perm'] = "tequilala.permissao" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMANDO DRINKS 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		for k,v in pairs(items) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 50.0 and not processo then
				kswait = 4
				DrawMarker(1,v.x,v.y,v.z-1,0,0,0,0,0,0,1.0,1.0,0.5,255,105,180,50,0,0,0,0)
				if distance <= 1.2 and not processo then
					drawTxt("PRESSIONE  ~p~E~w~  PARA PRODUZIR "..v.text,4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and func.checkPermission(v.perm) then
						if v.tipo == 0 then
							local pedCoords = GetEntityCoords(ped)
							SetEntityHeading(ped, GetHeadingFromVector_2d(v.x - pedCoords.x, v.y - pedCoords.y))
							if func.colher(v.item) then
								processo = true
								TriggerEvent('cancelando',true)
								TriggerEvent("progress",5000,"colhendo")
								SetTimeout(5000,function()
									processo = false
									TriggerEvent('cancelando',false)
								end)
							end
						else
							if func.processar(v.item) then
								processo = true
								TriggerEvent('cancelando',true)
								TriggerEvent("progress",10000,"produzindo")
								SetTimeout(10000,function()
									processo = false
									TriggerEvent('cancelando',false)
								end)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(kswait)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local kswait = 1000
		if not emservico then
			for k,v in pairs(locs) do
				distancia = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true)
				if distancia <= 10 then
					kswait = 4
					DrawMarker(23, v.x, v.y, v.z - 0.98,0,0,0,0,0.0,130.0,1.0,1.0,0.5,255,105,180,55,0,1,0,0)
					if distancia <= 0.5 then
						drawTxt("PRESSIONE ~p~E~w~ PARA INICIAR A ENTREGA DE COQUETÉIS", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
						if IsControlJustPressed(0,38) then
							if func.checkPermission(v.perm) then
								permissao = v.perm
								produto = v.item
								emservico = true
								destino = math.random(1, #entregas)
								TriggerServerEvent("colocar-uniforme:bebidas")
								TriggerEvent("Notify","sucesso","Você pegou a rota de entrega de coquetéis.")
								targetDistance = CriandoBlip(entregas, destino)
							else
								TriggerEvent("Notify","negado","Você não possui permissão para este serviço.")
							end
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
					DrawText3Ds(entregas[destino].x,entregas[destino].y,entregas[destino].z, "PRESSIONE ~r~E~w~ ENTREGAR OS COQUETÉIS")
					if IsControlJustPressed(0,38) then
						-- Tenta entregar
						if func.entregar(targetDistance, produto) then
							TriggerEvent("Notify","sucesso","Entregou.")
							-- Salva destino atual, remove o blip e inicia o reparo
							destinoantigo = destino
							RemoveBlip(blip)
							TriggerServerEvent('emp_bebidas:reparar', targetDistance)

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
		end
		Citizen.Wait(kswait)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
      local timeDistance = 500
      if emservico then
		timeDistance = 5
		drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
        if IsControlJustPressed(0,168) then
            emservico = false
            RemoveBlip(blip)
            TriggerServerEvent("tirar-uniforme:bebidas")
            TriggerEvent("Notify","negado","Você saiu de serviço.")
        end
      end
	  Citizen.Wait(timeDistance)
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
	AddTextComponentString("Entrega de Bebidas")
	EndTextCommandSetBlipName(blip)

	-- Calcular distância da rota
	posicaoAtual = GetEntityCoords(PlayerPedId())
	targetDistance = math.ceil(CalculateTravelDistanceBetweenPoints(posicaoAtual,entregas[destino].x,entregas[destino].y,entregas[destino].z,true))
	return targetDistance
end