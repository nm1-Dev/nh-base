-- Call ultra base
Ultra.Functions = Ultra.Functions or {}
Ultra.Commands = {}
Ultra.CmdSuggestions = {}
Ultra.ServerCallbacks = Ultra.ServerCallbacks or {}
Ultra.ServerCallback =  {}

Ultra.Functions.RegisterServerCallback = function(name, cb)
    Ultra.ServerCallback[name] = cb
end

Ultra.Functions.TriggerServerCallback = function(name, requestId, source, cb, ...)
    if Ultra.ServerCallbacks[name] then
        Ultra.ServerCallbacks[name](source, cb, ...)
    else
        print('[ultra-base] Callback not found')
    end
end

Ultra.Functions.GetPlayer = function(source)
    if Ultra.Players[source] then
        return Ultra.Players[source]
    end
end

Ultra.Functions.StaffPlayer = function(source)
    if Ultra.Staff[source] then
        return Ultra.Staff[source]
    end
end

RegisterNetEvent('ultra-base:server:UpdatePlayerData')
AddEventHandler('ultra-base:server:UpdatePlayerData', function()
    local src = source
    local Player = Ultra.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SaveData()
    end
end)


-- Character SQL Data
Ultra.Functions.CreateNewPlayer = function(source, Data)
    MySQL.insert('INSERT INTO players (license, cinfo, firstname, lastname, nationality, cash, bank, dirtymoney) VALUES (@license, @cinfo, @firstname, @lastname, @nationality, @cash, @bank, @dirtymoney)', {
        Data.license, Data.cinfo, Data.firstName, Data.lastName, Data.nationality, Data.cash, Data.bank, Data.dirtymoney
    })
    print('[Ultra-Base]' ..Data.cinfo..' Was Successfully Created')
    Ultra.Functions.LoadPlayer(source, Data)
end

Ultra.Functions.LoadPlayer = (function(source, pData, cinfo)
    local src = source
    local identifier = pData.identifier
    Citizen.Wait(100)
end)