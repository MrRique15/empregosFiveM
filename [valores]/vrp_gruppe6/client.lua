local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
job = Tunnel.getInterface("vrp_gruppe6")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local blip = nil
local quantidade = 0
local statuses = false
local nveh = nil
local pegando = false
local entregando = false
local retirando = false
local andamento = false
local traseira = false
local portaaberta = false
local portaaberta2 = false
local propcaixa = nil
local propcaixa2 = nil
local propcaixa3 = nil
local propcaixa4 = nil
local propcaixa5 = nil
local propcaixa6 = nil
local propcaixa7 = nil
local propcaixa8 = nil
local propcaixa9 = nil
local propcaixa10 = nil
local propcaixa11 = nil
local propcaixa12 = nil
local propcaixa13 = nil
local propcaixa14 = nil
local propcaixa15 = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregalocal = {
	[1] = { ['id'] = 1, ['x'] = 119.10, ['y'] = -883.70, ['z'] = 31.12 },
	[2] = { ['id'] = 2, ['x'] = -1315.80, ['y'] = -834.76, ['z'] = 16.96 },
	[3] = { ['id'] = 3, ['x'] = 285.44, ['y'] = 143.38, ['z'] = 104.17 },
	[4] = { ['id'] = 4, ['x'] = 1138.23, ['y'] = -468.89, ['z'] = 66.73 },
	[5] = { ['id'] = 5, ['x'] = 1077.70, ['y'] = -776.54, ['z'] = 58.24 },
	[6] = { ['id'] = 6, ['x'] = -710.03, ['y'] = -818.90, ['z'] = 23.72 },
	[7] = { ['id'] = 7, ['x'] = -821.63, ['y'] = -1081.89, ['z'] = 11.13 },
	[8] = { ['id'] = 8, ['x'] = -1409.75, ['y'] = -100.44, ['z'] = 52.38 },
	[9] = { ['id'] = 9, ['x'] = -846.29, ['y'] = -341.28, ['z'] = 38.68 },
	[10] = { ['id'] = 10, ['x'] = -2072.36, ['y'] = -317.23, ['z'] = 13.31 },
	[11] = { ['id'] = 11, ['x'] = -526.64, ['y'] = -1222.97, ['z'] = 18.45 },
	[12] = { ['id'] = 12, ['x'] = -254.41, ['y'] = -692.46, ['z'] = 33.60 },
	[13] = { ['id'] = 13, ['x'] = -203.69, ['y'] = -861.47, ['z'] = 30.26 },
	[14] = { ['id'] = 14, ['x'] = -303.30, ['y'] = -829.81, ['z'] = 32.41 },
	[15] = { ['id'] = 15, ['x'] = -301.72, ['y'] = -830.03, ['z'] = 32.41 }, 
	[16] = { ['id'] = 16, ['x'] = 146.05, ['y'] = -1035.03, ['z'] = 29.34 },
	[17] = { ['id'] = 17, ['x'] = 147.66, ['y'] = -1035.67, ['z'] = 29.34 },
	[18] = { ['id'] = 18, ['x'] = -258.80, ['y'] = -723.40, ['z'] = 33.46 },
	[19] = { ['id'] = 19, ['x'] = -256.15, ['y'] = -716.00, ['z'] = 33.51 },
	[20] = { ['id'] = 20, ['x'] = -537.85, ['y'] = -854.37, ['z'] = 29.28 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIANDO TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('vrp_gruppe6:permissao')
AddEventHandler('vrp_gruppe6:permissao',function()
	if not emservico then
		emservico = true
		parte = 0
		destino = math.random(1,16)
		TriggerEvent("Notify","importante","Voce entrou em <b>Serviço</b>, pegue a <b>Van</b>!")
		ColocarRoupa()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local coordsx,coordsy,coordsz = table.unpack(GetEntityCoords(ped))
		if not emservico then
			timeDistance = 5
			if GetDistanceBetweenCoords(GetEntityCoords(ped), -4.77,-654.20,33.45,true) <= 30 then
			    DrawText3D(-4.77, -654.20, 33.45+0.47, "~w~Transporte de Valores", 1.0, 4)
			    DrawText3D(-4.77, -654.20, 33.45+0.35, "~b~Entregas de Sacos de Dinheiro", 0.8, 1)
			    DrawMarker(39, -4.77, -654.20, 33.45-0.1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 65, 105, 255, 50, 0, true, false, false)
			    if GetDistanceBetweenCoords(GetEntityCoords(ped), -4.77,-654.20,33.45,true) <= 1 then
        	        if IsControlJustPressed(0,38) then	
					    TriggerServerEvent('vrp_gruppe6:permissao')
					end
				end
			end
		elseif emservico and parte == 0 then
			timeDistance = 5
			if GetDistanceBetweenCoords(GetEntityCoords(ped), -10.01,-657.23,33.45,true) <= 20 then
		        DrawMarker(21,-10.01,-657.23,33.45-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
		        if GetDistanceBetweenCoords(GetEntityCoords(ped), -10.01,-657.23,33.45,true) <= 1 then
                    if IsControlJustPressed(0,38) then	
                    	Fade(1200)
				        TriggerEvent("Notify","importante","Voce pegou o <b>Carro Forte</b> na garagem, pegue os <b>Sacos de Dinheiro</b> e coloque nele!")
		                spawnStock()
                        parte = 1
				    end
			    end
		    end
		elseif emservico and parte == 1 then
			timeDistance = 5
		    local veh = GetStockPosition(10)
			local coordsStock = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.8, 0.0)
			local model = GetEntityModel(veh)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),-7.03,-654.11,33.45,true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(ped),coordsStock.x,coordsStock.y,coordsStock.z,true)
			if distance <= 50 and not pegando and portaaberta then
				DrawMarker(21,-7.03,-654.11,33.45-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
				if distance < 1.5 and not IsPedInAnyVehicle(ped) then
                    if IsControlJustPressed(0,38) and not andamento then
                    	if quantidade < 15 then
                            pegando = true
                            andamento = true
                            vRP._CarregarObjeto("anim@heists@narcotics@trash","walk","prop_money_bag_01",50,57005,0.49,-0.18,0.00,25.0,270.0,180.0,2)
                            TriggerEvent('cancelando',true)
                        else
                        	vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                        	TriggerEvent("Notify","aviso","Voce colocou o máximo de <b>estoque</b> no <b>Carro Forte</b>!")
                        end
					end
				end
			end
			if distance2 <= 1.5 and pegando and not IsPedInAnyVehicle(ped) then
			    if model == 1747439474 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
					DrawText3Ds(coordsStock.x,coordsStock.y,coordsStock.z+0.95,"~b~[E] ~w~Guardar")
					TriggerEvent('cancelando',false)
                    if IsControlJustPressed(0,38) and andamento then
                    	quantidade = quantidade + 1
                    	RequestAnimDict("missfbi4prepp1")
			            while not HasAnimDictLoaded("missfbi4prepp1") do
				            Citizen.Wait(0) 
			            end
			            SetTimeout(300,function()
				            vRP._DeletarObjeto()
				            CaixaStock(veh,model)
			            end)            
			            TaskPlayAnim(ped,"missfbi4prepp1","_bag_throw_garbage_man",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                        FreezeEntityPosition(ped,true)
                        Wait(1100)
                        andamento = false
                        pegando = false
				        FreezeEntityPosition(ped,false)
				        ClearPedTasksImmediately(ped)
                        if quantidade == 15 then
                        	TriggerEvent("Notify","importante","Voce colocou <b>"..quantidade.."/15 Sacos de Dinheiro</b> no <b>Carro Forte</b>, entre nele e va ate os <b>Caixas Eletronicos</b>!")
                        	vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                        	portaaberta = false
                        	parte = 2
                        else
                            vRP.playSound("5_Second_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
                            TriggerEvent("Notify","importante","Voce colocou <b>"..quantidade.."/15 Sacos de Dinheiro</b> no <b>Carro Forte</b>!")
                        end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if emservico and parte == 2 then
			timeDistance = 5
		    local veh = GetStockPosition(10)
			local coordsStock = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.8, 0.0)
			local model = GetEntityModel(veh)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),coordsStock.x,coordsStock.y,coordsStock.z,true)
			if distance <= 1.5 and not IsPedInAnyVehicle(ped) and not retirando and not entregando and portaaberta2 then
				if model == 1747439474 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
                    if IsControlJustPressed(0,58) and not andamento then
                        if quantidade > 0 then
                    	    quantidade = quantidade - 1
                            TriggerEvent('cancelando',true)
                            FreezeEntityPosition(ped,true)
                            RequestAnimDict("pickup_object")
				            while not HasAnimDictLoaded("pickup_object") do
					            Citizen.Wait(0) 
				            end
				            TaskPlayAnim(ped,"pickup_object","pickup_low",100.0,200.0,0.3,120,0.2,0,0,0)
                            Wait(700)
                            retirando = true
                            entregando = true
				            ClearPedTasksImmediately(ped)
				            FreezeEntityPosition(ped,false)
                            FreezeEntityPosition(ped,false)
                            vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
                            TriggerEvent("Notify","importante","Voce retirou <b>1x Saco de Dinheiro</b> do <b>Carro Forte</b>, atualmente com <b>"..quantidade.."/15 Sacos de Dinheiro</b>!")
                            vRP._CarregarObjeto("anim@heists@narcotics@trash","walk","prop_money_bag_01",50,57005,0.49,-0.18,0.00,25.0,270.0,180.0,2)
                            TirarCaixa()
                            andamento = true
                        else
                            parte = 1
                            vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                            TriggerEvent("Notify","aviso","Voce entregou todas o seu <b>estoque</b>, volte para a central e pegue mais <b>Sacos de Dinheiro</b>!")
                            quantidade = 0
						end
					end
				end
			end
			if distance <= 1.5 and not IsPedInAnyVehicle(ped) and retirando and entregando and portaaberta2 then
				if model == 1747439474 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
	                TriggerEvent('cancelando',false)
                    if IsControlJustPressed(0,58) and andamento then
                        quantidade = quantidade + 1
                        RequestAnimDict("missfbi4prepp1")
			            while not HasAnimDictLoaded("missfbi4prepp1") do
				            Citizen.Wait(0) 
			            end
			            SetTimeout(300,function()
				            vRP._DeletarObjeto()
				            CaixaStock(veh,model)
			            end)            
			            TaskPlayAnim(ped,"missfbi4prepp1","_bag_throw_garbage_man",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                        FreezeEntityPosition(ped,true)
                        Wait(1100)
                        andamento = false
                        retirando = false
                        entregando = false
				        FreezeEntityPosition(ped,false)
				        ClearPedTasksImmediately(ped)
				        TriggerEvent("Notify","importante","Voce colocou o <b>Saco de Dinheiro</b> no <b>Carro Forte</b>, atualmente com <b>"..quantidade.."/15 Sacos de Dinheiro</b>!")
				        vRP.playSound("5_Second_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
					end
				end
			end
			for i = 1,20 do
			    local distancecaixa = GetDistanceBetweenCoords(GetEntityCoords(ped),entregalocal[i].x,entregalocal[i].y,entregalocal[i].z,true)
			    if distancecaixa <= 50 and entregando and retirando then
				    if distancecaixa < 1.3 and not IsPedInAnyVehicle(ped) then
					    DrawText3Ds(entregalocal[i].x,entregalocal[i].y,entregalocal[i].z+0.35,"~b~[E] ~w~Entregar Saco de Dinheiro")
					    TriggerEvent('cancelando',false)
                        if IsControlJustPressed(0,38) then
                        	TriggerServerEvent("vrp_gruppe6:checkcaixa",entregalocal[i].id)
                        	if quantidade == 0 then
                        		parte = 1
                                vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                                TriggerEvent("Notify","aviso","Voce entregou todas o seu <b>estoque</b>, volte para a central e pegue mais <b>Sacos de Dinheiro</b>!")
                                quantidade = 0
                                entregando = false
                                retirando = false
                                andamento = false
                                portaaberta2 = false
                                portaaberta = false
                            end
                        end
	                end
	            elseif distancecaixa <= 50 and not entregando and not retirando then
				    DrawMarker(21,entregalocal[i].x,entregalocal[i].y,entregalocal[i].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
				    if distancecaixa < 1.5 and not IsPedInAnyVehicle(ped) then
				    	DrawMarker(21,entregalocal[i].x,entregalocal[i].y,entregalocal[i].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
					    DrawText3Ds(entregalocal[i].x,entregalocal[i].y,entregalocal[i].z+0.35,"~w~Pegue o Saco de Dinheiro no ~b~Carro Forte")
					end
                end
            end
		end
		Citizen.Wait(timeDistance)
	end
end)

RegisterNetEvent('vrp_gruppe6:startanim')
AddEventHandler('vrp_gruppe6:startanim', function(id)
	Fade(1200)
	local pagamento = math.random(2000,3500)
    entregando = false
    retirando = false
    andamento = false
    vRP._DeletarObjeto()
    ClearPedTasksImmediately(PlayerPedId())
    TriggerServerEvent("vrp_gruppe6:receber",pagamento)
    TriggerEvent("Notify","sucesso","<b>Saco de Dinheiro</b> entregue, voce ganhou <b>$"..pagamento.."</b>, faltam entregar <b>"..quantidade.."/15 <b>Sacos de Dinheiro</b>!")
    TriggerEvent("Notify","importante","Entre no <b>Carro Forte</b> e vá até outro <b>Caixa Eletronico</b>!")
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if andamento then
			timeDistance = 5
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,22,true)
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local veh = GetStockPosition(10)
		local coordsStock = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.7, 0.0)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coordsStock.x,coordsStock.y,coordsStock.z,true)
        local model = GetEntityModel(veh)
		if distance <= 2.0 and not IsPedInAnyVehicle(PlayerPedId()) and emservico then
			timeDistance = 5
			if model == 1747439474 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
			    if not traseira and not portaaberta and not portaaberta2 then
			        DrawText3Ds(coordsStock.x,coordsStock.y,coordsStock.z+0.95,"~b~[E] ~w~Abrir")
				    if IsControlJustPressed(0,38) then
				        SetVehicleDoorOpen(veh, 3, false, false)
				        SetVehicleDoorOpen(veh, 2, false, false)
				        traseira = true
				        portaaberta2 = true
				        if parte == 1 then
				            portaaberta = true
				        end
				    end
                elseif traseira and not portaaberta then
            	    if parte == 1 then
	                    DrawText3Ds(coordsStock.x,coordsStock.y,coordsStock.z+0.95,"~b~[E] ~w~Fechar")
	                elseif parte == 2 and not entregando then
	            	    DrawText3Ds(coordsStock.x,coordsStock.y,coordsStock.z+0.95,"~b~[E] ~w~Fechar | ~b~[G] ~w~Pegar Saco de Dinheiro")
	                elseif parte == 2 and entregando then
	            	    DrawText3Ds(coordsStock.x,coordsStock.y,coordsStock.z+0.95,"~b~[E] ~w~Fechar | ~b~[G] ~w~Guardar Saco de Dinheiro")
	                end 
				    if IsControlJustPressed(0,38) then
				        SetVehicleDoorShut(veh, 3, false)
				        SetVehicleDoorShut(veh, 2, false)
				        traseira = false
				        if parte == 2 then
				            portaaberta2 = false
				        end
					end
				end
            end
        end
		if distance <= 4.0 and not IsPedInAnyVehicle(PlayerPedId()) and emservico then
			timeDistance = 5
			if model == 1747439474 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
				DrawText3Ds(coordsStock.x,coordsStock.y,coordsStock.z+0.7,"  ~b~"..quantidade.."~w~  /  ~b~15    ")
			end
		end
		Citizen.Wait(timeDistance)
    end
end)

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

function CaixaStock(veh,model)
	if quantidade <= 15 then
		RequestModel(GetHashKey("prop_money_bag_01"))
        while not HasModelLoaded(GetHashKey("prop_money_bag_01")) do
            Citizen.Wait(10)
        end
	    local coords = GetOffsetFromEntityInWorldCoords(veh,0.0,0.0,-5.0)
		if quantidade == 1 and model == 1747439474 then
			propcaixa = nil
			propcaixa = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa,veh,0.0,-0.45,-3.0,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa,true)
		elseif quantidade == 2 and model == 1747439474 then
			propcaixa2 = nil
			propcaixa2 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa2,veh,0.0,0.0,-3.0,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa2,true)
		elseif quantidade == 3 and model == 1747439474 then
			propcaixa3 = nil
			propcaixa3 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa3,veh,0.0,0.45,-3.0,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa3,true)
		elseif quantidade == 4 and model == 1747439474 then
			propcaixa4 = nil
			propcaixa4 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa4,veh,0.0,-0.45,-2.6,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa4,true)
		elseif quantidade == 5 and model == 1747439474 then
			propcaixa5 = nil
			propcaixa5 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa5,veh,0.0,0.0,-2.6,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa5,true)
		elseif quantidade == 6 and model == 1747439474 then
			propcaixa6 = nil
			propcaixa6 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa6,veh,0.0,0.45,-2.6,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa6,true)
		elseif quantidade == 7 and model == 1747439474 then
			propcaixa7 = nil
			propcaixa7 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa7,veh,0.0,-0.45,-2.2,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa7,true)
		elseif quantidade == 8 and model == 1747439474 then
			propcaixa8 = nil
			propcaixa8 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa8,veh,0.0,0.0,-2.2,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa8,true)
		elseif quantidade == 9 and model == 1747439474 then
			propcaixa9 = nil
			propcaixa9 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa9,veh,0.0,0.45,-2.2,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa9,true)
		elseif quantidade == 10 and model == 1747439474 then
			propcaixa10 = nil
			propcaixa10 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa10,veh,0.0,-0.45,-1.8,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa10,true)
		elseif quantidade == 11 and model == 1747439474 then
			propcaixa11 = nil
			propcaixa11 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa11,veh,0.0,0.0,-1.8,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa11,true)
		elseif quantidade == 12 and model == 1747439474 then
			propcaixa12 = nil
			propcaixa12 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa12,veh,0.0,0.45,-1.8,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa12,true)
		elseif quantidade == 13 and model == 1747439474 then
			propcaixa13 = nil
			propcaixa13 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa13,veh,0.0,-0.45,-1.4,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa13,true)
		elseif quantidade == 14 and model == 1747439474 then
			propcaixa14 = nil
			propcaixa14 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa14,veh,0.0,0.0,-1.4,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa14,true)
		elseif quantidade == 15 and model == 1747439474 then
			propcaixa15 = nil
			propcaixa15 = CreateObject(GetHashKey("prop_money_bag_01"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa15,veh,0.0,0.45,-1.4,0.48,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa15,true)
		end
	end
end

function TirarCaixa()
	if quantidade == 0 then
        if DoesEntityExist(propcaixa) then
			DetachEntity(propcaixa,false,false)
			FreezeEntityPosition(propcaixa,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa))
            propcaixa = nil
        end
	elseif quantidade == 1 then
		if DoesEntityExist(propcaixa2) then
			DetachEntity(propcaixa2,false,false)
			FreezeEntityPosition(propcaixa2,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa2))
            propcaixa2 = nil
        end
	elseif quantidade == 2 then
		if DoesEntityExist(propcaixa3) then
			DetachEntity(propcaixa3,false,false)
			FreezeEntityPosition(propcaixa3,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa3))
            propcaixa3 = nil
        end
	elseif quantidade == 3 then
		if DoesEntityExist(propcaixa4) then
			DetachEntity(propcaixa4,false,false)
			FreezeEntityPosition(propcaixa4,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa4))
            propcaixa4 = nil
        end
	elseif quantidade == 4 then
		if DoesEntityExist(propcaixa5) then
			DetachEntity(propcaixa5,false,false)
			FreezeEntityPosition(propcaixa5,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa5))
            propcaixa5 = nil
        end
	elseif quantidade == 5 then
		if DoesEntityExist(propcaixa6) then
			DetachEntity(propcaixa6,false,false)
			FreezeEntityPosition(propcaixa6,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa6))
            propcaixa6 = nil
        end
    elseif quantidade == 6 then
		if DoesEntityExist(propcaixa7) then
			DetachEntity(propcaixa7,false,false)
			FreezeEntityPosition(propcaixa7,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa7))
            propcaixa7 = nil
        end
    elseif quantidade == 7 then
		if DoesEntityExist(propcaixa8) then
			DetachEntity(propcaixa8,false,false)
			FreezeEntityPosition(propcaixa8,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa8))
            propcaixa8 = nil
        end
    elseif quantidade == 8 then
		if DoesEntityExist(propcaixa9) then
			DetachEntity(propcaixa9,false,false)
			FreezeEntityPosition(propcaixa9,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa9))
            propcaixa9 = nil
        end
    elseif quantidade == 9 then
		if DoesEntityExist(propcaixa10) then
			DetachEntity(propcaixa10,false,false)
			FreezeEntityPosition(propcaixa10,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa10))
            propcaixa10 = nil
        end
    elseif quantidade == 10 then
		if DoesEntityExist(propcaixa11) then
			DetachEntity(propcaixa11,false,false)
			FreezeEntityPosition(propcaixa11,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa11))
            propcaixa11 = nil
        end
    elseif quantidade == 11 then
		if DoesEntityExist(propcaixa12) then
			DetachEntity(propcaixa12,false,false)
			FreezeEntityPosition(propcaixa12,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa12))
            propcaixa12 = nil
        end
    elseif quantidade == 12 then
		if DoesEntityExist(propcaixa13) then
			DetachEntity(propcaixa13,false,false)
			FreezeEntityPosition(propcaixa13,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa13))
            propcaixa13 = nil
        end
    elseif quantidade == 13 then
		if DoesEntityExist(propcaixa14) then
			DetachEntity(propcaixa14,false,false)
			FreezeEntityPosition(propcaixa14,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa14))
            propcaixa14 = nil
        end
    elseif quantidade == 14 then
		if DoesEntityExist(propcaixa15) then
			DetachEntity(propcaixa15,false,false)
			FreezeEntityPosition(propcaixa15,false)
            TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa15))
            propcaixa15 = nil
        end
	end
end

function spawnStock()
	local mhash = "stockade"
	if not nveh then
	 while not HasModelLoaded(mhash) do
	  RequestModel(mhash)
	    Citizen.Wait(10)
	 end
		local ped = PlayerPedId()
		local x,y,z = vRP.getPosition()
		nveh = CreateVehicle(mhash,-6.04,-669.45,31.94+0.5,184.20,true,false)
		SetVehicleIsStolen(nveh,false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehicleDirtLevel(nveh,0.0)
		SetVehRadioStation(nveh,"OFF")
		SetVehicleEngineOn(GetVehiclePedIsIn(ped,false),true)
		SetModelAsNoLongerNeeded(mhash)
	end
end

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

function FadeRoupa(time,tipo,idle_copy)
	DoScreenFadeOut(800)
	Wait(time)
	if tipo == 1 then 
		vRP.setCustomization(idle_copy)
	else
		TriggerServerEvent("vrp_gruppe62:roupa")
	end
	DoScreenFadeIn(800)
end

local RoupaEntregador = {
	["Entregador"] = {
		[1885233650] = {                                      
			[1] = {-1,0,2},
			[2] = {70,0,0},
			[3] = {16,0,1},
			[4] = {10,0,1},
			[5] = {0,0,1},
			[6] = {27,0,1},
			[7] = {-1,0,2},
			[8] = {15,0,1},
			[9] = {16,2,1},
			[10] = {-1,0,2},
			[11] = {26,0,1},
			["p6"] = {-1,0},
			["p7"] = {-1,0},
			["p0"] = {46,0},
			[0] = {0,0,0},
			["p2"] = {36,0},
			["p1"] = {0,0},
			
        },
        [-1667301416] = {
			[1] = {-1,0,2},
			[2] = {70,0,0},
			[3] = {16,0,1},
			[4] = {10,0,1},
			[5] = {0,0,1},
			[6] = {27,0,1},
			[7] = {-1,0,2},
			[8] = {15,0,1},
			[9] = {16,2,1},
			[10] = {-1,0,2},
			[11] = {26,0,1},
			["p6"] = {-1,0},
			["p7"] = {-1,0},
			["p0"] = {46,0},
			[0] = {0,0,0},
			["p2"] = {36,0},
			["p1"] = {0,0},
			
        }
	}
}

function ColocarRoupa()
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
			local custom = RoupaEntregador["Entregador"]
			if custom then
				local old_custom = vRP.getCustomization()
				local idle_copy = {}

				idle_copy = job.SaveIdleCustom(old_custom)
				idle_copy.modelhash = nil

				for l,w in pairs(custom[old_custom.modelhash]) do
						idle_copy[l] = w
				end
				FadeRoupa(1200,1,idle_copy)
			end
		end
	end
end

function MainRoupa()
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
	        FadeRoupa(1200,2)
	    end
	end
end
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
        	    quantidade = 0
        	    parte = 0
        	    statuses = false
        	    pegando = false
        	    andamento = false
        	    caixanamao = false
        	    traseira = false
        	    portaaberta = false
        	    portaaberta2 = false
        	    encomendapega = false
				TriggerEvent('cancelando',false)
				RemoveBlip(blip)
				vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				MainRoupa()
				if nveh then
				    TriggerServerEvent("trydeleteveh",VehToNet(nveh))
				    nveh = nil
				end
				if DoesEntityExist(propcaixa) then
        	        DetachEntity(propcaixa,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa))
        	        propcaixa = nil
        	    end
			    if DoesEntityExist(propcaixa2) then
        	        DetachEntity(propcaixa2,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa2))
        	        propcaixa2 = nil
        	    end
			    if DoesEntityExist(propcaixa3) then
        	        DetachEntity(propcaixa3,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa3))
        	        propcaixa3 = nil
        	    end
			    if DoesEntityExist(propcaixa4) then
        	        DetachEntity(propcaixa4,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa4))
        	        propcaixa4 = nil
        	    end 
			    if DoesEntityExist(propcaixa5) then
        	        DetachEntity(propcaixa5,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa5))
        	        propcaixa5 = nil
        	    end
			    if DoesEntityExist(propcaixa6) then
        	        DetachEntity(propcaixa6,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa6))
        	        propcaixa6 = nil
        	    end
			    if DoesEntityExist(propcaixa7) then
        	        DetachEntity(propcaixa7,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa7))
        	        propcaixa7 = nil
        	    end
			    if DoesEntityExist(propcaixa8) then
        	        DetachEntity(propcaixa8,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa8))
        	        propcaixa8 = nil
        	    end
			    if DoesEntityExist(propcaixa9) then
        	        DetachEntity(propcaixa9,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa9))
        	        propcaixa9 = nil
        	    end
			    if DoesEntityExist(propcaixa10) then
        	        DetachEntity(propcaixa10,false,false)
        	        TriggerServerEvent("trydeleteobj",ObjToNet(propcaixa10))
        	        propcaixa10 = nil
        	    end
			end
		end
		Citizen.Wait(timeDistance)
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

function GetStockDirection(coordFrom,coordTo)
	local position = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a,b,c,d,vehicle = GetRaycastResult(position)
	return vehicle
end

function DrawText3D(x,y,z, text, scl, font) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

	local scale = (1/dist)*scl
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
	if onScreen then
		SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 180)
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

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.34, 0.34)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.028, 0, 0, 0, 78)
end