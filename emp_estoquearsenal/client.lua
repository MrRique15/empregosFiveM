local dsRota = false
local dsRotaID = 0
local dsCarregado = false

RegisterNetEvent("DonSpeed:InicioRotaROTA")
AddEventHandler("DonSpeed:InicioRotaROTA",function()
	local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
    if IsVehicleModel(vehicle,GetHashKey("mule4")) then
	    if dsRota == false and dsCarregado == false then
		   dsRota = true
		   CriandoBlip(-1040.48,-850.07,4.88)
		   TriggerServerEvent("colocar-uniforme:arsenal")
		   dsRotaID = 6 
		   TriggerEvent("Notify","importante","Vá receber o carregamento .")
		end
	else
	    TriggerEvent("Notify","importante","Sem o caminhao .")
    end
end)

RegisterNetEvent("DonSpeed:InicioRotaPM")
AddEventHandler("DonSpeed:InicioRotaPM",function()
	local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
    if IsVehicleModel(vehicle,GetHashKey("mule4")) then
	    if dsRota == false and dsCarregado == false then
		   dsRota = true
		   CriandoBlip(-1049.11,-858.47,4.9)
		   TriggerServerEvent("colocar-uniforme:arsenal")
		   dsRotaID = 1
		   TriggerEvent("Notify","importante","Vá receber o carregamento .")
		end
	else
	    TriggerEvent("Notify","importante","Sem o caminhao .")
    end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local cordenadapp = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1049.11,-858.47,4.9,true)
		if cordenadapp < 6.0  then
			timeDistance = 5
		    DrawMarker(20,486.44, -1020.32, 27.41,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,50,0,0,0,0)
			local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
			if IsControlJustPressed(0,38) and IsVehicleModel(vehicle,GetHashKey("mule4")) then
			    if dsRota == true and dsCarregado == false and dsRotaID == 1 then
				    RemoveBlip(DSMark)
					dsRotaID = 2
				    CriandoBlip(-2286.87, 3181.41, 32.28)
		            TriggerEvent("Notify","importante","Vá receber o carregamento, tome cuidado!")
				end
			end
		end	
		local dsdsdsdsdsdsd = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-2286.87,3181.41,32.28,true)
		if dsdsdsdsdsdsd < 6.0  then
			timeDistance = 5
		    DrawMarker(20,-2286.87,3181.41,32.28,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,50,0,0,0,0)
			
			local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
			if IsControlJustPressed(0,38) and IsVehicleModel(vehicle,GetHashKey("mule4")) then
			    if dsRota == true and dsRotaID == 2  then
				    --FreezeEntityPosition(GetPlayerPedId(), true)
				    TriggerEvent("progress",7000,"CARREGANDO")
				    Citizen.Wait(7000)
					--FreezeEntityPosition(GetPlayerPedId(), false)
			        dsRotaID = 3
				    dsCarregado = true
				    TriggerServerEvent('DonSpeed:Carregando')
					RemoveBlip(DSMark)
				    CriandoBlip(-2286.87,3181.41,32.28)
					TriggerEvent("Notify","importante","carregando .")
				end
			end
		end	
		local dsentregue = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-2286.87,3181.41,32.28,true)
		if dsentregue < 6.0  then
			timeDistance = 5
			local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
			if IsControlJustPressed(0,38) and IsVehicleModel(vehicle,GetHashKey("mule4")) then
				if dsCarregado == true and dsRotaID == 3 then
				    RemoveBlip(DSMark)
			        dsCarregado = false
			        dsRota = false
					--FreezeEntityPosition(GetPlayerPedId(), true)
			        TriggerEvent("progress",2000,"DESCARREGANDO")	
				    Citizen.Wait(2000)
					--FreezeEntityPosition(GetPlayerPedId(), false)
				    TriggerServerEvent('DonSpeed:Descarregando')
				    RemoveBlip(DSMark)
					dsRotaID = 0
					TriggerEvent("Notify","importante","Descarregando .")
				end
			end
		end
		Citizen.Wait(timeDistance)	
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ROTAcordenadapp = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1049.11,-858.47,4.9,true)
		if ROTAcordenadapp < 6.0  then
			timeDistance = 5
		    DrawMarker(20,-1049.11,-858.47,4.9,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,50,0,0,0,0)
			local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
			if IsControlJustPressed(0,38) and IsVehicleModel(vehicle,GetHashKey("mule4")) then
			    if dsRota == true and dsCarregado == false and dsRotaID== 6 then
				    RemoveBlip(DSMark)
					dsRotaID = 7
				    CriandoBlip(-2286.87,3181.41,32.28)
		            TriggerEvent("Notify","importante","Vá receber o carregamento .")
				end
			end
		end	
		local ROTAcordenadapa = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-2286.87,3181.41,32.28,true)
		if ROTAcordenadapa < 6.0  then
			timeDistance = 5
		    DrawMarker(20,-2286.87,3181.41,32.28,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,50,0,0,0,0)
			local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
			if IsControlJustPressed(0,38) and IsVehicleModel(vehicle,GetHashKey("mule4")) then
			    if dsRota == true and dsRotaID == 7 then
				   -- FreezeEntityPosition(GetPlayerPedId(), true)
				    TriggerEvent("progress",7000,"CARREGANDO")
				    Citizen.Wait(7000)
					--FreezeEntityPosition(GetPlayerPedId(), false)
			        dsRotaID = 8
				    dsCarregado = true
				    TriggerServerEvent('DonSpeed:Carregando')
					RemoveBlip(DSMark)
				    CriandoBlip(-1049.11,-858.47,4.9)
					TriggerEvent("Notify","importante","carregando .")
				end
			end
		end	
		local ROTAdsentregue = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1049.11,-858.47,4.9,true)
		if ROTAdsentregue < 6.0  then
		    timeDistance = 5
			local vehicle = GetVehiclePedIsUsing(PlayerPedId(-1))
			if IsControlJustPressed(0,38) and IsVehicleModel(vehicle,GetHashKey("mule4")) then
				if dsCarregado == true and dsRotaID == 8 then
			        dsCarregado = false
			        dsRota = false
					dsRotaID = 0
					--FreezeEntityPosition(GetPlayerPedId(), true)
			        TriggerEvent("progress",2000,"DESCARREGANDO")	
				    Citizen.Wait(2000)
				--	FreezeEntityPosition(GetPlayerPedId(), false)
				    TriggerServerEvent('DonSpeed:Descarregando')
				    RemoveBlip(DSMark)
					TriggerEvent("Notify","importante","Descarregando .")
				end
			end
		end	
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if dsRota == true then
			timeDistance = 5
			drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
			if IsControlJustPressed(0,168) then
				dsRota = false
				RemoveBlip(DSMark)
				TriggerServerEvent("tirar-uniforme:arsenal")
				TriggerEvent("Notify","importante","Cancelado missao.")
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

function CriandoBlip(x,y,z)
	DSMark = AddBlipForCoord( x,y,z)
	SetBlipSprite(DSMark,1)
	SetBlipColour(DSMark,5)
	SetBlipScale(DSMark,0.4)
	SetBlipAsShortRange(DSMark,false)
	SetBlipRoute(DSMark,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota")
	EndTextCommandSetBlipName(DSMark)
end