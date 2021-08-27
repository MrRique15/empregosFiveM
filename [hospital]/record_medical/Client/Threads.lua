CreateThread(function()
    local name = GetCurrentResourceName()
    Wait(5000)
    SendNUIMessage({
        config = config,
        translate = translate,
        NameResource = name
    })
end)

CreateThread(function()
    while true do
        local sleep = 10
        if oppened then
            DisableControlAction(0, config_keys.moveUP)
            DisableControlAction(0, config_keys.moveDown)
            DisableControlAction(0, config_keys.moveLeft)
            DisableControlAction(0, config_keys.moveRight)
            
            if IsDisabledControlJustPressed(0, config_keys.moveUP) then
                keysNUI('up')
            elseif IsDisabledControlJustPressed(0, config_keys.moveDown) then
                keysNUI('down')
            elseif IsDisabledControlJustPressed(0, config_keys.moveLeft) then
                keysNUI('left')
            elseif IsDisabledControlJustPressed(0, config_keys.moveRight) then
                keysNUI('right')
            elseif IsControlJustPressed(0, config_keys.enter) then
                keysNUI('enter')
            elseif IsControlJustPressed(0, config_keys.back) then
                keysNUI('back')
            end
        else
            sleep = 1000
        end

        Wait(sleep)
    end
end)