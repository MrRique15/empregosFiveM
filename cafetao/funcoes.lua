
--PARA CRIAR UM TEXTO 3D NA TELA FLUTUANTE EM ALGUMA POSIÇÃO

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
        SetTextColour(255, 255, 255, 255)
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

-- NOTIFICAÇÃO PADRÃO DO GTA V
function notificacao(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--DESENHA TEXTO EM ALGUM LUGAR NA TELA 
function drawTxt(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

-- VERIFICA SE O PLAYER ESTA PROXIMO DE ALGUMA COISA - PASSE AS COORDENADAS , e o Distancia o valor minimo de distancia
function proximo(x,y,z,distancia)
	local player = GetPlayerPed()
	local playerCoords = GetEntityCoords(player, 0)

	local distance =
		GetDistanceBetweenCoords(x,y,z, playerCoords["x"], playerCoords["y"], playerCoords["z"], true)
	if (distance <= distancia) then
		return true
	end
end



function CriaBlipEntrega(locais,destino,blipCor)
	blip = AddBlipForCoord(locais[destino].x,locais[destino].y,locais[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,blipCor)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Destino")
	EndTextCommandSetBlipName(blip)
end

function CriaBlipBoate(locais,blipCor)
	blip = AddBlipForCoord(locais.x,locais.y,locais.z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,blipCor)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Vanilla Club")
	EndTextCommandSetBlipName(blip)
end