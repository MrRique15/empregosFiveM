openned = false

CreateThread(function()
    Wait(5000)
    local NameResource = GetCurrentResourceName()
    SendNUIMessage({
        configs = true,
        translate = translate,
        NameResource = NameResource
    })
end)

CreateThread(function()
    while true do
        local sleep = 1000

        if openned then
            if IsControlJustPressed(0, config_key.useMouse) then -- F5
                SendNUIMessage({
                    mouseEnabled = true
                })
                SetNuiFocus(true, true)
            end

            sleep = 10
        else
            sleep = 1000
        end

        Wait(sleep)
    end
end)