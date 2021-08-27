local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
job = Tunnel.getInterface("emp_roupas")
checkIn = Proxy.getInterface("vrp_jobcheckin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local quantidade = 0
local statuses = false
local nveh = nil
local pegando = false
local andamento = false
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
local caixanamao = false
local traseira = false
local portaaberta = false
local portaaberta2 = false
local encomendapega = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregalocal = {
	[1] = {x=123.11,y=-229.67,z=54.56},
	[2] = {x=-165.68,y=-311.29,z=39.74},
	[3] = {x=-704.72,y=-160.07,z=37.42}, 
	[4] = {x=-1459.96,y=-239.87,z=49.8}, 
	[5] = {x=-3176.93,y=1045.71,z=20.87}, 
	[6] = {x=-1202.52,y=-772.49,z=17.32}, 
	[7] = {x=-822.97,y=-1069.66,z=11.33}, 
	[8] = {x=71.13,y=-1400.23,z=29.38}, 
	[9] = {x=421.09,y=-799.01,z=29.5}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIANDO TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('emp_roupas:permissao')
AddEventHandler('emp_roupas:permissao',function()
	if not emservico then
		local jobInfo = {
			['titulo'] = "Central de Costureiro",
			['descricao'] = "- Colete os novelos de linha ... Costure e entregue encomendas de roupas pela cidade.",
			['callBackEvent'] = "emp_roupas:checkIn"
		}
		checkIn.openJob(jobInfo)
	end
end)

RegisterNetEvent('emp_roupas:checkIn')
AddEventHandler('emp_roupas:checkIn',function()
	if checkIn.CheckTimer() == 0 then
		if checkIn.CheckJob() == false then
			checkIn.SetJob(true)
		    emservico = true
		    parte = 1
		    destino = math.random(1,9)
		    TriggerEvent("Notify","importante","Voce entrou em <b>Serviço</b>, pegue a <b>Van</b>!")
		    ColocarRoupa()
		else
	    	TriggerEvent("Notify","importante","Voce já está em <b>Serviço</b> em um outro <b>Emprego</b>!")
	    end
	else
		TriggerEvent("Notify","importante","Voce acabou de sair de um <b>Serviço</b>, aguarde <b>"..checkIn.CheckTimer().." Segundos</b> para iniciar <b>Novamente</b>!")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA  720.75,-969.12,30.4 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		if GetDistanceBetweenCoords(GetEntityCoords(ped), 720.75,-969.12,30.4,true) <= 30 then
			timeDistance = 5
		    DrawText3D(720.75,-969.12,30.4+0.47, "~w~Entregador de Roupas", 1.0, 4)
		    --DrawText3D(-424.05,-2789.53,6.39+0.33, "~b~Post Up", 0.9, 1)
		    DrawMarker(21, 720.75,-969.12,30.4-0.1, 0,0,0,0.0,0,0,0.9,0.9,0.8,99,47,121,100,1, false, false, false)
		    if GetDistanceBetweenCoords(GetEntityCoords(ped), 720.75,-969.12,30.4,true) <= 1 then
                if IsControlJustPressed(0,38) then	
				    TriggerServerEvent('emp_roupas:permissao')
				end
			end
		end		
		if emservico and parte == 1 then
			timeDistance = 5
		    local veh = GetVanPosition(10)
			local coordsVan = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.7, 0.0)
			local model = GetEntityModel(veh)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),719.21,-973.75,30.4,true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(ped),coordsVan.x,coordsVan.y,coordsVan.z,true)
			if distance <= 50 and not pegando and portaaberta then
				DrawMarker(21,719.21,-973.75,30.4-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
				if distance < 1.5 and not IsPedInAnyVehicle(ped) then
                    if IsControlJustPressed(0,38) and not andamento then
                    	if job.checkItem() then
                    		if quantidade < 10 then
                            	pegando = true
                            	andamento = true
                            	caixanamao = true
                            	TriggerEvent('cancelando',true)
                            	vRP._CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
                        	else
                        		vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                        		TriggerEvent("Notify","aviso","Voce colocou o máximo de <b>estoque</b> na <b>Van</b>!")
                        	end
                        end
					end
				end
			end
			if pegando and distance2 <= 1.5 and not IsPedInAnyVehicle(ped) then
                if model == -233098306 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
					DrawText3Ds(coordsVan.x,coordsVan.y,coordsVan.z+0.80,"~b~[E] ~w~Guardar")
					TriggerEvent('cancelando',false)
                    if IsControlJustPressed(0,38) and andamento then
                    	quantidade = quantidade + 1
                    	vRP._DeletarObjeto()
                        FreezeEntityPosition(ped,true)
                        RequestAnimDict("anim@heists@money_grab@briefcase")
				        while not HasAnimDictLoaded("anim@heists@money_grab@briefcase") do
					        Citizen.Wait(0) 
				        end
				        TaskPlayAnim(ped,"anim@heists@money_grab@briefcase","put_down_case",100.0,200.0,0.3,120,0.2,0,0,0)
				        Wait(800)
				        vRP._DeletarObjeto()
				        CaixaVan(veh,model)
                        Wait(600)
                        caixanamao = false
                        andamento = false
                        pegando = false
				        ClearPedTasksImmediately(ped)
                        FreezeEntityPosition(ped,false)
                        if quantidade == 10 then
                        	TriggerEvent("Notify","importante","Voce colocou <b>"..quantidade.."/10 Encomendas</b> na <b>Van</b>, feche as portas traseiras, entre nela e aguarde até receber uma <b>Entrega</b>!")
                        	vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                        	portaaberta = false
                        	time = math.random(10000,15000)
                        	parte = 2
                        	Wait(time)
                            TriggerEvent("Notify","sucesso","Chamado recebido, entre na <b>Van</b>, e vá ao <b>local</b> entregar a <b>encomenda</b>!")
                        	vRP.playSound("ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
                        	CriandoBlip(entregalocal,destino)
                        else
                        	TriggerEvent("Notify","importante","Voce colocou <b>"..quantidade.."/10 Encomendas</b> na <b>Van</b>!")
                            vRP.playSound("5_Second_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")
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
		    local veh = GetVanPosition(10)
			local coordsVan = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.7, 0.0)
			local model = GetEntityModel(veh)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),coordsVan.x,coordsVan.y,coordsVan.z, true)
			local distance2 = GetDistanceBetweenCoords(GetEntityCoords(ped),entregalocal[destino].x,entregalocal[destino].y,entregalocal[destino].z,true)
			if not pegando and portaaberta2 and not encomendapega and distance <= 1.5 and not IsPedInAnyVehicle(ped) then
				if model == -233098306 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
                    if IsControlJustPressed(0,58) and not andamento then
                    	if quantidade > 0 then
                    	    quantidade = quantidade - 1
                    	    encomendapega = true
                            TriggerEvent('cancelando',true)
                            FreezeEntityPosition(ped,true)
                            RequestAnimDict("pickup_object")
				            while not HasAnimDictLoaded("pickup_object") do
					            Citizen.Wait(0) 
				            end
				            TaskPlayAnim(ped,"pickup_object","pickup_low",100.0,200.0,0.3,120,0.2,0,0,0)
                            Wait(700)
                            pegando = true
				            ClearPedTasksImmediately(ped)
                            FreezeEntityPosition(ped,false)
                            vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
                            TriggerEvent("Notify","importante","Voce retirou <b>1x Encomenda</b> da <b>Van</b>!")
                            vRP._CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
                            TirarCaixa()
                            andamento = true
                        else
                            parte = 1
                            vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                        	TriggerEvent("Notify","aviso","Voce entregou todas as suas <b>encomendas</b>, volte para a central e pegue mais!")
                            quantidade = 0
                        end
					end
				end
			end
			if pegando and portaaberta2 and encomendapega and distance <= 1.5 and not IsPedInAnyVehicle(ped) then
                if model == -233098306 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
					TriggerEvent('cancelando',false)
                    if IsControlJustPressed(0,58) and andamento then
                    	quantidade = quantidade + 1
                    	encomendapega = false
                    	vRP._DeletarObjeto()
                        FreezeEntityPosition(ped,true)
                        RequestAnimDict("anim@heists@money_grab@briefcase")
				        while not HasAnimDictLoaded("anim@heists@money_grab@briefcase") do
					        Citizen.Wait(0) 
				        end
				        TaskPlayAnim(ped,"anim@heists@money_grab@briefcase","put_down_case",100.0,200.0,0.3,120,0.2,0,0,0)
				        Wait(800)
				        vRP._DeletarObjeto()
				        CaixaVan(veh,model)
                        Wait(600)
                        caixanamao = false
                        andamento = false
                        pegando = false
                        vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
				        ClearPedTasksImmediately(ped)
                        FreezeEntityPosition(ped,false)
                        TriggerEvent("Notify","importante","Voce colocou a <b>encomenda</b> na <b>Van</b>, atualmente com <b>"..quantidade.."/10 Encomendas</b>!")
					end
				end
			end
			if distance2 <= 50 and pegando and encomendapega then
				if distance2 < 1.5 and not IsPedInAnyVehicle(ped) then
					DrawText3Ds(entregalocal[destino].x,entregalocal[destino].y,entregalocal[destino].z+0.35,"~b~[E] ~w~Entregar Encomenda")
					TriggerEvent('cancelando',false)
                    if IsControlJustPressed(0,38) then
                    	if quantidade >= 0 then
                    		Fade(1200)
                    		local pagamento = math.random(1000,2000)
                    		destinoantigo = destino
							pegando = false
							encomendapega = false
                            andamento = false
                            vRP._DeletarObjeto()
                            ClearPedTasksImmediately(ped)
                            TriggerServerEvent("emp_roupas:receber",pagamento)
                            portaaberta = false
                            RemoveBlip(blip)
                        	if quantidade > 0 then
                        		TriggerEvent("Notify","sucesso","<b>Encomenda</b> entregue, voce ganhou <b>R$"..pagamento.."</b>, faltam entregar <b>"..quantidade.."/10 <b>Encomendas</b>!")
                                TriggerEvent("Notify","importante","Feche as portas traseiras, entre na <b>Van</b> e aguarde até receber uma <b>Entrega</b>!")
                                time = math.random(10000,20000)
                        	    Wait(time)
                        	    TriggerEvent("Notify","sucesso","Chamado recebido, entre na <b>Van</b>, e vá ao <b>local</b> entregar a <b>encomenda</b>!")
                        	    vRP.playSound("ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
                                while true do
                                    if destinoantigo == destino then
                                        destino = math.random(1,9)
                                    else
                                        break
                                    end
                                    Citizen.Wait(1)
                                end
                                CriandoBlip(entregalocal,destino)
                            else
                            	parte = 1
                        	    vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
                        	    quantidade = 0
                        	    destino = math.random(1,9)
                        	    TriggerEvent("Notify","aviso","Voce entregou todas as suas <b>encomendas</b>, volte para a central e pegue mais!")
                            end
                        end
					end
				end
			elseif distance2 <= 50 and not pegando and not encomendapega then
				DrawMarker(21,entregalocal[destino].x,entregalocal[destino].y,entregalocal[destino].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
				if distance2 < 1.5 and not IsPedInAnyVehicle(ped) then
					DrawMarker(21,entregalocal[destino].x,entregalocal[destino].y,entregalocal[destino].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
					DrawText3Ds(entregalocal[destino].x,entregalocal[destino].y,entregalocal[destino].z+0.35,"~w~ Pegue a Encomenda na ~b~Van")
			    end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local veh = GetVanPosition(10)
		local coordsVan = GetOffsetFromEntityInWorldCoords(veh, 0.0, -2.7, 0.0)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coordsVan.x,coordsVan.y,coordsVan.z,true)
		local model = GetEntityModel(veh)
		if distance <= 2.0 and not IsPedInAnyVehicle(PlayerPedId()) and emservico then
			timeDistance = 5
		    if model == -233098306 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
			    if not traseira and not portaaberta and not portaaberta2 then
			        DrawText3Ds(coordsVan.x,coordsVan.y,coordsVan.z+0.80,"~b~[E] ~w~Abrir")
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
	                    DrawText3Ds(coordsVan.x,coordsVan.y,coordsVan.z+0.80,"~b~[E] ~w~Fechar")
	                elseif parte == 2 and not encomendapega then
	            	    DrawText3Ds(coordsVan.x,coordsVan.y,coordsVan.z+0.80,"~b~[E] ~w~Fechar | ~b~[G] ~w~Pegar Encomenda")
	                elseif parte == 2 and encomendapega then
	            	    DrawText3Ds(coordsVan.x,coordsVan.y,coordsVan.z+0.80,"~b~[E] ~w~Fechar | ~b~[G] ~w~Guardar Encomenda")
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
		if distance <= 3.0 and not IsPedInAnyVehicle(PlayerPedId()) and emservico then
			timeDistance = 5
			if model == -233098306 and GetVehicleNumberPlateText(veh) == vRP.getRegistrationNumber() then
				DrawText3Ds(coordsVan.x,coordsVan.y,coordsVan.z+0.55,"  ~b~"..quantidade.."~w~  /  ~b~10    ")
			end
		end
		Citizen.Wait(timeDistance)
    end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if andamento then
			timeDistance = 5
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
		end
		Citizen.Wait(timeDistance)
	end
end)

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
		TriggerServerEvent("emp_roupas:roupa")
	end
	DoScreenFadeIn(800)
end

local RoupaEntregador = {
	["Entregador"] = {
		[1885233650] = {                                      
            [1] = { -1,0 },
            [3] = { 11,0 },
            [4] = { 10,0 },
            [5] = { -1,0 },
            [6] = { 42,1 },
            [7] = { -1,0 },
            [8] = { 49,0 },
            [10] = { -1,0 },
            [11] = { 25,2 },
            ["p0"] = { -1,0 },
            ["p1"] = { -1,0 }
        },
        [-1667301416] = {
            [1] = { 0,0 },            
            [3] = { 0,0 },
            [4] = { 6,2 },
            [5] = { 0,0 },
            [6] = { 27,0 },
            [7] = { 0,0 },
            [8] = { 24,5 },
            [9] = { 0,0 },
            [10] = { 0,0 },
            [11] = { 28,3 },
            ["p0"] = { -1,0 },
            ["p1"] = { -1,0 }
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

function CaixaVan(veh,model)
	if quantidade <= 10 then
		RequestModel(GetHashKey("hei_prop_heist_box"))
        while not HasModelLoaded(GetHashKey("hei_prop_heist_box")) do
            Citizen.Wait(10)
        end
	    local coords = GetOffsetFromEntityInWorldCoords(veh,0.0,0.0,-5.0)
		if quantidade == 1 and model == -233098306 then
			propcaixa = nil
			propcaixa = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa,veh,0.0,-0.25,-3.0,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa,true)
		elseif quantidade == 2 and model == -233098306 then
			propcaixa2 = nil
			propcaixa2 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa2,veh,0.0,0.25,-3.0,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa2,true)
		elseif quantidade == 3 and model == -233098306 then
			propcaixa3 = nil
			propcaixa3 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa3,veh,0.0,-0.25,-2.55,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa3,true)
		elseif quantidade == 4 and model == -233098306 then
			propcaixa4 = nil
			propcaixa4 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa4,veh,0.0,0.25,-2.55,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa4,true)
		elseif quantidade == 5 and model == -233098306 then
			propcaixa5 = nil
			propcaixa5 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa5,veh,0.0,-0.25,-2.1,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa5,true)
		elseif quantidade == 6 and model == -233098306 then
			propcaixa6 = nil
			propcaixa6 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa6,veh,0.0,0.25,-2.1,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa6,true)
		elseif quantidade == 7 and model == -233098306 then
			propcaixa7 = nil
			propcaixa7 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa7,veh,0.0,-0.25,-1.65,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa7,true)
		elseif quantidade == 8 and model == -233098306 then
			propcaix8 = nil
			propcaixa8 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa8,veh,0.0,0.25,-1.65,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa8,true)
		elseif quantidade == 9 and model == -233098306 then
			propcaixa9 = nil
			propcaixa9 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa9,veh,0.0,-0.25,-1.2,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa9,true)
		elseif quantidade == 10 and model == -233098306 then
			propcaix10 = nil
			propcaixa10 = CreateObject(GetHashKey("hei_prop_heist_box"),coords.x,coords.y,coords.z,true,true,true)
			AttachEntityToEntity(propcaixa10,veh,0.0,0.25,-1.2,-0.05,0.0,0.0,0.0,false,false,true,false,2,true)
			FreezeEntityPosition(propcaixa10,true)
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
        	    checkIn.LeaveJob()
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
-----------------------------------------------------------------------------------------------------------------------------------------
function GetVanPosition(radius)
	local ped = PlayerPedId()
	local coordsx = GetEntityCoords(ped, 1)
	local coordsy = GetOffsetFromEntityInWorldCoords(ped, 0.0, radius+0.00001, 0.0)
	local nearVehicle = GetVanDirection(coordsx, coordsy)
	if IsEntityAVehicle(nearVehicle) then
	    return nearVehicle
	else
		local x,y,z = table.unpack(coordsx)
	    if IsPedSittingInAnyVehicle(ped) then
	        local veh = GetVehiclePedIsIn(ped,true)
	        return veh
	    else
	        local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001,radius+0.0001,0,8192+4096+4+2+1) 
	        if not IsEntityAVehicle(veh) then 
	        	veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001,radius+0.0001,0,4+2+1) 
	        end 
	        return veh
	    end
	end
end

function GetVanDirection(coordFrom,coordTo)
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

function CriandoBlip(entregalocal,destino)
	blip = AddBlipForCoord(entregalocal[destino].x,entregalocal[destino].y,entregalocal[destino].z)
	SetBlipSprite(blip,162)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.45)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Encomendas")
	EndTextCommandSetBlipName(blip)
end

function drawTxt(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end