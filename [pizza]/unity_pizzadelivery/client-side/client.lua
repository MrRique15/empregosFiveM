----------------------------------------------------------------------
-- FRAMEWORK TUNNEL (NÃO MEXER)
----------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
----------------------------------------------------------------------
-- VARIAVEIS (NÃO MEXER)
---------------------------------------------------------------------- 
local service = false -- não mexer
local object = nil -- não mexer
local pickvehicle = false -- não mexer
local carrypizza = false -- não mexer
local readydelivery = false -- não mexer
local pizza = 0 -- não mexer
local selected = 0 -- não mexer
local nveh = nil -- Não mexer
-- CONFIGURAR O SCRIPT DE ACORDO COM SUA CIDADE, BOM USO MEU QUERIDO, QUALQUER COISA ME CHAMA DISCORD: </Caduh>#2543
local vehiclejobhash = -909201658 -- CONFIGURAR O HASH DO VEICULO DE TRABALHO
local startservice = { 279.25,-973.80,29.87 } -- ONDE INICIAR A ROTA
local garage = { 291.19,-962.79,29.41 } -- BLIP PARA RETIRAR O VEICULO DE TRABALHO
local vehicleposition = { 292.29,-957.23,28.75,325.46 } -- LOCAL ONDE O VEICULO SPAWNA QUANDO UTILIZAR O BLIP DA GARAGEM
local spawnprop = { 280.98,-974.67,30.72 } -- LOCAL ONDE SPAWNA O PROP DA PIZZA PARA PEGAR
-- # CONFIGURAR CASAS(Locais onde o jogador terá que entregar as pizzas)
local homes = { 
	[1] = { 511.51,232.05,104.74 },
    [2] = { -831.68,114.84,55.42 },
    [3] = { -1493.74-668.25,29.02 },
    [4] = { -988.81,-1575.73,5.23 },
    [5] = { -554.81,-798.73,30.69 },
    [6] = { -14.15,-1441.50,31.10 },
    [7] = { 320.34,-2099.18,18.04 },
    [8] = { 830.30,-1310.38,28.25 },
    [9] = { 961.46,-669.00,58.44 },
    [10] = { 225.07,-160.84,59.06 }
}
---------------------------------------------------------------------
-- FUNCTIONS (NÃO MEXER)
---------------------------------------------------------------------
function startRoute()
	selected = math.random(#homes)
	CreateBlip(selected)
end

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

function CreateBlip(route)
	blip = AddBlipForCoord(homes[route][1],homes[route][2],homes[route][3])
	SetBlipSprite(blip,162)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de pizza")
	EndTextCommandSetBlipName(blip)
end

function DrawText3D(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function spawnMotorcycle()
    local ped = PlayerPedId()
	local mhash = "cg160"

	if not nveh then
        while not HasModelLoaded(mhash) do
    	  	RequestModel(mhash)
    	    Citizen.Wait(10)
	    end

		nveh = CreateVehicle(mhash,vehicleposition[1],vehicleposition[2],vehicleposition[3]+0.5,vehicleposition.r,true,false)
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

function getMotorcyclePosition(radius)
	local ped = PlayerPedId()
	local coordsx = GetEntityCoords(ped, 1)
	local coordsy = GetOffsetFromEntityInWorldCoords(ped, 0.0, radius+0.00001, 0.0)
	local nearVehicle = GetMotorDirection(coordsx, coordsy)
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

function GetMotorDirection(coordFrom,coordTo)
	local position = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a,b,c,d,vehicle = GetRaycastResult(position)
	return vehicle
end

function spawnPizza()
	object = CreateObject(GetHashKey("prop_pizza_box_02"),spawnprop[1],spawnprop[2],spawnprop[3]-0.95,false,true,false)
	SetEntityAsMissionEntity(object)
	TriggerEvent("Notify","importante","Há uma nova entrega, retire no <b>balcão</b> da pizzaria", 5000)
end

function pickPizza()	
	TriggerEvent("emotes","pizza")
	carrypizza = true
	vRP.playSound("ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
	DeleteObject(object)
end

function putPizza()
	carrypizza = false
	ClearPedTasksImmediately(ped)
	vRP._DeletarObjeto()
	vRP.stopAnim(true)
end
---------------------------------------------------------------------
-- NÃO CORRER COM A PIZZA NA MÃO (NÃO MEXER)
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
	    local sleep = 1000

		if carrypizza then
			sleep = 5
			DisableControlAction(0,21,true)
		end

	    Citizen.Wait(sleep)
	end
end)
---------------------------------------------------------------------
-- SAIR DE SERVIÇO (NÃO MEXER)
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
    	local sleep = 1000
    	local ped = PlayerPedId()

        if service then
            sleep = 5
			drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
    		if IsControlJustPressed(0,168) then
                local veh = getMotorcyclePosition(2)
                local model = GetEntityModel(veh)

                if IsPedInAnyVehicle(ped) and model == vehiclejobhash then
        			TriggerEvent("Notify","importante","Você saiu de serviço",4000)
        			DeleteObject(object)
					DeleteVehicle(nveh)
					RemoveBlip(blip)
        			nveh = nil
        			service = false
        			object = nil
        			pickvehicle = false
        			carrypizza = false
        			readydelivery = false
        			pizza = 0
        			selected = 0
					TriggerServerEvent("tirar-uniforme:pizza")
				else
					TriggerEvent("Notify","importante","Você saiu de serviço",4000)
        			DeleteObject(object)
					DeleteVehicle(nveh)
					RemoveBlip(blip)
        			nveh = nil
        			service = false
        			object = nil
        			pickvehicle = false
        			carrypizza = false
        			readydelivery = false
        			pizza = 0
        			selected = 0
					TriggerServerEvent("tirar-uniforme:pizza")
				end
    		end	
    	end
        Citizen.Wait(sleep)
	end
end)
---------------------------------------------------------------------
-- ENTREGAR A PIZZA NA CASA (NÃO MEXER)
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local coords = vector3(GetEntityCoords(ped))

		if readydelivery then
			local distance = #(coords - vector3(homes[selected][1],homes[selected][2],homes[selected][3]))
			if distance <= 2 then
				sleep = 5
				DrawMarker(37,homes[selected][1],homes[selected][2],homes[selected][3]-0.8,0,0,0,0.0,0,0,0.6,0.6,0.5,209,185,72,100,0,0,0,1)
				if IsControlJustPressed(0,38) and carrypizza then
					if pizza ~= 0 then
						RemoveBlip(blip)
						startRoute()
						putPizza()
                        TriggerServerEvent("unity_pizzadelivery:payment")
					else
						RemoveBlip(blip)
						putPizza()
						readydelivery = false
						spawnPizza()
                        TriggerServerEvent("unity_pizzadelivery:payment")
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
---------------------------------------------------------------------
-- PEGAR SERVIÇO (NÃO MEXER)
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local coords = vector3(GetEntityCoords(ped))
		if not service then
            local distance = #(coords - vector3(startservice[1],startservice[2],startservice[3]))
			if distance <= 3.5 then
				sleep = 5
				DrawText3D(startservice[1],startservice[2],startservice[3]-0.3, "Entregador de ~g~PI~w~ZZ~r~AS")
				if IsControlJustPressed(0,38) then
					service = true
					TriggerEvent("Notify","importante","Trabalho iniciado com sucesso, retire a moto", 4000)
					TriggerServerEvent("colocar-uniforme:pizza")
				end
			end
		else
            local distance = #(coords - vector3(garage[1],garage[2],garage[3]))

			if distance <= 3.5 and not pickvehicle then
				sleep = 5
				DrawMarker(37,garage[1],garage[2],garage[3]-0.8,0,0,0,0.0,0,0,0.6,0.6,0.5,209,185,72,100,0,0,0,1)

				if IsControlJustPressed(0,38) then
					pickvehicle = true
					spawnPizza()
					spawnMotorcycle()
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
---------------------------------------------------------------------
-- PEGAR A PIZZA DO BALCAO (NÃO MEXER)
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local coords = vector3(GetEntityCoords(ped))

		if pickvehicle and not carrypizza then
            local distance = #(coords - vector3(spawnprop[1],spawnprop[2],spawnprop[3]))

			if distance <= 2.0 then
				if pizza < 5 and not readydelivery then
					sleep = 5
					DrawText3D(spawnprop[1],spawnprop[2],spawnprop[3]-0.6, "Use ~y~E~w~ para pegar")	

					if IsControlJustPressed(0,38) then
						TriggerEvent("Notify","importante","Coloque a pizza na <b>motocicleta</b>", 4000)
						pickPizza()
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
---------------------------------------------------------------------
-- COLOCAR OU TIRAR PIZZA DA CAIXA (NÃO MEXER)
---------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local coords = vector3(GetEntityCoords(ped))

		if pickvehicle then
			local veh = getMotorcyclePosition(2)
			local PositionMotorcycle = GetOffsetFromEntityInWorldCoords(veh,0.0,-0.9,0.0)
            local distance = #(coords - vector3(PositionMotorcycle.x,PositionMotorcycle.y,PositionMotorcycle.z))

			if not IsPedInAnyVehicle(ped) and distance <= 2.0 then
				if carrypizza then
					sleep = 5 
					DrawText3D(PositionMotorcycle.x,PositionMotorcycle.y,PositionMotorcycle.z+0.80,"~y~E~w~ Guardar pizza  "..pizza.."/5")
					if IsControlJustPressed(0,38) and GetEntityModel(veh) == vehiclejobhash then
						putPizza()
						pizza = pizza + 1
						if pizza == 5 and not readydelivery then
							TriggerEvent("Notify","importante","Suba na <b>moto</b> para realizar as entregas", 8000)
							vRP.playSound("5_SEC_WARNING","HUD_MINI_GAME_SOUNDSET")
							readydelivery = true
							startRoute()
						end
						if not readydelivery then
							spawnPizza()
						end
					end
				elseif pizza > 0 then
					sleep = 5
					DrawText3D(PositionMotorcycle.x,PositionMotorcycle.y,PositionMotorcycle.z+0.80,"~y~E~w~ Pegar pizza  "..pizza.."/5")
					if IsControlJustPressed(0,38) then
						pickPizza()
						pizza = pizza - 1
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
-----------------------------------------------------------------------------------------
-- JOB PIZZA DELIVERY FOR UNITY NETWORK
-- BY CADUHDEV (LIBERADO GRATUITAMENTE PARA COMUNIDADE SE VENDER VOCÊ VAI MORRER EM MESES)
-- DEIXA OS CRÉDITOS QUERIDO :3
-----------------------------------------------------------------------------------------