local selectedChar = false
local cam = nil
local cam2 = nil
local bannedName = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('ultra-base:Char:Joined')
            TriggerEvent('ultra-base:Char:StartCamera')
            TriggerEvent('ultra-ui:client:closeCharUI')
            TriggerEvent('ultra-base:PlayerLogin')
            selectedChar(true)
            return
        end
    end
end)

RegisterNetEvent('ultra-base:Char:Selecting')
AddEventHandler('ultra-base:Char:Selecting', function()
    selectedChar(true)
end)

GetCInfo = function(source, cb)
    local src = source
    TriggerServerEvent('ultra-base:GetCInfo', src)
end

RegisterNUICallback('createCharacter', function(data)
    local CharData = data.charData
    for theData, value in pairs(CharData) do
        if theData == 'firstname' or theData == 'lastname' then
            reason  = verifyName(value)
            print(reason)
            if reason ~= '' then
                break
            end
        end
    end
    if reason == '' then
        TriggerServerEvent('ultra-base:server:CreateCharacter', CharData)
    end
end)

function verifyName(name)
    for k,v in pairs(bannedName) do
        if name == v then
            local reason = 'This name is banned'
            TriggerServerEvent('ultra-base:Disconnect', reason)
        end
    end
end

RegisterNUICallback('deleteCharacter', function(data)
    local CharData = data
    TriggerServerEvent('ultra-base:DeleteChar', CharData)
end)

RegisterNetEvent('ultra-base:Char:setupCharacter')
AddEventHandler('ultra-base:Char:setupCharacter', function()
    Ultra.Functions.TriggerServerCallback('ultra-base:GetChar', function(data)
        SendNUIMessage({
            type = "setupCharacters",
            characters = data
        })
    end)
end)

RegisterNUICallback('selectCharacters', function(data)
    local cInfo = tonumber(data.cInfo)
    selectedChar(false)
    TriggerServerEvent('ultra-base:Char:ServerSelect', cInfo)
    TriggerEvent('ultra-spawn:openMneu')
    SetTimecycleModifier('default')
    SetCamActive(cam, false)
    DestroyCam(cam, false)
end)

RegisterNUICallback('CloseChar', function(data)
    selectedChar(false)
end)

function selectedChar(value)
    SetNuiFocus(value, value)
    SendNuiMessage({
        type = "charSelect",
        value = value
    })
    selectingChar = false
end

RegisterNetEvent('ultra-base:Char:StartCam')
AddEventHandler('ultra-base:Char:StartCam', function()
    DoScreenFadeIn(10)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -358.56, -981.96, 286.25, 320.0, 0.00, -50.00, 90.0, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)