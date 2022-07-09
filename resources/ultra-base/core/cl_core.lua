Ultra = {}
Ultra.Base = {}

function Ultra.Base.Start(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent('ultra-base:Start')
                TriggerServerEvent('ultra-base:server:Start')
                break
            end
        end
    end)
end

Ultra.Base.Start(self)

RegisterNetEvent('ultra-base:client:getObject')
AddEventHandler('ultra-base:client:getObject', function(callback)
    callback(ultra)
    print('[ultra-base] Call Back' .. nh)
end)