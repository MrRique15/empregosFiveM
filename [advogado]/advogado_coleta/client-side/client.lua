-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
emP = Tunnel.getInterface("advogado_coleta")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES   6741333008,361328125,8795166
-----------------------------------------------------------------------------------------------------------------------------------------
local service = false
local selecionado = 0
local CoordX = -71.95
local CoordY = -813.95
local CoordZ = 243.385

-- -71.95, -813.95, 243.385

local locs = {
   [1] = {x=-1991.55,y=-290.93,z=32.09},
   [2] = {x=-1790.45,y=-400.43,z=46.48},
   [3] = {x=-1007.45,y=-487.07,z=39.97},
   [4] = {x=-583.31,y=-194.37,z=38.32},
   [5] = {x=-336.89,y=207.47,z=88.57},
   [6] = {x=315.11,y=-128.01,z=69.97},
   [7] = {x=795.5579,y=-1725.411,z=30.523},
	[8] = {x=-1089.938,y=548.16,z=103.632},
   [9] = {x=-130.9081,y=6551.729,z=29.8751},
   [10] = {x=-115.69,y=-373.02,z=38.1187},
	[11] = {x=-1621.754,y= 15.30750,z=62.535},
	[12] = {x=-1452.9091,y= 545.554,z=120.981},
   [13] = { x = 130.39, y = -1853.16, z = 25.23 },
	[14] = { x = 1289.37, y = -1710.45, z = 55.47 },
	[15] = { x = 123.95, y = 64.71, z = 79.74 },
   [16] = {x=751.40,y=223.00,z=87.42},
   [17] = {x=780.58,y=568.07,z=127.52},
   [18] = {x=781.31,y=1274.65,z=361.28},
   [19] = {x=632.64,y=-3015.06,z=7.33},
   [20] = {x=-191.64,y=-653.10,z=40.48},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function ()
   while true do
      local timeDistance = 500
      if not service then
         local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordX,CoordY,CoordZ)
         local distance = GetDistanceBetweenCoords(CoordX,CoordY,cdz,x,y,z,true)

         if distance <= 30 then
            timeDistance = 5
            DrawMarker(23,CoordX,CoordY,CoordZ-0.96,0,0,0,0,0,0,1.0,1.0,1.0,255,100,0,30,0,0,0,0)
            if distance <= 1.2 then
               drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A ROTA",4,0.5,0.93,0.50,255,255,255,180)
               if IsControlJustPressed(0,38) then
                  if emP.checkPermission() then
                     service = true
                     selecionado = math.random(20)
                     TriggerServerEvent("colocar-uniforme:cafetao")
                     CriandoBlip(locs,selecionado)
                  end
               end
            end
         end
      end
      Citizen.Wait(timeDistance)
   end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
      if service then
         timeDistance = 5
         local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(1,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.99,0,0,0,0,0,0,1.3,1.3,1.0,255,100,0,50,0,0,0,0)
				if distance <= 1.3 then
               drawTxt("PRESSIONE  ~b~E ~w~PARA COLETAR OS DOCUMENTOS",4,0.5,0.93,0.50,255,255,255,180)
               if IsControlJustPressed(0,38) then
                  if emP.checkPayment() then
                     RemoveBlip(blips)
                     backentrega = selecionado
                     while true do
                        if backentrega == selecionado then
                           selecionado = math.random(20)
                        else
                           break
                        end
                        Citizen.Wait(1)
                     end
                     CriandoBlip(locs,selecionado)
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
      if service then
         timeDistance = 5
         drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
			if IsControlJustPressed(0,168) then
				service = false
				RemoveBlip(blips)
            TriggerServerEvent("tirar-uniforme:adv")
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

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coleta de Documentos")
	EndTextCommandSetBlipName(blips)
end
