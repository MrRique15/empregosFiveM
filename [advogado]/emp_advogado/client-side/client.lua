-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
emP = Tunnel.getInterface("emp_advogado")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundo = 0
local CoordX = -80.51
local CoordY = -801.86
local CoordZ = 243.40

---- -80.51,-801.86,243.40

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function ()
   while true do
      local timeDistance = 500
      if not processo then
         local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordX,CoordY,CoordZ)
         local distance = GetDistanceBetweenCoords(CoordX,CoordY,cdz,x,y,z,true)

         if distance <= 30 then
            timeDistance = 5
            DrawMarker(23,CoordX,CoordY,CoordZ-0.96,0,0,0,0,0,0,1.0,1.0,1.0,255,100,0,30,0,0,0,0)
            if distance <= 1.2 then
               drawTxt("PRESSIONE  ~b~E~w~  PARA LANÇAR OS PROCESSOS NO SISTEMA",4,0.5,0.93,0.50,255,255,255,180)
               if IsControlJustPressed(0,38) then
                  if emP.checkPermission() then
                     if emP.checkPayment() then
                        processo = true
                        segundo = 30
                        TriggerEvent('cancelando',true)
                        vRP._playAnim(false,{{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
                     end
                  else
                     TriggerEvent("Notify","negado","<b>Você Não é Advogado</b>")
                  end
               end
            end
         end
      end
      if processo then
         timeDistance = 5
         drawTxt("AGUARDE  ~b~"..segundo.." ~w~ SEGUNDOS PARA LANÇAR OS PROCESSOS NO SISTEMA",4,0.5,0.93,0.50,255,255,255,180)
      end
      Citizen.Wait(timeDistance)
   end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTADOR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function ()
   while true do
      Citizen.Wait(1000)
      if processo then
         if segundo > 0 then
            segundo = segundo - 1
            if segundo == 0 then
               processo = false
               vRP._stopAnim(false)
               TriggerEvent('cancelando',false)
            end
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
