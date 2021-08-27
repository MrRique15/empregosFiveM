local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_hospital")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------

local macas = {
	{ ['x'] = 348.28, ['y'] = -581.52, ['z'] = 43.29, ['x2'] = 349.01, ['y2'] = -582.0, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 350.87, ['y'] = -582.4, ['z'] = 43.29, ['x2'] = 351.54, ['y2'] = -583.08, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 353.48, ['y'] = -583.39, ['z'] = 43.29, ['x2'] = 354.17, ['y2'] = -583.98, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 355.75, ['y'] = -584.53, ['z'] = 43.29, ['x2'] = 356.53, ['y2'] = -584.95, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 366.36, ['y'] = -581.34, ['z'] = 43.29, ['x2'] = 367.25, ['y2'] = -581.65, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 361.88, ['y'] = -579.73, ['z'] = 43.29, ['x2'] = 361.02, ['y2'] = -579.42, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 358.11, ['y'] = -579.19, ['z'] = 43.29, ['x2'] = 359.03, ['y2'] = -579.35, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 355.87, ['y'] = -578.31, ['z'] = 43.29, ['x2'] = 356.75, ['y2'] = -578.47, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 353.41, ['y'] = -577.4, ['z'] = 43.29, ['x2'] = 354.44, ['y2'] = -577.44, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 350.87, ['y'] = -576.4, ['z'] = 43.29, ['x2'] = 351.88, ['y2'] = -576.68, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 330.41, ['y'] = -568.99, ['z'] = 43.29, ['x2'] = 331.44, ['y2'] = -569.2, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 327.48, ['y'] = -568.06, ['z'] = 43.29, ['x2'] = 328.44, ['y2'] = -568.27, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 324.71, ['y'] = -566.75, ['z'] = 43.29, ['x2'] = 325.48, ['y2'] = -567.06, ['z2'] = 44.21, ['h'] = 334.32 },
	{ ['x'] = 328.36, ['y'] = -575.05, ['z'] = 43.29, ['x2'] = 329.26, ['y2'] = -575.36, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 325.3, ['y'] = -573.82, ['z'] = 43.29, ['x2'] = 326.17, ['y2'] = -574.14, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 322.2, ['y'] = -572.83, ['z'] = 43.29, ['x2'] = 322.98, ['y2'] = -573.1, ['z2'] = 44.21, ['h'] = 160.8 },
	{ ['x'] = 483.92, ['y'] = -997.72, ['z'] = 34.91, ['x2'] = 322.98, ['y2'] = -573.1, ['z2'] = 44.21, ['h'] = 103.61 },
	{ ['x'] = 1826.36, ['y'] = 3677.71, ['z'] = 34.28, ['x2'] = 1825.78, ['y2'] = 3678.59, ['z2'] = 35.19, ['h'] = 119.50 },  -- HP SAND 1
	{ ['x'] = 1828.77, ['y'] = 3675.49, ['z'] = 34.28, ['x2'] = 1829.74, ['y2'] = 3676.08, ['z2'] = 35.19, ['h'] = 217.34 },  -- HP SAND 2
	{ ['x'] = 1819.8, ['y'] = 3672.21, ['z'] = 34.28, ['x2'] = 1820.41, ['y2'] = 3671.42, ['z2'] = 35.2, ['h'] = 127.68 },  -- HP SAND 3
	{ ['x'] = 1818.94, ['y'] = 3673.54, ['z'] = 34.28, ['x2'] = 1818.16, ['y2'] = 3673.94, ['z2'] = 35.14, ['h'] = 153.03 }  -- HP SAND 4



}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEITANDO 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 1.1 then
				idle = 10
				drawTxt("~r~E~w~  DEITAR    ~g~G~w~  TRATAMENTO",4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
				end
				if IsControlJustPressed(0,47) then
					if emP.checkServices() then
						TriggerEvent('tratamento-macas')
						TriggerEvent('resetDiagnostic')
						TriggerEvent('resetWarfarina')
						SetEntityCoords(ped,v.x2,v.y2,v.z2)
						SetEntityHeading(ped,v.h)
						vRP._playAnim(false,{{"amb@world_human_sunbathe@female@back@idle_a","idle_a"}},true)
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end
			end
		end
		Citizen.Wait(idle)
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

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	TriggerEvent("cancelando",true)
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+1)
		Citizen.Wait(1500)
	until GetEntityHealth(PlayerPedId()) >= 400 or GetEntityHealth(PlayerPedId()) <= 100
	TriggerEvent("Notify","importante","Tratamento concluido.")
	TriggerEvent("cancelando",false)
end)