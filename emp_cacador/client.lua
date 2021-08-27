local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_cacador")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pedlist = {}
local progress = false
local segundos = 0
local selectnpc = nil

local functions = {
	[1] = { hash = 1457690978, item = "cormorantmeat", nome = "Cormorão" },
	[2] = { hash = 402729631, item = "crowmeat", nome = "Corvo" },
	[3] = { hash = -1430839454, item = "eaglemeat", nome = "Águia" },
	[4] = { hash = -664053099, item = "deermeat", nome = "Cervo" },
	[5] = { hash = -541762431, item = "rabbitmeat", nome = "Coelho" },
	[6] = { hash = 1682622302, item = "coyotemeat", nome = "Coyote" },
	[7] = { hash = 1318032802, item = "wolfmeat", nome = "Lobo" },
	[8] = { hash = 307287994, item = "cougarmeat", nome = "Puma" },
	[9] = { hash = -832573324, item = "boarmeat", nome = "Javali" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = GetPlayerPed(-1)
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local random,npc = FindFirstPed()
			repeat
				if IsControlJustPressed(1,38) then
					local x2,y2,z2 = table.unpack(GetEntityCoords(npc))
					if IsPedDeadOrDying(npc) and not IsPedAPlayer(npc) and Vdist(x,y,z,x2,y2,z2) <= 1.5 and not IsPedInAnyVehicle(npc) and not selectnpc and not pedlist[npc] then
						for k,v in pairs(functions) do
							if GetEntityModel(npc) == v.hash and (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_KNIFE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_DAGGER") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHETE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SWITCHBLADE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HATCHET") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BATTLEAXE") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_STONE_HATCHET")) then
								if emP.checkPayment(v.item) then
									selectnpc = npc
									pedlist[npc] = true
									segundos = 10
									vRP._playAnim(false,{"amb@medic@standing@kneel@idle_a","idle_a"},true)
									SetEntityHeading(ped,GetEntityHeading(npc))
									TriggerServerEvent("tryDeleteEntity",PedToNet(npc))
									TriggerEvent('cancelando',true)

									repeat
										Citizen.Wait(10)
									until not selectnpc

									vRP._stopAnim(false)
									vRP._DeletarObjeto()
									concluido = true
								end
							end
						end
					end
				end
				concluido,npc = FindNextPed(random)
			until not concluido
			EndFindPed(random)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMINUINDO O TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				selectnpc = nil
				TriggerEvent('cancelando',false)
			end
		end
	end
end)