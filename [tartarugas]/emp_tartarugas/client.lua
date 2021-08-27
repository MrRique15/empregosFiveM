local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_tartarugas")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
local list = {}
-- teste
local selecionado = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS ninhos
-----------------------------------------------------------------------------------------------------------------------------------------
local ninhos = {
	{ 3223.13,5342.82,4.105 }, 
	{ 3218.07,5342.927,4.69 },
	{ 3215.46,5346.26,5.65 }, 
	{ 3208.99,5348.94,7.30 }, 
	{ 3205.28,5348.01,7.87 }, 
	{ 3202.35,5343.38,7.46 }, 
	{ 3207.75,5341.56,6.23 }, 
	{ 3217.16,5338.93,4.19 }, 
	{ 3216.73,5333.57,3.16 }, 
	{ 3212.97,5328.58,2.94 }, 
	{ 3210.44,5321.48,2.54 }, 
	{ 3205.94,5328.54,4.40 }, 
	{ 3208.14,5332.78,4.48 }, 
	{ 3202.81,5336.00,5.94 }, 
	{ 3213.20,5312.99,1.50 }
}

local abatedor = {
	{ -102.15, 6208.62, 31.03 }, 
	{ 3218.07,5342.927,4.69 },
	{ 3215.46,5346.26,5.65 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local t = 1000
		if not processo then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(ninhos) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
				--if distance <= 25 and not list[k] and GetEntityModel(vehicle) == -1207771834 then
				if distance <= 25 and not list[k] then
				t = 10
					DrawMarker(21,v[1],v[2],v[3],0,0,0,0,180.0,130.0,0.5,0.5,0.4,250,100,50,150,1,0,0,1)
					if distance <= 1.2  then
						drawTxt("PRESSIONE  ~r~E~w~ PARA PEGAR ~o~TARTARUGAS~w~",4,0.5,0.90,0.50,255,255,255,200)
						if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) --[[and GetEntityModel(vehicle) == -1207771834]] then
							list[k] = true
							processo = true
							segundos = 3
							SetEntityCoords(ped,v[1],v[2],v[3]-1)
							--SetEntityHeading(ped,v[4])
							--vRP._playAnim(false,{{"amb@prop_human_movie_bulb@base","base"}},true)
							vRP._playAnim(true,{{"pickup_object","pickup_low"}},false)
							emP.checkFrutas()
							TriggerEvent('cancelando',true)
						end
					end
				end
			end
		--else
			--drawTxt("AGUARDE ~w~ SEGUNDOS ATÉ TERMINAR DE COLHER AS ~o~LARANJAS",4,0.5,0.90,0.50,255,255,255,200)
		end
	Citizen.Wait(t)
	end
end)

Citizen.CreateThread(function()
	while true do
		local t = 1000
		if not processo then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(abatedor) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
				if distance <= 25 and not list[k] then
				t = 10
					DrawMarker(21,v[1],v[2],v[3],0,0,0,0,180.0,130.0,0.5,0.5,0.4,250,100,50,150,1,0,0,1)
					if distance <= 1.2  then
						drawTxt("PRESSIONE  ~r~E~w~ PARA MATAR ~o~AS TARTARUGAS (3x Tartarugas)~w~",4,0.5,0.90,0.50,255,255,255,200)
						if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
							list[k] = true
							processo = true
							segundos = 3
							SetEntityCoords(ped,v[1],v[2],v[3]-1)
							vRP._playAnim(true,{{"mini@repair","fixing_a_ped"}},false)
							emP.checkPaymenttart()
							TriggerEvent('cancelando',true)
						end
					end
				end
			end
		end
	Citizen.Wait(t)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo and segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				vRP._stopAnim(false)
				TriggerEvent('cancelando',false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(600)
		list = {}
	end
end)



Citizen.CreateThread(function()
	while true do
		local t = 1000
			local ped = PlayerPedId()
			local bowz,cdz = GetGroundZFor_3dCoord(-101.84,6208.92,31.02)
			local distance = GetDistanceBetweenCoords(-101.84,6208.92,cdz,x,y,z,true)
			if distance <= 1.2 and not processo then
				t = 10
				drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~SEPARAR CARNE DE TARTARUGA  ~r~(3x Tartaruga)",4,0.5,0.90,0.50,255,255,255,200)
				if IsControlJustPressed(0,38) then
					if emP.checkPaymenttart() then
						TriggerEvent('cancelando',true)
						processo = true
						segundos = 5
					end
				end
			end
		if processo then
			drawTxt("AGUARDE ~g~"..segundos.."~w~ SEGUNDOS ATÉ ~y~FINALIZAR O PROCESSO",4,0.5,0.90,0.50,255,255,255,200)
		end
	Citizen.Wait(t)
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

