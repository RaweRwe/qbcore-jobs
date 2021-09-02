local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

QBCore = nil
isLoggedIn = false
local butcher = false
local PlayerJob = {}

CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Wait(200)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = QBCore.Functions.GetPlayerData().job

    if PlayerJob.name == "butcher" then
        while QBCore.Functions.GetPlayerData().job == nil do Wait(0) end
    
        local slaughterblip = AddBlipForCoord(-72.62614, 6268.054)
        SetBlipSprite (slaughterblip, 266)
        SetBlipDisplay(slaughterblip, 4)
        SetBlipScale  (slaughterblip, 0.7)
        SetBlipAsShortRange(slaughterblip, true)
        SetBlipColour(slaughterblip, 47)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Slaughter House")
        EndTextCommandSetBlipName(slaughterblip)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    --[[ RemoveMiningBlips() ]]
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    local OldlayerJob = PlayerJob.name
    PlayerJob = JobInfo

    if PlayerJob.name == "butcher" then
        while QBCore.Functions.GetPlayerData().job == nil do Wait(0) end
    
    local slaughterblip = AddBlipForCoord(-72.62614, 6268.054)
        SetBlipSprite (slaughterblip, 266)
        SetBlipDisplay(slaughterblip, 4)
        SetBlipScale  (slaughterblip, 0.7)
        SetBlipAsShortRange(slaughterblip, true)
        SetBlipColour(slaughterblip, 47)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Slaughter House")
        EndTextCommandSetBlipName(slaughterblip)
    end
end)

CreateThread(function()
    while true do
        pedId = PlayerPedId()
        plyId = PlayerId()
        Wait(5000)
    end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
	end
end)

CreateThread(function()
    while true do 
    if isLoggedIn and QBCore ~= nil then
        if PlayerJob.name == "butcher" then
            local pedcoord = GetEntityCoords(pedId)
            local dst = GetDistanceBetweenCoords(pedcoord, -68.39154, 6248.499, 31.4, true)
            if dst <= 4.5 then
                DrawText3D(-68.39154, 6248.499, 31.4, "[~g~E~w~] - to catch alive Chicken")
            else
                Wait(1000)
            end
            if dst <= 1 and IsControlJustPressed(0, Keys["E"]) then
                QBCore.Functions.Progressbar("hospital_checkin", "Catching Chicken", 5000, false, true)
                alivechickenanim()
                TriggerServerEvent("qb-alivechicken")
                ClearTask()
                end
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
    if isLoggedIn and QBCore ~= nil then
            if PlayerJob.name == "butcher" then
                local pedcoord = GetEntityCoords(pedId)
                local dst = GetDistanceBetweenCoords(pedcoord, -95.62312, 6207.062, 31.02504, true)
                if dst <= 5 then
                    DrawText3D(-95.62312, 6207.062, 31.02504, "[~g~E~w~] - to portion Chicken")
                else
                    Wait(1000)
                end
                if dst <= 1 and IsControlJustPressed(0, Keys["E"]) then
                    portionanim(1)
                    Wait(50)
                    TriggerServerEvent("qb-rawchicken")
                    Wait(1000)
                    end
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do 
        if isLoggedIn and QBCore ~= nil then
            if PlayerJob.name == "butcher" then
                local pedcoord = GetEntityCoords(pedId)
                local dst = GetDistanceBetweenCoords(pedcoord, -100.4728, 6202.435, 31.02504, true)
                if dst <= 5 then
                    DrawText3D(-100.4728, 6202.435, 31.02504, "[~g~E~w~] - to portion Chicken")
                else
                    Wait(1000)
                end
                if dst <= 1 and IsControlJustPressed(0, Keys["E"]) then
                    portionanim(2)
                    Wait(50)
                    TriggerServerEvent("qb-rawchicken")
                    Wait(1000)
                end
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
    if isLoggedIn and QBCore ~= nil then
            if PlayerJob.name == "butcher" then
                local pedcoord = GetEntityCoords(pedId)
                local dst = GetDistanceBetweenCoords(pedcoord, -106.3441, 6204.656, 31.02625, true)
                if dst <= 5 then
                    DrawText3D(-106.3441, 6204.656, 31.02625, "[~g~E~w~] - to pack Slaughtered Chicken")
                else
                    Wait(2000)
                end
                if dst <= 2 and IsControlJustPressed(0, Keys["E"]) then
                    animpack()
                    TriggerServerEvent("qb-packchicken")
                    Wait("2000")
                end
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        if isLoggedIn and QBCore ~= nil then
            if PlayerJob.name == "butcher" then
                local pedcoord = GetEntityCoords(pedId)
                local dst = GetDistanceBetweenCoords(pedcoord, -104.0056, 6206.675, 31.02505, true)
                if dst <= 5 then
                    DrawText3D(-104.0056, 6206.675, 31.02505, "[~g~E~w~] - to pack Slaughtered Chicken")
                else
                    Wait(2000)
                end
                if dst <= 2 and IsControlJustPressed(0, Keys["E"]) then
                    animpack()
                    TriggerServerEvent("qb-packchicken")
                    Wait("2000")
                end
            else
                Wait(2000)
            end
        else
            Wait(2000)
        end
        Wait(1)
    end
end)

function ClearTask()
	FreezeEntityPosition(pedId, false)
    ClearPedTasks(pedId)
end

function loadanim(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end


function portionanim(stanowisko)
    loadanim("anim@amb@business@coc@coc_unpack_cut_left@")
    FreezeEntityPosition(pedId,true)
    TaskPlayAnim(pedId, "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
    local PedCoords = GetEntityCoords(pedId)
    nozyk = CreateObject(GetHashKey('prop_knife'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
    AttachEntityToEntity(nozyk, pedId, GetPedBoneIndex(pedId, 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
    if stanowisko == 1 then
    SetEntityHeading(pedId, 311.0)
    kurczak = CreateObject(GetHashKey('prop_int_cf_chick_01'),-94.87, 6207.008, 30.08, true, true, true)
    SetEntityRotation(kurczak,90.0, 0.0, 45.0, 1,true)
    elseif stanowisko == 2 then
    SetEntityHeading(pedId, 222.0)
    kurczak = CreateObject(GetHashKey('prop_int_cf_chick_01'),-100.39, 6201.56, 29.99, true, true, true)
    SetEntityRotation(kurczak,90.0, 0.0, -45.0, 1,true)
    end
    Wait(6000)
    FreezeEntityPosition(pedId,false)
    DeleteEntity(kurczak)
    DeleteEntity(nozyk)
    ClearPedTasks(pedId)
end



function animpack()
    FreezeEntityPosition(pedId, true)
    SetEntityHeading(pedId, 40.0)
	local PedCoords = GetEntityCoords(pedId)
	mieso = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(mieso, pedId, GetPedBoneIndex(pedId, 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	karton = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
	AttachEntityToEntity(karton, pedId, GetPedBoneIndex(pedId, 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
	pakuje = 1
	loadanim("anim@heists@ornate_bank@grab_cash_heels")
    TaskPlayAnim(pedId, "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
    Wait(6000)
    FreezeEntityPosition(pedId, true)
	ClearPedTasks(pedId)
	DeleteEntity(karton)
	DeleteEntity(mieso)
    ClearPedTasksImmediately(pedId)
    FreezeEntityPosition(pedId, false)
end




function giveAnim()
    local pid = pedId
    loadanim('amb@medic@standing@kneel@base')
    loadanim('anim@gangops@facility@servers@bodysearch@')
    FreezeEntityPosition(pid, true)

    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(pedId, 0.0, 0.9, -0.98))
    prop1 = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)

    TaskPlayAnim(pedId, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
    TaskPlayAnim(pedId, "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

    Wait(6000)
    DeleteObject(prop1)
    ClearPedTasksImmediately(pedId)
    FreezeEntityPosition(pedId, false)
end


function alivechickenanim()
    local player = pedId
    FreezeEntityPosition(player, true)
    loadanim('amb@prop_human_bum_bin@base')
    TaskPlayAnim(pedId, "amb@prop_human_bum_bin@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Wait(4000)
    ClearPedTasksImmediately(pedId)
    FreezeEntityPosition(pedId, false)
end

addBlip = function(x, y, z, sprite, colour, text)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, 0.65)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

function RemoveMiningBlips()
    RemoveBlip(-72.62614, 6268.054)
end
