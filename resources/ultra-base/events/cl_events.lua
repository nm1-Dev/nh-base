-- Call ultra base
Ultra.Functions = Ultra.Functions or {}
Ultra.RequestID = Ultra.RequestID or {}
Ultra.ServerCallback = Ultra.ServerCallback or {}
Ultra.ServerCallbacks = {}
Ultra.CurrentRequestId = 0

Ultra.Functions.GetKey = function(key)
    local Keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
        ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
        ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
        ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
        ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
        ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
        ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
    }
    return Keys[key]
end

Ultra.Functions.GetPlayerData = function(source)
    return Ultra.GetPlayerData
end

Ultra.Functions.DeleteVehicle = function(vehicle)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, false, true)
        DeleteVehicle(vehicle)
    end
end

Ultra.Functions.GetVehicleDirection = function()
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    local inDirection = GetOffsetFromEntityInWorldCoords(player, 0.0, 10.0, 0.0)
    local rayHandle = StartShapeTestRay(playerCoords, inDirection, 10, player, 0)
    local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 and GetEntityType(entityHit) == 2 then
        return entityHit
    end

    return nil
end

Ultra.Functions.DeleteObject = function(object)
    if DoesEntityExist(object) then
        SetEntityAsMissionEntity(object, false, true)
        DeleteObject(object)
    end
end

Ultra.Functions.GetClosestPlayer = function(coords)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    local closestPlayers = PXCore.Functions.GetPlayersFromCoords(coords)
    local closestDistance = -1
    local closestPlayer = -1
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

-- Get Players
Ultra.Functions.GetAllPlayers = function()
	return GetActivePlayers()
end
Ultra.Functions.GetVehicles = function()
    return GetGamePool('CVehicle')
end
Ultra.Functions.GetObjects = function()
    return GetGamePool('CObject')
end

-- CallBacks
Ultra.Functions.TriggerServerCallback = function(name, cb, ...)
    Ultra.ServerCallback[Ultra.CurrentRequestId] = cb
    TriggerServerEvent('ultra-base:server:TriggerServerCallback', name, Ultra.CurrentRequestId, ...)
    if Ultra.CurrentRequestId < 65535 then
        Ultra.CurrentRequestId = Ultra.CurrentRequestId + 1
    else
        Ultra.CurrentRequestId = 0
    end
end


-- Events
RegisterNetEvent('ultra-base:client:ServerCallback')
AddEventHandler('ultra-base:client:ServerCallback', function(requestID, ...)
    if Ultra.ServerCallbacks[requestID] then
        Ultra.ServerCallbacks[requestID](...)
        Ultra.ServerCallbacks[requestID] = nil
    else
        print('[ultra-base] Callback not found')
    end
end)

RegisterNetEvent('ultra-base:client:SetCharacterData')
AddEventHandler('ultra-base:client:SetCharacterData', function(Player)
    pData = Player
end)