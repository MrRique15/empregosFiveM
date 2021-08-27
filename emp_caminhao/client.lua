local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emp = Tunnel.getInterface("emp_caminhao")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local caminhao = nil
local carga = nil
local emservico = false
local pagamento = 0

local modelCaminhao = "packer"
local modelCarga = "trailers2"
local modelGasolina = "tanker"

local cargaX = 913.53
local cargaY = -3239.57   --------   913.53,-3239.57,5.89
local cargaZ = 5.89

local camX = 896.28
local camY = -3210.65
local camZ = 5.91

local cargaSX = 904.48
local cargaSY = -3209.0
local cargaSZ = 5.90

local gasolinaX = 911.95
local gasolinaY = -3239.55
local gasolinaZ = 5.89

local gasolinaSX = 912.57
local gasolinaSY = -3209.52
local gasolinaSZ = 5.90

local cargas = {
	[1] = { x=-276.16, y=6038.97, z=31.59, pag=10 },
	[2] = { x=3.31, y=6271.49, z=31.27, pag=10 },
	[3] = { x=131.39, y=6589.83, z=31.92, pag=10 },
	[4] = { x=194.60, y=2749.21, z=43.42, pag=10 },
	[5] = { x=329.74, y=3421.73, z=36.50, pag=10 },
	[6] = { x=1701.31, y=-1500.34, z=112.96, pag=5 }
}

local gasolina = {
	[1] = { x=280.68, y=-1260.10, z=29.21, pag=5 },
	[2] = { x=-728.23, y=-914.21, z=19.01, pag=5 },
	[3] = { x=-2065.59, y=-305.34, z=13.14, pag=5 },
	[4] = { x=646.11, y=278.34, z=103.15, pag=5 },
	[5] = { x=1174.60, y=-316.58, z=69.17, pag=5 },
	[6] = { x=1200.73, y=-1386.92, z=35.22, pag=5 },
	[7] = { x=2565.57, y=354.64, z=108.46, pag=7 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local px,py,pz = table.unpack(GetEntityCoords(ped,true))
		local unusedBool,coordz = GetGroundZFor_3dCoord(cargaX,cargaY,cargaZ,true)
		local distancia = GetDistanceBetweenCoords(cargaX,cargaY,coordz,px,py,pz,true)
		if distancia <= 30 then
			timeDistance = 5
			if not carga then
				DrawMarker(23,cargaX,cargaY,cargaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,211,176,72,100,0,0,0,0)
				if distancia <= 1.1 then
					drawTxt("PRESSIONE ~b~E~w~ PARA PEGAR A CARGA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						TriggerServerEvent("colocar-uniforme:caminhaonovo")
						if not carga then
							while not HasModelLoaded(modelCarga) do
								RequestModel(modelCarga)
								Citizen.Wait(10)
							end
							carga = CreateVehicle(modelCarga,cargaSX,cargaSY,cargaSZ,180.0,true,false)
							NetworkFadeInEntity(carga,true)
							SetVehicleIsStolen(carga,false)
							SetVehicleNumberPlateText(carga,"TRABALHO")
							SetVehicleOnGroundProperly(carga)
							SetVehicleHasBeenOwnedByPlayer(carga,true)
							SetEntityInvincible(carga,false)
							SetEntityAsMissionEntity(carga,true,true)
							SetVehicleDirtLevel(carga,0.0)
							SetModelAsNoLongerNeeded(modelCarga)
							destino = math.random(1,6)
							pagamento = cargas[destino].pag
							CriandoBlip(cargas,destino)
						end
						if not caminhao then
							while not HasModelLoaded(modelCaminhao) do
								RequestModel(modelCaminhao)
								Citizen.Wait(10)
							end
							caminhao = CreateVehicle(modelCaminhao,camX,camY,camZ,180.0,true,false)
							NetworkFadeInEntity(caminhao,true)
							SetVehicleIsStolen(caminhao,false)
							SetVehicleNumberPlateText(caminhao,"TRABALHO")
							SetVehicleOnGroundProperly(caminhao)
							SetVehicleHasBeenOwnedByPlayer(caminhao,true)
							SetEntityInvincible(caminhao,false)
							SetEntityAsMissionEntity(caminhao,true,true)
							SetVehicleDirtLevel(caminhao,0.0)
							SetModelAsNoLongerNeeded(modelCaminhao)
						end
					end
				end
			end
		end
		if carga then
			timeDistance = 5
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),cargas[destino].x,cargas[destino].y,cargas[destino].z,true)
			if distance <= 50 then
				DrawMarker(21,cargas[destino].x,cargas[destino].y,cargas[destino].z,0,0,0,0,180.0,130.0,2.0,2.0,1.0,211,176,72,100,1,0,0,1)
				if distance < 3 then
					drawTxt("PRESSIONE ~b~G~w~ PARA ENTREGAR A CARGA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,47) then
						if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey(modelCaminhao)) then
							RemoveBlip(blip)
							DeleteVehicle(carga)
							carga = nil
							destino = nil
							emp.EntregarItens(pagamento)
							pagamento = 0
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
		local px,py,pz = table.unpack(GetEntityCoords(ped,true))
		local unusedBool,coordz = GetGroundZFor_3dCoord(gasolinaX,gasolinaY,gasolinaZ,true)
		local distancia = GetDistanceBetweenCoords(gasolinaX,gasolinaY,coordz,px,py,pz,true)
		if distancia <= 30 then
			timeDistance = 5
			if not carga then
				DrawMarker(23,gasolinaX,gasolinaY,gasolinaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,211,176,72,100,0,0,0,0)
				if distancia <= 1.1 then
					drawTxt("PRESSIONE ~b~E~w~ PARA PEGAR A CARGA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						TriggerServerEvent("colocar-uniforme:caminhaonovo")
						if not carga then
							while not HasModelLoaded(modelGasolina) do
								RequestModel(modelGasolina)
								Citizen.Wait(10)
							end
							carga = CreateVehicle(modelGasolina,gasolinaSX,gasolinaSY,gasolinaSZ,180.0,true,false)
							NetworkFadeInEntity(carga,true)
							SetVehicleIsStolen(carga,false)
							SetVehicleNumberPlateText(carga,"TRABALHO")
							SetVehicleOnGroundProperly(carga)
							SetVehicleHasBeenOwnedByPlayer(carga,true)
							SetEntityInvincible(carga,false)
							SetEntityAsMissionEntity(carga,true,true)
							SetVehicleDirtLevel(carga,0.0)
							SetModelAsNoLongerNeeded(modelGasolina)
							destino = math.random(1,5)
							pagamento = gasolina[destino].pag
							CriandoBlip(gasolina,destino)
						end
						if not caminhao then
							while not HasModelLoaded(modelCaminhao) do
								RequestModel(modelCaminhao)
								Citizen.Wait(10)
							end
							caminhao = CreateVehicle(modelCaminhao,camX,camY,camZ,180.0,true,false)
							NetworkFadeInEntity(caminhao,true)
							SetVehicleIsStolen(caminhao,false)
							SetVehicleNumberPlateText(caminhao,"TRABALHO")
							SetVehicleOnGroundProperly(caminhao)
							SetVehicleHasBeenOwnedByPlayer(caminhao,true)
							SetEntityInvincible(caminhao,false)
							SetEntityAsMissionEntity(caminhao,true,true)
							SetVehicleDirtLevel(caminhao,0.0)
							SetModelAsNoLongerNeeded(modelCaminhao)
						end
					end
				end
			end
		end
		if carga then
			timeDistance = 5
			local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),gasolina[destino].x,gasolina[destino].y,gasolina[destino].z,true)
			if distance <= 50 then
				DrawMarker(21,gasolina[destino].x,gasolina[destino].y,gasolina[destino].z,0,0,0,0,180.0,130.0,2.0,2.0,1.0,211,176,72,100,1,0,0,1)
				if distance < 3 then
					drawTxt("PRESSIONE ~b~G~w~ PARA ENTREGAR A CARGA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,47) then
						if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey(modelCaminhao)) then
							RemoveBlip(blip)
							DeleteVehicle(carga)
							carga = nil
							destino = nil
							emp.EntregarItens(pagamento)
							pagamento = 0
						end
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local cooldown = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local carro = GetVehiclePedIsIn(ped,false)
		local velocidade = GetEntitySpeed(carro)
		if carga or caminhao then
			timeDistance = 5
			if IsEntityAVehicle(carro) then
				if math.ceil(velocidade*3.6) >= 101 and cooldown <= 0 and pagamento > 0 then
					cooldown = 5
					pagamento = pagamento - 1
					TriggerClientEvent("Notify",source,"aviso","Você está acima de <b>1100KM/H</b>, reduzimos do seu pagamento o valor da multa, você tem 5 segundos para reduzir a velocidade.")
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if carga or caminhao then
			drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
			timeDistance = 5
			if IsControlJustPressed(0,168) then
				TriggerServerEvent("tirar-uniforme:caminhaonovo")
				TriggerEvent("Notify","negado","Você saiu de serviço!")
				if carga then
					DeleteVehicle(carga)
					carga = nil
				end
				if caminhao then
					DeleteVehicle(caminhao)
					caminhao = nil
				end
				RemoveBlip(blip)
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

function CriandoBlip(entregas,destino)
	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Transporte dos Caminhoneiros")
	EndTextCommandSetBlipName(blip)
end