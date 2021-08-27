-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end

-- -1082.03, -247.45, 37.77
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "fotografia" then
		TriggerServerEvent("fotos-vender","fotografia")
	elseif data == "otima-fotografia" then
		TriggerServerEvent("fotos-vender","otima-fotografia")	

	elseif data == "fechar-nui-fotos" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local timeDistance = 500
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1082.2, -248.05, 37.77,true)
		if distance <= 3 then
			timeDistance = 5
			DrawMarker(29,-1082.2, -248.05, 37.77-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,250,96,0,50,0,0,0,1) 
			if distance <= 1.2 then
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)