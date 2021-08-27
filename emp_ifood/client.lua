Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
Tunnel.bindInterface("ifood", ifood)
vRPserver = Tunnel.getInterface("vRP")
Proxy.addInterface("ifood", ifood)
vRP = Proxy.getInterface("vRP")
ifood = Tunnel.getInterface("ifood")

local centralifoodX = 5.51
local centralifoodY = -159.69         ----  5.51,-159.69 ,56.21
local centralifoodZ = 56.21

local trabalhando = false
local pedido = false 
local entrega = false
local segundos = 0
local destino = 0
local destinoEntrega = 0
local motoIfood = false

local qtEntrega= 0
local dinheiroGanhoEntrega = 0


--##################### LOCAIS DE ENTREGA E RESTAURANTES                                                            
local restaurantes = {
[1] = {x=144.88,y=-1461.34,z=29.14}, -- Frango 1
[2] = {x=145.24,y=-1541.91,z=29.14},-- Hamburger
[3] = {x=1256.91,y=-357.48,z=69.08}, --hamburguer 2
[4] = {x=162.89,y=-1455.87,z=29.14}, -- chilli
[5] = {x=217.16,y=-35.15,z=69.70}, -- Macarrao

[6] = {x=89.67,y=-217.99,z=54.49}, -- Sanduiche
[7] = {x=394.65,y=-1010.77,z=29.31}, --sanduiche2
[8] = {x=-564.34,y=267.58,z=82.92},-- tequila
[9] = {x=97.47,y=285.11,z=109.97},--Hambrgue gurme
[10] = {x=537.24,y=95.63,z=96.32},  --pizza
[11] = {x=-668.25,y=-1212.09,z=10.59},-- comida chinesa
[12] = {x=-518.76,y=-668.71,z=33.07}, --muffin
[13] = {x=-658.40,y=-669.05,z=31.50}, -- Taco
[14] = {x=-654.34906005859,y=-906.73358154297,z=24.329359054565}, -- Café
[15] = {x=-658.02984619141,y=-890.51098632813,z=24.682584762573} -- Comida chinesa
}


local entregas = {
	[1] = {x=75.20,y=229.06,z=108.70,xp=  43.956279754639,yp=230.43083190918,zp=109.55751037598},
	[2] = {x=390.98,y=-202.86,z=58.63,xp= 417.43695068359,yp=-206.66369628906,zp=59.910488128662 },
	[3] = {x=-56.01,y=-45.66,z=62.96,xp= -40.468963623047,yp=-61.886730194092,zp=63.570346832275},
	[4] = {x=-269.36,y=27.27,z=54.65, xp= -280.93338012695,yp=12.987637519836,zp=54.752494812012},
	[5] = {x=-649.87,y=32.95,z=39.39, xp= -635.84545898438,yp=44.491333007813,zp=42.698799133301},
	[6] = {x=-795.49,y=40.80,z=48.25, xp= -784.79223632813,yp=30.926387786865,zp=47.668449401855} ,
	[7] = {x=-856.99,y=103.30,z=52.72, xp= -834.09399414063,yp=114.55394744873,zp=55.317501068115 },
	[8] = {x=-831.32,y=-227.58,z=37.09, xp= -848.34320068359,yp=-219.29942321777,zp=37.441410064697},
	[9] = {x=-663.36,y=-382.33,z=34.54, xp= -652.44226074219,yp=-395.99975585938,zp=34.766719818115},
	[10] = {x=-295.17,y=-617.44,z=33.31,xp= -285.48004150391,yp=-600.62542724609,zp=33.553199768066},
	[11] = {x=-468.37,y=-667.71,z=32.31,xp= -481.0498046875,yp=-683.47875976563,zp=33.211940765381},
	[12] = {x=-934.24,y=-456.49,z=37.15,xp= -926.54534912109,yp=-438.66513061523,zp=38.433822631836 },
	[13] = {x=-1078.39,y=-267.97,z=37.61,xp= -1086.4556884766,yp=-252.7105255127,zp=37.763290405273},
	[14] = {x=-1492.36,y=-620.81,z=30.40,xp= -1506.6329345703,yp=-609.57489013672,zp=31.285531997681},
	[15] = {x=-1669.03,y=-541.66,z=34.98,xp= -1667.6805419922,yp=-520.97326660156,zp=36.787078857422},
	[16] = {x=-1392.47,y=-580.91,z=30.05,xp= -1378.3420410156,yp=-589.89959716797,zp=29.847770690918},
	[17] = {x=-1081.44,y=-377.81,z=36.92,xp=  -1095.7471923828,yp=-363.23355102539,zp=37.777496337891},
	[18] = {x=-251.60,y=-743.67,z=32.93,xp=  -263.43496704102,yp=-740.04376220703,zp=33.550487518311},
	[19] = {x=13.42,y=-972.96,z=29.30,xp= -16.601943969727,yp=-978.78411865234,zp=29.361768722534},
	[20] = {x=257.70,y=-1062.13,z=29.10,xp= 277.09887695313,yp=-1071.6282958984,zp=29.439767837524},
	[21] = {x=790.22,y=-1278.45,z=26.30,xp= 780.52532958984,yp=-1261.7570800781,zp=26.398796081543},
	[22] = {x=116.34,y=-936.95,z=29.67,xp= 113.4056930542,yp=-916.59118652344,zp=30.032464981079},
	[23] = {x=100.72,y=-1124.16,z=29.18,xp= 114.96524810791,yp=-1112.5299072266,zp=29.303493499756},
	[24] = {x=-723.15,y=-846.94,z=22.82,xp= -714.13861083984,yp=-860.01763916016,zp=23.115739822388},
	[25] = {x=-1047.00,y=-779.63,z=18.93,xp= -1041.06640625,yp=-757.25671386719,zp=19.839345932007},
	[26] = {x=-1020.73,y=-491.82,z=36.98,xp= -1022.0505371094,yp=-505.63467407227,zp=36.913909912109},
	[27] = {x=-1071.15,y=-433.65,z=36.45,xp=-1054.1829833984,yp=-413.61248779297,zp=34.699680328369},
	[28] = {x=-1203.82,y=-131.74,z=40.70,xp=-1227.2359619141,yp=-141.69483947754,zp=40.408233642578},
	[29] = {x=-859.75,y=385.62,z=87.44,xp=-871.10412597656,yp=373.56237792969,zp=86.517890930176},
	[30] = {x=-587.70,y=250.66,z=82.26,xp=-579.03527832031,yp=239.3048248291,zp=82.590812683105},
	[31] = {x=-478.28,y=223.87,z=83.02,xp=-435.73907470703,yp=213.0482635498,zp=81.331993103027},
	[32] = {x=-310.77,y=226.85,z=87.78,xp=-330.28051757813,yp=208.87590026855,zp=87.916816711426},
	[33] = {x=157.41,y=-71.77,z=67.97,xp=149.89849853516,yp=-71.332740783691,zp=71.860107421875},
	[34] = {x=296.00,y=147.55,z=103.77,xp=287.03149414063,yp=136.79211425781,zp=104.29885101318},
	[35] = {x=1182.48,y=-449.31,z=66.61,xp=1172.4859619141,yp=-431.51000976563,zp=67.061538696289},
	[36] = {x=1260.03,y=-582.09,z=68.88,xp=1237.8579101563,yp=-573.88494873047,zp=69.406059265137},
	[37] = {x=1360.39,y=-570.32,z=74.22,xp=1366.6014404297,yp=-548.92767333984,zp=74.337951660156},
	[38] = {x=244.67,y=-349.21,z=44.32,xp=256.84661865234,yp=-334.92138671875,zp=45.019962310791}, 
	[39] = {x=924.20,y=-254.39,z=68.36,xp=930.82897949219,yp=-244.90235900879,zp=69.002670288086}, 
	[40] = {x=831.65,y=-193.95,z=72.62,xp=840.78729248047,yp=-182.17135620117,zp=74.387626647949},
	[41] = {x=864.24,y=-214.71,z=70.54,xp=880.16455078125,yp=-205.05345153809,zp=71.976531982422},
	[42] = {x=491.72,y=-1805.36,z=28.35,xp=495.58557128906,yp=-1823.4801025391,zp=28.86972618103},
	[43] = {x=1016.95,y=183.56,z=80.85,xp=1030.5991210938,yp=161.93934631348,zp=4.990364074707}, 
	[44] = {x=775.59,y=-2253.94,z=29.20,xp=795.66363525391,yp=-2248.0805664063,zp=29.466297149658},
	[45] = {x=555.00,y=-1772.65,z=29.16,xp=540.33996582031,yp=-1778.2922363281,zp=28.88236618042},
	[46] = {x=547.00,y=202.12,z=101.51,xp=528.38317871094,yp=201.32092285156,zp=104.90961456299},
	[47] = {x=1291.93,y=-449.26,z=68.97,xp=1309.6956787109,yp=-453.0302734375,zp=69.441711425781}, 
	[48] = {x=1312.19,y=-549.85,z=71.52,xp=1303.9826660156,yp=-533.99334716797,zp=71.315567016602},
	[49] = {x=1209.12,y=-735.14,z=58.63,xp=1225.4493408203,yp=-724.60607910156,zp=60.602828979492},
	[50] = {x=1082.60,y=-793.23,z=58.27,xp=1054.4907226563,yp=-783.27593994141,zp=58.262718200684},
	[51] = {x=763.34,y=-1353.53,z=26.37,xp=736.00268554688,yp=-1335.3341064453,zp=26.324625015259},
	[52] = {x=912.88,y=-1265.92,z=25.57,xp=933.05267333984,yp=-1250.0699462891,zp=25.537424087524},
	[53] = {x=279.18,y=-1126.90,z=29.26,xp=262.99075317383,yp=-1113.2697753906,zp=29.441619873047},
	[54] = {x=-272.51,y=-1093.01,z=23.78,xp=-288.93670654297,yp=-1082.2552490234,zp=23.021196365356},
	[55] = {x=-602.21,y=-1092.02,z=22.17,xp=-601.10308837891,yp=-1105.2712402344,zp=25.855100631714},
	[56] = {x=914.19,y=-246.96,z=69.03,xp=927.05364990234,yp=-230.77799987793,zp=70.302734375},
	[57] = {x=938.38,y=-265.76,z=67.29,xp=952.76837158203,yp=-252.42924499512,zp=67.96516418457},
}


--################# LISTA DE CLIENTES 																
-----------------------------------------------------------------------------------------------------------------------------------------
local pedlist = {
	[1] = { ['model'] = "ig_abigail", ['hash'] = 0x400AEC41 },
	[2] = { ['model'] = "a_m_o_acult_02", ['hash'] = 0x4BA14CCA },
	[3] = { ['model'] = "a_m_m_afriamer_01", ['hash'] = 0xD172497E },
	[4] = { ['model'] = "ig_mp_agent14", ['hash'] = 0xFBF98469 },
	[5] = { ['model'] = "u_m_m_aldinapoli", ['hash'] = 0xF0EC56E2 },
	[6] = { ['model'] = "ig_amandatownley", ['hash'] = 0x6D1E15F7 },
	[7] = { ['model'] = "ig_andreas", ['hash'] = 0x47E4EEA0 },
	[8] = { ['model'] = "csb_anita", ['hash'] = 0x0703F106 },
	[9] = { ['model'] = "u_m_y_antonb", ['hash'] = 0xCF623A2C },
	[10] = { ['model'] = "g_m_y_armgoon_02", ['hash'] = 0xC54E878A },
	[11] = { ['model'] = "ig_ashley", ['hash'] = 0x7EF440DB },
	[12] = { ['model'] = "s_m_m_autoshop_01", ['hash'] = 0x040EABE3 },
	[13] = { ['model'] = "g_m_y_ballaeast_01", ['hash'] = 0xF42EE883 },
	[14] = { ['model'] = "g_m_y_ballaorig_01", ['hash'] = 0x231AF63F },
	[15] = { ['model'] = "s_m_y_barman_01", ['hash'] = 0xE5A11106 },
	[16] = { ['model'] = "u_m_y_baygor", ['hash'] = 0x5244247D },
	[17] = { ['model'] = "a_m_o_beach_01", ['hash'] = 0x8427D398 },
	[18] = { ['model'] = "a_m_y_beachvesp_01", ['hash'] = 0x7E0961B8 },
	[19] = { ['model'] = "ig_bestmen", ['hash'] = 0x5746CD96 },
	[20] = { ['model'] = "a_f_y_bevhills_01", ['hash'] = 0x445AC854 },
}


function openGui()
  SendNUIMessage({openMeter = true})
end

--Fechar o Gui e desabilitar o NUI
function closeGui()
  SendNUIMessage({openMeter = false})

end

function AtualizaHUD(entregasEfetuadas,DinheiroGanho,rota)
SendNUIMessage({
	updateBalance = true,
	dinheiro = string.format("%.2f", DinheiroGanho),
    entregas = entregasEfetuadas,
	rotatxt = rota
	})
end
local tp = 43;

Citizen.CreateThread(function()
criablipcentral()
AtualizaHUD(0,0,"Restaurante")
    while true do
        local timeDistance = 500
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsUsing(ped)
        --### SE ESTA  PERTO DA CENTRAL IFOOD 
        if pertoCentral() then
			timeDistance = 5
        	DrawMarker(23, centralifoodX, centralifoodY,55.31, 0, 0, 0, 0, 0, 0, 1.501, 1.5001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 1)
            if nearBlip() and not trabalhando then
            	DrawText3D(centralifoodX, centralifoodY, centralifoodZ + 1.5, "PRESSIONE  ~b~E~w~  PARA ~g~INICIAR~w~ EXPEDIENTE")

				--## INICIAR EXPEDIENTE
                if IsControlJustPressed(0, 38) then
					qtEntrega= 0
					dinheiroGanhoEntrega = 0
					AtualizaHUD(0,0,"Restaurante")
                    trabalhando = true          
					pedido = true
					TriggerServerEvent("colocar-uniforme:ifood")
            		TriggerEvent("Notify", "sucesso", "Você iniciou o expediente, pegue uma moto ao lado")
                    openGui()
					criaMoto()
					motoIfood =	true
					destino = math.random(1,15)		
					distanciaDestino = calculaDistancia(restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z)
					while distanciaDestino > 500 do
 					destino = math.random(1,15)		
					distanciaDestino = calculaDistancia(restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z)
					end
                    CriaBlipRestaurante(restaurantes,destino,5)



                end
            end
        end
		--## SE TIVER TRABALHANDO E TIVER PEDIDO PRA PEGAR 
        if trabalhando and pedido then
			timeDistance = 5
            local ui = GetMinimapAnchor()
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z,true)
            if distance <= 50 then
                DrawMarker(21,restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z+0.10,0,0,0,0,180.0,130.0,1.0,1.0,1.0,211,176,72,100,1,0,0,1)
                if distance < 3 then
                DrawText3Ds(restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z, "PRESSIONE [H] PARA PEGAR O PEDIDO")
					--### PEGANDO O PEDIDO 
                    if IsControlJustPressed(0,101) then
                        RemoveBlip(blip)  -- remove o blip anterior
                        segundos = 5
						repeat
                            Citizen.Wait(10)  
                        until segundos == 0
                       
                        TriggerEvent("Notify", "importante", "Leve o pedido até o endereço de entrega!")
                        destinoEntrega = math.random(1,57) --# CRIA DESTINO DE ENTREGA   
                        CriaBlipRestaurante(entregas,destinoEntrega,52) --# CRIA O BLIP ENTREGA NO MAPA 
						local distancia = GetDistanceBetweenCoords(restaurantes[destino].x, restaurantes[destino].y, restaurantes[destino].z, entregas[destinoEntrega].x,entregas[destinoEntrega].y,entregas[destinoEntrega].z,true)
                        pedido = false
                        entrega = true
						AtualizaHUD(qtEntrega,dinheiroGanhoEntrega,"Entrega")
                    end
                end
            end
        end
		--# SE ESTIVER EM ENTREGA 
        if trabalhando and entrega then
			timeDistance = 5
            local ui = GetMinimapAnchor()
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),entregas[destinoEntrega].x,entregas[destinoEntrega].y,entregas[destinoEntrega].z,true)
            if distance <= 50 then
                DrawMarker(21,entregas[destinoEntrega].x,entregas[destinoEntrega].y,entregas[destinoEntrega].z+0.10,0,0,0,0,180.0,130.0,1.0,1.0,1.0,211,176,72,100,1,0,0,1)
                if distance < 3 then
                DrawText3Ds(entregas[destinoEntrega].x,entregas[destinoEntrega].y,entregas[destinoEntrega].z, "PRESSIONE [H] PARA ENTREGAR O PEDIDO")
                    if IsControlJustPressed(0,101) then
                        RemoveBlip(blip) --# REMOVE BLIP 
                   	 	FreezeEntityPosition(vehicle,true) --# FIXA O PLAYER
						local ped2 = PlayerPedId()  --# PEGA ID PLAYER
						coords = GetEntityCoords(ped2) --# PEGA COORDENADAS PLAYER
 						--# PEGA MODELO CLIENTE	
						local pmodel = math.random(#pedlist)
						modelRequest(pedlist[pmodel].model) 
						--# CRIA O CLIENTE
						cliente = CreatePed(4,pedlist[pmodel].hash,entregas[destinoEntrega].xp, entregas[destinoEntrega].yp ,entregas[destinoEntrega].zp ,3374176,true,false)
						SetEntityInvincible(cliente,true)
						TaskGoToCoordAnyMeans(cliente, coords.x, coords.y, coords.z, 1.4, 0, 0, 3374176, 1.0)
						--# VERIFICA A DISTANCIA ENTRE O CLIENTE E O ENTREGADOR	
                   		local distanciaEntrega = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(cliente),true)
						DisableControlAction(0, 75)
							repeat
								distanciaEntrega = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(cliente),true)
								Citizen.Wait(5)  
								drawTxt("AGUARDE O CLIENTE NO LOCAL",4,0.5,19,0.50,255,255,255,180)
							until distanciaEntrega <= 1.5
						--# APOS ENTREGAR EXECUTA AÇÕES
						SetPedFleeAttributes(cliente, 0, 0)
						Citizen.Wait(1000)  
						TaskPlayAnim(cliente,"mp_common","givetake1_a",3.0,3.0,-1,48,10,0,0,0)
						clientecoord = GetEntityCoords(cliente) --# PEGA COORDENADA DO CLIENTE
						Citizen.Wait(1000)  
						--# CRIA O OBJETO LANCHE
						local lanche = CreateObject(GetHashKey("prop_food_bs_bag_04"), clientecoord.x, clientecoord.y, clientecoord.z, 1, 1, 1)
   						sacolaLanche = lanche
						--# APLICA O OBJETO NO CLIENTE
  						AttachEntityToEntity(sacolaLanche, cliente, GetEntityBoneIndexByName(cliente,"IK_R_Hand"), 0.0, 0, -0.38, 0.0, 360.0, 0, false, false, false, false, 2, false)
						TaskGoToCoordAnyMeans(cliente, entregas[destinoEntrega].xp, entregas[destinoEntrega].yp ,entregas[destinoEntrega].zp , 1.0, 0, 0, 3374176, 1.0)
						local distancia = GetDistanceBetweenCoords(restaurantes[destino].x, restaurantes[destino].y, restaurantes[destino].z, entregas[destinoEntrega].x,entregas[destinoEntrega].y,entregas[destinoEntrega].z,true)
						local pagamento = ifood.pagar(distancia) --#CALCULA E REALIZA PAGAMENTO IFOOD
						qtEntrega = qtEntrega + 1
						dinheiroGanhoEntrega = dinheiroGanhoEntrega + pagamento
						AtualizaHUD(qtEntrega,dinheiroGanhoEntrega,"Restaurante")
                        FreezeEntityPosition(vehicle,false) --# DESPAUSA O VEICULO
                        TriggerEvent("Notify", "sucesso", "Você recebeu R$" .. formatarNumero((parseInt(pagamento))) )
                        destino = math.random(1,15)		
						distanciaDestino = calculaDistancia(restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z)
						while distanciaDestino > 500 do
						destino = math.random(1,15)		
						distanciaDestino = calculaDistancia(restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z)
						end
						CriaBlipRestaurante(restaurantes,destino,5)
                        pedido = true
                        entrega = false
						removePeds(cliente)
                    end
                end
            end
        end
		Citizen.Wait(timeDistance)
    end
end)


--# REMOVER O PRODUTO
function removePeds(cliente)
	SetTimeout(20000,function()
		TriggerServerEvent("trydeleteped",PedToNet(cliente))
	end)
end

--# TEMPO PARA CONCLUIR PEDIDO

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if pedido then
			timeDistance = 5
			if segundos > 0 then
				DisableControlAction(0, 75)
				drawTxt("AGUARDE ~y~" .. segundos .. " SEGUNDOS~w~, ENQUANTO PREPARAM O PEDIDO PARA ENTREGA",4,0.5,19,0.50,255,255,255,180)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if pedido then
			if segundos > 0 then
				segundos = segundos - 1
			end
		end
	end
end)

-- TEMPO PARA ENTREGAR PEDIDO

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if entrega then
			timeDistance = 5
			if segundos > 0 then
				DisableControlAction(0, 75)
				drawTxt("AGUARDE ~y~" .. segundos .. " SEGUNDOS~w~, ENQUANTO ENTREGA O LANCHE",4,0.5,19,0.50,255,255,255,180)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if entrega then
			if segundos > 0 then
				segundos = segundos - 1
			end
		end
	end
end)

-------------------------------------
-- SAIR DE SERVICO
-------------------------------------
Citizen.CreateThread(function()
	while true do
      local timeDistance = 500
      if trabalhando then
		timeDistance = 5
		drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
		if IsControlJustPressed(0,168) then
			closeGui()
			guardarMoto()
            trabalhando = false
			motoIfood = false
			RemoveBlip(blip)
			TriggerServerEvent("tirar-uniforme:ifood")
            TriggerEvent("Notify", "importante", "Você encerrou seu expediente, obrigado por trabalhar para o Ifood")
        end
      end
	  Citizen.Wait(timeDistance)
	end
end)

--#  VERIFICA SE ESTA PERTO DA CENTRAL IFOOD   
function pertoCentral()
    local player = GetPlayerPed(-1)
    local localPlayer = GetEntityCoords(player,0)
    local distance = GetDistanceBetweenCoords(centralifoodX, centralifoodY,centralifoodZ, localPlayer.x, localPlayer.y, localPlayer.z, true)
    if (distance <= 36) then
      return true
    end
end
--# SE ESTA PERTO DO BLIP    
function nearBlip() 
    local player = GetPlayerPed(-1)
    local localPlayer = GetEntityCoords(player,0)
    local distance = GetDistanceBetweenCoords(centralifoodX, centralifoodY,centralifoodZ, localPlayer.x, localPlayer.y, localPlayer.z, true)
        if (distance < 1 ) then
            return true
        end
    
end
--# SE ESTA NA GARAGEM    
function nearBlipGarage() 
    local player = GetPlayerPed(-1)
    local localPlayer = GetEntityCoords(player,0)
    local distance = GetDistanceBetweenCoords(9.3494367599487,-160.94593811035,55.31, localPlayer.x, localPlayer.y, localPlayer.z, true)
        if (distance < 3 ) then
            return true
        end
    
end


function guardarMoto()
	local vehicle = vRP.getNearestVehicle(12)

  	local model = GetEntityModel(vehicle)
  	local displaytext = GetDisplayNameFromVehicleModel(model)
  	local name = GetLabelText(displaytext)
	if name == "Enduro" then
		TriggerServerEvent("vrp_garages:admDelete",VehToNet(vehicle),GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle))
		TriggerServerEvent("trydeleteveh",VehToNet(vehicle))
	end
end

function calculaDistancia(x,y,z)
	playerDist = GetEntityCoords(PlayerId())
	return GetDistanceBetweenCoords(x,y,z,playerDist, true)
end


DrawText3D = function(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())
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
		DrawText(_x, _y)
		local factor = (string.len(text)) / 370
		DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.030, 66, 66, 66, 150)
	end
end


function CriaBlipRestaurante(restaurantes,destino,blipCor)
	blip = AddBlipForCoord(restaurantes[destino].x,restaurantes[destino].y,restaurantes[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,blipCor)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pedido Ifood")
	EndTextCommandSetBlipName(blip)
end


function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
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

function modelRequest(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(10)
	end
end

function formatarNumero(valor)
	local formatado = valor
	while true do
		-- O "." entre "%1" e "%2" é o separador
		formatado, n = string.gsub(formatado, "^(-?%d+)(%d%d%d)", "%1.%2")
		if (n == 0) then
			break
		end
	end
	return formatado
end


function  criablipcentral()
	local blip = AddBlipForCoord(centralifoodX, centralifoodY,55.31)
	SetBlipSprite(blip, 348)
	SetBlipColour(blip, 41)
	SetBlipScale(blip, 0.5)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Central | Ifood')
	EndTextCommandSetBlipName(blip)
end

-- SYNCDELETEVEH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncdeleteveh")
AddEventHandler("syncdeleteveh",function(index)
	Citizen.CreateThread(function()
		if NetworkDoesNetworkIdExist(index) then
			SetVehicleAsNoLongerNeeded(index)
			SetEntityAsMissionEntity(index,true,true)
			local v = NetToVeh(index)
			if DoesEntityExist(v) then
				SetVehicleHasBeenOwnedByPlayer(v,false)
				PlaceObjectOnGroundProperly(v)
				SetEntityAsNoLongerNeeded(v)
				SetEntityAsMissionEntity(v,true,true)
				DeleteVehicle(v)
			end
		end
	end)
end)


function criaMoto()
	local vehicle = "enduro"
	local mhash = GetHashKey("enduro")
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end
	if HasModelLoaded(mhash) then
		rand = 1
		while true do
			checkPos = GetClosestVehicle(6.389491558075,-152.73071289063,56.074100494385,3.001,0,71)
		local spawnLocs = {
						[1] = { ['x'] = -2043.39, ['y'] = -443.52, ['z'] = 12.20, ['h'] = 12.20 },
						}
			if DoesEntityExist(checkPos) and checkPos ~= nil then
				rand = rand + 1
				if rand > #spawnLocs[1] then
					rand = -1
					TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.")
					break
				end
			else
				break
			end
			Citizen.Wait(1)
		end
		if rand ~= -1 then
			nveh = CreateVehicle(mhash,6.389491558075,-152.73071289063,56.074100494385+0.5,3.001,true,false)
			netveh = VehToNet(nveh)
			NetworkRegisterEntityAsNetworked(nveh)
			while not NetworkGetEntityIsNetworked(nveh) do
				NetworkRegisterEntityAsNetworked(nveh)
				Citizen.Wait(1)
			end
			if NetworkDoesNetworkIdExist(netveh) then
				SetEntitySomething(nveh,true)
				if NetworkGetEntityIsNetworked(nveh) then
					SetNetworkIdExistsOnAllMachines(netveh,true)
				end
			end
			NetworkFadeInEntity(NetToEnt(netveh),true)
			SetVehicleIsStolen(NetToVeh(netveh),false)
			SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
			SetEntityInvincible(NetToVeh(netveh),false)
			SetVehicleNumberPlateText(NetToVeh(netveh),vRP.getRegistrationNumber())
			SetEntityAsMissionEntity(NetToVeh(netveh),true,true)
			SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
			SetVehRadioStation(NetToVeh(netveh),"OFF")
			if custom then
				vRPg.setVehicleMods(custom,NetToVeh(netveh))
			end
			SetVehicleEngineHealth(NetToVeh(netveh),1000+0.0)
			SetVehicleBodyHealth(NetToVeh(netveh),1000+0.0)
			SetVehicleFuelLevel(NetToVeh(netveh),1000+0.0)
			SetModelAsNoLongerNeeded(mhash)
			
		end
		return true,VehToNet(nveh),name
	end
end