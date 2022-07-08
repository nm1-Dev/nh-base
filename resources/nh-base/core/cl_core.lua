function nh.Base.Start(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent('nh-base:Start')
                TriggerServerEvent('nh-base:server:Start')
                break
            end
        end
    end)
end

nh.Base.Start(self)

RegisterNetEvent('nh-base:client:getObject')
AddEventHandler('nh-base:client:getObject', function(callback)
    callback(nh)
    print('[nh-base] Call Back' .. nh)
end)