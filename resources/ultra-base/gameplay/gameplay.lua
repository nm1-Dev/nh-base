local function StartingRP()
    Citizen.CreateThread(function()
        for i=1, 25 do
            EnableDispatchService(i, 25)
        end
        for i=0, 255 do
            if NetworkIsPlayerConnected(i) then
                if NetworkIsPlayerConnected(i) and GetPlayerPed(i) ~= GetPlayerPed(i) then
                    SetCanAttackFriendly(GetPlayerPed(i), true, true)
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            local ped = PlayerId()
            SetPlayerWantedLevel(ped, 0, false)
            SetPlayerWantedLevelNow(ped, false)
        end
    end)
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 2729.47, 1514.56, 23.7, false)
            if dist < 150.0 then
                ClearAreaOfCops(pos, 400.0)
            else
                Wait(5000)
            end
        end
    end)
end

AddEventHandler('ultra-base:Start', function()
    StartingRP()
end)