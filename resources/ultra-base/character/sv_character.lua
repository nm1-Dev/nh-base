RegisterServerEvent('ultra-base:Char:Join')
AddEventHandler('ultra-base:Char:Join', function()
    local src = source
    TriggerClientEvent('ultra-base:Char:setupCharacter', src)
end)

RegisterServerEvent('ultra-base:Char:ServerSelect')
AddEventHandler('ultra-base:Char:ServerSelect', function(cinfo)
    local src = source
    local steam = GetPlayerIdentifiers(src)[1]
    local license = GetPlayerIdentifiers(src)[2]
    Ultra.DB.LoadCharacter(src, license, steam, cinfo)
end)

Ultra.Functions.RegisterServerCallback('ultra-base:GetChar', function(source, cb)
    local id = GetPlayerIdentifiers(source)[1]
    MySQL.query('SELECT * from PLAYERS WHERE identifier = ?', {
        ['identifier'] = id
    }, function(result)
        if result then
            cb(result)
            print('[ultra-base] Loaded Character')
        end
    end)
end)