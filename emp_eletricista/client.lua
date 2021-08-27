local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("instaladorInternet")



local Objects = {
    { ["x"] = 399.06744384766, ["y"] = -769.93621826172, ["z"] = 29.286233901978, ["h"] = 69.0, ["model"] = "dt1_15_ladder_003" }

}

local trabalhando = false
local escadaNaMao = false
local escadaNoCarro =true
local escadaNoPoste = false
local foraCarro = true

local executandoServico = false
local servicoConcluido = false


-- UNIFORME
local uniformizado = false




local posteConsertado = {}

--TEMPO PARA COLETAR 
tempoConserto = 6
-- TEMPO DE RESPAWN
local tempoRespawn = 21000  -- 7 minutos 

local respawn = 0
local segundos =0

Citizen.CreateThread(function()		
	FreezeEntityPosition(PlayerPedId(), false)
	while true do
		local objects = {}
		for k,v in pairs(cfg.postes) do
			table.insert(objects, v.prop)
		end
		Citizen.Wait(10)
		if IsControlJustPressed(0,166)  then
			DisplayRadar(false)
		end
		-- BLIP DO EXPEDIENTE 
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-825.55084228516,-731.86492919922,27.074931640625,true)
		if distance <= 30 then
			DrawMarker(23,-825.55084228516,-731.86492919922,27.074931640625,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,80,0,0,0,0)
			if distance <= 1.2 then
				if not trabalhando then
		    		DrawText3D(-825.55084228516,-731.86492919922,28.054931640625 + 1.5, 'PRESSIONE  ~b~E~w~  PARA INICIAR O EXPEDIENTE')  
					if IsControlJustPressed(0,38)  then
						
						if uniformizado then
							trabalhando = true
							notificacao("Expediente iniciado! Vá atá a garagem no estacionamento e pegue um carro")

						else
							notificacao("Você precisa estar uniformizado, visite o blip ao lado!")
						end
					
					end
				else
		    		DrawText3D(-825.55084228516,-731.86492919922,28.054931640625 + 1.5, 'PRESSIONE  ~b~E~w~  PARA ENCERRAR O EXPEDIENTE')  
					if IsControlJustPressed(0,38)  then
						
						if uniformizado then
							trabalhando = false
							notificacao("Expediente Encerrado! Por favor Retire o uniforme ao lado")
						end
					
					end
				end
			end
		end

		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-828.71160888672,-731.94146728516,27.074931640625,true)
		
			if distance <= 1.2 then

				if uniformizado then
		    DrawText3D(-828.71160888672,-731.94146728516,28.074931640625 + 1.5, 'PRESSIONE  ~b~E~w~  PARA TIRAR O UNIFORME')  
					if IsControlJustPressed(0,38)  then
						uniformizado = false
					end
				elseif not uniformizado then
		    DrawText3D(-828.71160888672,-731.94146728516,28.074931640625 + 1.5, 'PRESSIONE  ~b~E~w~  PARA VESTIR O UNIFORME')  

					if IsControlJustPressed(0,38)  then
						uniformizado = true
					end
				end		


			end
	

		--PEGAR ESCADA
		if trabalhando and foraCarro() and Perto()  then
							  local vehicle = vRP.getNearestVehicle(7)

				if escadaNaMao then
							SetVehicleDoorsLocked(vehicle, 2)

				end

				if escadaNoCarro then
							SetVehicleDoorsLocked(vehicle, 1)

				end

					if IsControlJustPressed(0,38) then

						--PEGA ESCADA NO CARRO
						if  not escadaNaMao and escadaNoCarro then
							escadaNoCarro = false
							escadaNaMao = true
							vRP.playAnim(true,{{"mini@repair","fixing_a_ped",1}},false)
							Wait(1000)
							vRP._stopAnim(false)
							vRP._CarregarObjeto("amb@world_human_muscle_free_weights@male@barbell@idle_a","idle_a","prop_byard_ladder01",49,28422)



						elseif escadaNaMao and not escadaNoCarro then
							--GUARDAR ESCADA NO CARRO 
							escadaNoCarro = true
							escadaNaMao = false
							vRP.playAnim(true,{{"mini@repair","fixing_a_ped",1}},false)
							Wait(1000)
							vRP._stopAnim(false)
							vRP._DeletarObjeto()
  							local vehicle = vRP.getNearestVehicle(7)

						end
					
					TriggerEvent('cancelando',false)
				end
	
		end	

-- NOS POSTES
	if escadaNaMao or escadaNoPoste then
		-- PARA CRIAR OS BLIPS
		local ped = GetPlayerPed(-1)
		local list = {}
		for k,v in pairs(objects) do
			local obj = GetClosestObjectOfType(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 3.0, GetHashKey(v), false, true ,true)
			local dist = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(obj), true)
			table.insert(list, {object = obj, distance = dist})
		end
		local closest = list[1]
		for k,v in pairs(list) do
			if v.distance < closest.distance then
				closest = v
			end
		end
		local distance = closest.distance
		local object = closest.object

			--ESCREVE O BLIP NA AREA DE SEGURANÇA PARA NAO CAIR 
			if escadaNoPoste and not executandoServico then
			

					if GetEntityHeightAboveGround(ped) > 6 then


						DrawText3D(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z +2,  'PRESSIONE  ~b~Y~w~  PARA INICIAR O REPARO') 

						if IsControlJustPressed(0, 246) then
							--INICIA O REPARO , SOBE NA ESCADA E MARTELA O MARTELÃO
								executandoServico = true
								segundos = 5


								vRP.playAnim(true,{{"amb@world_human_hammering@male@base","base",1}},false)
								vRP._CarregarObjeto("amb@world_human_hammering@male@base","base","prop_tool_hammer",49,28422)


								DisableControlAction(0,32,true) --  (w)
								DisableControlAction(0,33,true) --  (s)
								repeat
								
								Citizen.Wait(1)
								until segundos == 0
								vRP._DeletarObjeto()
								DisableControlAction(0,32,false) --  (w)
								DisableControlAction(0,33,false) --  (s)
						end




					end
			end

		if distance < cfg.distance and DoesEntityExist(object) and not posteConsertado[object] then

		--ESCREVE NOS POSTES 
			local ped = PlayerPedId()
	    if escadaNaMao then
			DrawText3D(GetEntityCoords(object).x, GetEntityCoords(object).y, GetEntityCoords(object).z + 2.5, 'PRESSIONE  ~b~Y~w~  COLOCAR A ESCADA')  
		elseif escadaNoPoste and  servicoConcluido then
			DrawText3D(GetEntityCoords(object).x, GetEntityCoords(object).y, GetEntityCoords(object).z + 2.5, 'PRESSIONE  ~b~Y~w~  PARA PEGAR A ESCADA')  
		end

			--CONTROLES AO PRESSIONAR Y
				if IsControlJustPressed(0, 246) then
							--COLOCA A ESCADA NO POSTE E FAZ ANIMAÇÃO DE COLOCAR NO POSTE.
				if not escadaNoPoste and escadaNaMao then
								escadaNoPoste = true
								escadaNaMao	= false
								executandoServico =false
								vRP.playAnim(true,{{"mini@repair","fixing_a_ped",1}},false)
								Wait(1000)
								vRP._stopAnim(false)
								vRP._DeletarObjeto()
								TriggerEvent('cancelando',false)
								local HashKey = GetHashKey("hw1_06_ldr_")
								notificacao()
							 	SpawnObject = CreateObject(HashKey,GetEntityCoords(object).x - 0.25 ,GetEntityCoords(object).y ,GetEntityCoords(object).z,true,false)
								PlaceObjectOnGroundProperly(SpawnObject)
								SetEntityHeading(SpawnObject, 69.0)
								FreezeEntityPosition(SpawnObject, true)
								SetEntityAsMissionEntity(SpawnObject, true, true)
									

				-- RETIRA A ESCADA DO POSTE E COLOCA NA MÃO
				elseif escadaNoPoste and not escadaNaMao and servicoConcluido then
						servicoConcluido= false
						executandoServico =false
						escadaNoPoste = false
						escadaNaMao	= true
					posteConsertado[object] = true

						vRP.playAnim(true,{{"mini@repair","fixing_a_ped",1}},false)
						Wait(1000)
						DeleteObject(SpawnObject)
							vRP._CarregarObjeto("amb@world_human_muscle_free_weights@male@barbell@idle_a","idle_a","prop_byard_ladder01",49,28422)
				end
			end
		end
if segundos > 0 then

drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR O REPARO",4,0.5,19,0.50,255,255,255,180)
else


end

	end

		





	end
end)

-- 399.06744384766,-769.93621826172,29.286233901978


-- VERIFICAR SE ESTA FORA DO CARRO
function foraCarro()
local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        if(GetPedInVehicleSeat(veh, -1) == ped) then
		return false
		else
		return true
		end
end

function Perto()
  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped, false)
  local vehicle = vRP.getNearestVehicle(7)
  local model = GetEntityModel(vehicle)
  local displaytext = GetDisplayNameFromVehicleModel(model)
  local name = GetLabelText(displaytext)
	print(model)
local vehicleCoords = GetEntityCoords(vehicle)
local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vehicleCoords.x,vehicleCoords.y,vehicleCoords.z,true)

  if (name == "Comet") and distance < 2.5 then
	if not escadaNaMao then
	DrawText3D(GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z + 1.5, 'PRESSIONE  ~b~E~w~  PARA PEGAR A ESCADA')  
	else 
	DrawText3D(GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z + 1.5, 'PRESSIONE  ~b~E~w~  PARA GUARDAR A ESCADA')  
	end

    return true
  else
    return false
  end
end

--FUNÇÕES IMPORTANTES--
function notificacao(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

DrawText3D = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  	local scale = 0.45
   	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0150, 0.030 + factor , 0.030, 66, 66, 66, 150)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1

			if segundos == 0 then
				vRP._stopAnim(true)

				servicoConcluido = true
				vRP._stopAnim(false)
				local valor = emP.pagar()
				notificacao("Você recebeu R$" .. valor)

				
				TriggerEvent('cancelando',false)
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

function notificacao(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


function CriandoBlip(object)
	blips = AddBlipForCoord(GetEntityCoords(object).x,GetEntityCoords(object).y,GetEntityCoords(object).z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coleta de Lixo")
	EndTextCommandSetBlipName(blips)
end