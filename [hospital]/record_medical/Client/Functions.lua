function keysNUI(value)
    if value == 'up' then
        SendNUIMessage({
            upSelected = true
        })
    elseif value == 'down' then
        SendNUIMessage({
            downSelected = true
        })
    elseif value == 'left' then
        SendNUIMessage({
            leftSelected = true
        })
    elseif value == 'right' then
        SendNUIMessage({
            rightSelected = true
        })
    elseif value == 'enter' then
        SendNUIMessage({
            enterSelected = true
        })
    elseif value == 'back' then
        SendNUIMessage({
            goBack = true
        })
    end
end

function openNUI(value)
    SendNUIMessage({
        open = value
    })
end

function InsertValue(title, text, maxsize)
	AddTextEntry('FMMC_KEY_TIP1', title)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", text, "", "", "", maxsize)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500)
		return result
	else
		Wait(500)
		return nil
	end
end