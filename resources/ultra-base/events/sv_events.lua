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
        Data.license, Data.cinfo, Data.firstname, Data.lastname, Data.nationality, Data.cash, Data.bank, Data.dirtymoney
    })
    print('[Ultra-Base]' ..Data.cinfo..' Was Successfully Created')
    Ultra.Functions.LoadPlayer(source, Data)
end

Ultra.Functions.LoadPlayer = (function(source, pData, cinfo)
    local src = source
    local identifier = pData.identifier
    Citizen.Wait(100)
    MySQL.Async.fetchAll('SELECT * FROM players WHERE license = @license AND cinfo = @cinfo' {
        ['license'] = identifier,
        ['cinfo'] = cinfo
    }, function(result)
        MySQL.Async.execute('UPDATE players SET firstname = @firstname AND lastname = @lastname WHERE license = @license AND cinfo = @cinfo', {
            ['firstname'] = pData.firstname,
            ['lastname'] = pData.lastname,
            ['license'] = identifier,
            ['cinfo'] = cinfo
        })
        Ultra.Player.LoadData(source, pData, cid)
        Citizen.Wait(100)
        local Player = Ultra.Functions.GetPlayer(src)
        TriggerClientEvent('ultra-base:client:SetCharData', src, {
            identifier = result[1].license,
            cinfo = result[1].cinfo,
            firstname = result[1].firstname,
            lastname = result[1].lastname,
            nationality = result[1].nationality,
            cash = result[1].cash,
            bank = result[1].bank,
            dirtymoney = result[1].dirtymoney
        })
        TriggerClientEvent('ultra-base:PlayerLoaded', source)
    end)
end)

Ultra.Functions.AddCommands = function(command, callback, suggestion, args)
    Ultra.Commands[command] = {}
    Ultra.Commands[command].cmd = callback
    Ultra.Commands[command].args = args or -1
    if suggestion then
        if not suggestion.params or not type(suggestion.params) == 'table' then
            suggestion.params = {}
        end
        if not suggestion.help or not type(suggestion.help) == 'string' then
            suggestion.help = {}
        end
        Ultra.CommandsSuggestions[command] = suggestion
    end
    RegisterCommand(command, function(source, args)
        if(args <= Ultra.Commands[command].args and #args == Ultra.Commands[command].args or Ultra.Commands[command].args == -1) then
            callback(source, args, Ultra.Players[source])
        else
            TriggerClientEvent('ultra-base:client:Notify', source, 'error', 'Invalid Arguments')
        end
    end, false)
end

Ultra.Functions.setupAdmin = function(player, group)
    local identifier = player.Data.identifier
    local cinfo = player.Data.cinfo
    MySQL.Async.execute('DELETE FROM ranking WHERE license = ?', { identifier })
    Wait(1000)
    MySQL.insert('INSERT INTO ranking (group, license) VALUES (@group, @license)', {
        group, identifier
    })
    print('[Ultra-Base] ' .. cinfo .. ' Was Successfully Added To Group ' .. group)
    TriggerClientEvent('ultra-admin:client:UpdateGroup', player.Data.PlayerId, group)
end


Ultra.Functions.BuildCommands = function(source)
    local src = source
    for k, v in pairs(Ultra.CommandsSuggestions) do
        TriggerClientEvent('chat:addSuggestion', src, '/'..k, v.help, v.params)
    end
end

Ultra.Functions.ClearCommands = function(source)
    local src = source
    for k, v in pairs(Ultra.CommandsSuggestions) do
        TriggerClientEvent('chat:removeSuggestion', src, '/'..k, v.help, v.params)
    end
end