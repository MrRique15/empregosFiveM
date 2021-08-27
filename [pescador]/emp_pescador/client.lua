local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_pescador")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------  ['x'] = 1326.41, ['y'] = 4050.83, ['z'] = 47.45
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if not processo then
			local ped = PlayerPedId()
			local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),1306.41,4100.83,33.91)
			if distancia <= 230 then
				timeDistance = 5
				DrawMarker(1,1306.41,4100.83,33.91-1.5,0,0,0,0,0,0,350.0,350.0,50.0,255,255,255,30,0,0,0,0)
				if distancia <= 230 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A PESCARIA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
						if emP.checkPayment() then
							processo = true
							segundos = 20
							if not IsEntityPlayingAnim(ped,"amb@world_human_stand_fishing@idle_a","idle_c",3) then
								vRP._CarregarObjeto("amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",15,60309)
							end
							TriggerEvent('cancelando',true)
						end
					end
				end
			end
		end
		if processo then
			timeDistance = 5
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FISGAR UM PEIXE",4,0.5,0.93,0.50,255,255,255,180)
		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				if not IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_stand_fishing@idle_a","idle_c",3) then
					vRP._stopAnim(false)
					vRP._DeletarObjeto()
				end
				TriggerEvent('cancelando',false)
			end
		end
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