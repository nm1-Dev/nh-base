RegisterServerEvent('nh-base:server:Start')
AddEventHandler('nh-base:server:Start', function()
    print('[nh-base] Server Start')
    local src = source
    Citizen.CreateThread(function()
        local license = GetPlayerIdentifiers(src)[1]
        if not license then
            print('[nh-base] No License')
            DropPlayer(src, 'You Dont Have A License , Try To Close And Open FiveM Again')
        end
        return
    end)
end)

RegisterNetEvent('nh-base:server:getObject')
AddEventHandler('nh-base:server:getObject', function(callback)
    callback(nh)
end)