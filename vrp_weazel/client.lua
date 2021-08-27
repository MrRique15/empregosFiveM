local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
job = Tunnel.getInterface("vrp_weazel")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local parte = 0
local CoordenadaX = -575.01
local CoordenadaY = -940.66
local CoordenadaZ = 23.87                ------ -575.01, -940.66, 23.87
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 118.88, ['y'] = -1020.91, ['z'] = 29.31, ['h'] = 298.20, ['camx'] = 159.36, ['camy'] = -992.79, ['camz'] = 31.12, ['lugar'] = "Praça" },
	[2] = { ['x'] = 657.75, ['y'] = 1215.46, ['z'] = 322.06, ['h'] = 160.96, ['camx'] = 634.59, ['camy'] = 1157.19, ['camz'] = 320.15, ['lugar'] = "Cidade" },
	[3] = { ['x'] = 698.26, ['y'] = -129.5, ['z'] = 74.82, ['h'] = 145.71, ['camx'] = 632.24, ['camy'] = -244.63, ['camz'] = 57.28, ['lugar'] = "Rodovia" },
	[4] = { ['x'] = 279.52, ['y'] = -1555.84, ['z'] = 29.23, ['h'] = 186.99, ['camx'] = 286.27, ['camy'] = -1588.07, ['camz'] = 33.21, ['lugar'] = "Atraçao" },
	[5] = { ['x'] = -376.05, ['y'] = -2336.11, ['z'] = 63.62, ['h'] = 345.25, ['camx'] = -336.23, ['camy'] = -2079.74, ['camz'] = 56.37, ['lugar'] = "Estadio" },
	[6] = { ['x'] = -1355.15, ['y'] = -1258.61, ['z'] = 4.9, ['h'] = 75.75, ['camx'] = -1517.25, ['camy'] = -1188.29, ['camz'] = 13.61, ['lugar'] = "Pier" }, 
	[7] = { ['x'] = -383.04, ['y'] = 1223.39, ['z'] = 325.65, ['h'] = 326.36, ['camx'] = -368.35, ['camy'] = 1261.81, ['camz'] = 331.30, ['lugar'] = "Trilha" },
	[8] = { ['x'] = -513.49, ['y'] = -256.8, ['z'] = 35.61, ['h'] = 30.50, ['camx'] = -518.46, ['camy'] = -248.99, ['camz'] = 36.28, ['lugar'] = "Prefeitura" }, 
	[9] = { ['x'] = 1136.65, ['y'] = -262.31, ['z'] = 69.11, ['h'] = 258.33, ['camx'] = 1222.37, ['camy'] = -281.55, ['camz'] = 72.27, ['lugar'] = "Favela da Barragem" },  
	[10] = { ['x'] = 2428.47, ['y'] = 1012.41, ['z'] = 85.39, ['h'] = 10.66, ['camx'] = 2360.66, ['camy'] = 1273.72, ['camz'] = 92.85, ['lugar'] = "Catavento" }, 
	[11] = { ['x'] = -296.23, ['y'] = 2829.89, ['z'] = 58.13, ['h'] = 329.86, ['camx'] = -288.44, ['camy'] = 2844.29, ['camz'] = 55.65, ['lugar'] = "Cemiterio" },  
	[12] = { ['x'] = -1548.52, ['y'] = 2742.77, ['z'] = 17.89, ['h'] = 168.94, ['camx'] = -1574.58, ['camy'] = 2637.48, ['camz'] = 10.18, ['lugar'] = "Paisagem" },
	[13] = { ['x'] = -2677.47, ['y'] = 2590.09, ['z'] = 16.7, ['h'] = 79.21, ['camx'] = -2792.67, ['camy'] = 2610.99, ['camz'] = 15.32, ['lugar'] = "Mar" }, 
	[14] = { ['x'] = -816.57, ['y'] = -261.44, ['z'] = 37.03, ['h'] = 311.18, ['camx'] = -799.47, ['camy'] = -231.51, ['camz'] = 37.68, ['lugar'] = "Concessionaria" }, 
	[15] = { ['x'] = 183.77, ['y'] = 183.53, ['z'] = 105.54, ['h'] = 299.56, ['camx'] = 229.06, ['camy'] = 213.76, ['camz'] = 106.46, ['lugar'] = "Banco Central" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIANDO TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('vrp_weazel:permissao')
AddEventHandler('vrp_weazel:permissao',function()
	if not servico then
		servico = true
		TriggerEvent("Notify","importante","Voce entrou em <b>Serviço</b>, pegue a <b>Van</b>!")
		ColocarRoupa()
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
		local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)
		if not servico then
			if distance <= 15 then
				timeDistance = 5
				DrawText3D(CoordenadaX,CoordenadaY,CoordenadaZ+0.47, "~w~Fotografo", 1.0, 4)
			    DrawText3D(CoordenadaX,CoordenadaY,CoordenadaZ+0.33, "~b~Elysium News", 0.9, 1)
			    DrawMarker(34, CoordenadaX,CoordenadaY,CoordenadaZ-0.1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 65, 105, 255, 50, 0, true, false, false)
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						TriggerServerEvent('vrp_weazel:permissao')
					end
				end
			end
		elseif servico and parte == 0 and not holdingCam then
			timeDistance = 5
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(-556.26,-937.84,23.84)
			local distance = GetDistanceBetweenCoords(-556.26,-937.84,cdz,x,y,z,true)
			if distance <= 20 then
				DrawMarker(21,-556.26,-937.84,23.84-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						Fade(1200)
				        TriggerEvent("Notify","importante","Voce pegou a <b>Van</b> na garagem, agora va tirar as <b>Fotos</b>!")
		                spawnVan()
		                selecionado = math.random(15)
			            CriandoBlip(locs,selecionado)
		                parte = 1
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)


function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

function FadeRoupa(time,tipo,idle_copy)
	DoScreenFadeOut(800)
	Wait(time)
	if tipo == 1 then 
		vRP.setCustomization(idle_copy)
	else
		TriggerServerEvent("vrp_weazel:roupa")
	end
	DoScreenFadeIn(800)
end

local RoupaEntregador = {
	["Entregador"] = {
		[1885233650] = {                                      
			[1] = {0,0,0},
			[2] = {70,0,0},
			[3] = {85,0,1},
			[4] = {17,0,1},
			[5] = {0,0,1},
			[6] = {31,0,1},
			[7] = {0,0,1},
			[8] = {15,0,1},
			[9] = {0,0,1},
			[10] = {-1,0,0},
			[11] = {73,13,1},
			[0] = {0,0,0},
			["p1"] = {-1,0},
			["p2"] = {36,0},
			["p0"] = {55,4},
			["p6"] = {1,0},
			["p7"] = {-1,0},
			
        },
        [-1667301416] = {
            [1] = { -1,0 },
            [3] = { 14,0 },
            [4] = { 14,1 },
            [5] = { 42,0 },
            [6] = { 10,1 },
            [7] = { -1,0 },
            [8] = { 6,0 },
            [9] = { -1,0 },
            [10] = { -1,0 },
            [11] = { 250,3 },
            ["p0"] = { 58,0 },
            ["p1"] = { 5,0 }
        }
	}
}

function ColocarRoupa()
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
			local custom = RoupaEntregador["Entregador"]
			if custom then
				local old_custom = vRP.getCustomization()
				local idle_copy = {}

				idle_copy = job.SaveIdleCustom(old_custom)
				idle_copy.modelhash = nil

				for l,w in pairs(custom[old_custom.modelhash]) do
						idle_copy[l] = w
				end
				FadeRoupa(1200,1,idle_copy)
			end
		end
	end
end

function MainRoupa()
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
	        FadeRoupa(1200,2)
	    end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if servico and not holdingCam and parte == 1 then
			timeDistance = 5
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)
			local vehicle = GetPlayersLastVehicle()
			if GetEntityModel(vehicle) == 1162065741 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,65,105,255,50,0,0,0,1)
				if distance <= 3.0 and not IsPedInAnyVehicle(ped) then
					DrawText3Ds(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.35,"~w~Local:~b~ "..locs[selecionado].lugar)
					if IsControlJustPressed(0,38) and distance <= 1.2 then
			            SetEntityCoords(ped,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-1)
			            SetEntityHeading(ped,locs[selecionado].h)
			            vRP._CarregarObjeto("amb@world_human_paparazzi@male@base","base","prop_pap_camera_01",15,28422)
			            SetTimeout(1000,function()
							holdingCam = true
							local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							local fov_max = 70.0
                            local fov_min = 5.0
                            local fov = (fov_max+fov_min)*0.5
			                AttachCamToEntity(cam, PlayerPedId(), 0.0, 0.0, 1.0, true)
			                PointCamAtCoord(cam, locs[selecionado].camx,locs[selecionado].camy,locs[selecionado].camz)
			                SetCamFov(cam2, fov)
			                RenderScriptCams(true, false, 0, 1, 0)
						end)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
---------------------------------------------------------------------------
-- FUNÇOES CAMERA
---------------------------------------------------------------------------
local CinematicCamMaxHeight = 1.1
local CinematicCamBool = false
local w = 0
---------------------------------------------------------------------------
-- CAMERA
---------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if holdingCam then
			timeDistance = 5
			DisplayRadar(false)
			TriggerEvent('vrp_weazel:texto', 'Pressione ~INPUT_FRONTEND_RDOWN~ para tirar a Foto')
			if IsControlJustPressed(0,191) then
				holdingCam = false
				vRP.playSound("Camera_Shoot","Phone_Soundset_Franklin")
                CinematicCamBool = not CinematicCamBool
                CinematicCamDisplay(CinematicCamBool)
		        SetTimeout(300,function()
		        	ClearTimecycleModifier()
			        RenderScriptCams(false, false, 0, 1, 0)
			        DestroyCam(cam, false)
		        	CinematicCamBool = not CinematicCamBool
                    CinematicCamDisplay(CinematicCamBool)
			        RemoveBlip(blips)
					vRP.DeletarObjeto()
					vRP.stopAnim(false)
					backentrega = selecionado
					while true do
						if backentrega == selecionado then
							selecionado = math.random(15)
						else
							break
						end
						Citizen.Wait(1)
					end
					job.checkPayment()
					CriandoBlip(locs,selecionado)
					TriggerEvent("Notify","importante","Vá até o próximo local e tire <b>1x Fotografia</b>.")
		        end)
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
---------------------------------------------------------------------------
-- EVENTOS CAMERA
---------------------------------------------------------------------------
RegisterNetEvent('vrp_weazel:texto')
AddEventHandler('vrp_weazel:texto', function(text)
     BeginTextCommandDisplayHelp('STRING')
     AddTextComponentSubstringPlayerName(text)
     EndTextCommandDisplayHelp(0, false, true, -1)
end)

Citizen.CreateThread(function() 
    minimap = RequestScaleformMovie("minimap")
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do 
            Wait(1)
        end
    end
    while true do
        Citizen.Wait(1)
        if w > 0 then
            DrawRects()
        end
        if CinematicCamBool then
            DESTROYHudComponents()
        end
    end
end)

function DESTROYHudComponents() 
    for i = 0, 22, 1 do
        if IsHudComponentActive(i) then
            HideHudComponentThisFrame(i)
        end
    end
end

function DrawRects() 
    DrawRect(0.0, 0.0, 2.0, w, 0, 0, 0, 255)
    DrawRect(0.0, 1.0, 2.0, w, 0, 0, 0, 255)
end

function CinematicCamDisplay(bool) 
    if bool then
        for i = 0, CinematicCamMaxHeight, 0.1 do 
            Wait(10)
            w = i
        end
    else
    	DisplayRadar(true)
        w = -0.01 
    end
end  
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if servico then
			timeDistance = 5
			drawTxt("~y~PRESSIONE ~r~[F7] ~w~SE DESEJA FINALIZAR O SERVIÇO",4,0.270,0.95,0.35,255,255,255,200)
			if IsControlJustPressed(0,168) then
				servico = false
				parte = 0
				RemoveBlip(blips)
				MainRoupa()
				vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				TriggerEvent('cancelando',false)
				if nveh then
			        TriggerServerEvent("trydeleteveh",VehToNet(nveh))
			        nveh = nil
			    end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function spawnVan()
	local mhash = "rumpo"
	if not nveh then
	while not HasModelLoaded(mhash) do
	    RequestModel(mhash)
	    Citizen.Wait(10)
	end
		local ped = PlayerPedId()
		local x,y,z = vRP.getPosition()
		nveh = CreateVehicle(mhash,-556.28430175781,-933.45678710938,23.847702026367+0.5,271.43,true,false)
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

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.34, 0.34)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.028, 0, 0, 0, 78)
end

function DrawText3D(x,y,z, text, scl, font) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

	local scale = (1/dist)*scl
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
	if onScreen then
		SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 180)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
	end
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Leite")
	EndTextCommandSetBlipName(blips)
end